class_name Demon
extends Node

signal demon_died
signal summoning(summon: Summon)
signal need_update(need_name: String, old_val: int, new_val: int)
signal skill_update(skill_name: String,
	old_lvl: int, old_exp: int,
	curr_lvl: int, curr_exp: int,
	lvl_up: int)

@export var mood: int = 750
var curr_action: DemonAction = null :
	set(action_template):
		if action_template == null:
			if curr_action != null:
				curr_action.queue_free()
				curr_action = null
				action_selector.show_actions()
			return
		curr_action = action_template.duplicate()
		curr_action.action_end.connect(end_action)
		action_selector.hide_actions()

@onready var needs: Dictionary = {
	"Hunger": $Needs/Hunger,
	"Energy": $Needs/Energy,
	"Bladder": $Needs/Bladder,
	"Hygiene": $Needs/Hygiene,
	"Comfort": $Needs/Comfort,
	"Fun": $Needs/Fun,
}
@onready var need_catastrophe_actions: Dictionary = {
	"Hunger": $ActionTemplates/Die,
	"Energy": $ActionTemplates/Collapse,
	"Bladder": $ActionTemplates/BladderFailure,
}
@onready var skills: Dictionary = {
	"Metamorphosis": $Skills/Metamorphosis,
	"Possession": $Skills/Possession,
	"Precognition": $Skills/Precognition,
	"Bargaining": $Skills/Bargaining,
}
@onready var summoning_action: DemonAction = $ActionTemplates/Summoned

@onready var action_templates: Node = $ActionTemplates
@onready var action_selector: DemonActionSelector = $ActionSelector

const summon_scene: PackedScene = preload("res://scenes/summon.tscn")
var summon: Summon = null

@onready var sprite: AnimatedSprite2D = $DemonSprite
@onready var thought: DemonThought = $DemonThought

@onready var catastrophe_sound: AudioStreamPlayer = $CatastropheSound

func _ready():
	# prepare action selector
	var actions: Array[DemonAction] = []
	for node in action_templates.get_children():
		var action: DemonAction = node as DemonAction
		if action.selectable:
			actions.append(node as DemonAction)
	action_selector.populate(actions)

func tick(curr_day: int, curr_time: int):
	if summon == null:
		# prepare new summon
		summon = summon_scene.instantiate()
		add_child(summon)
		summon.init(curr_day, curr_time)
		summoning.emit(summon)
	else:
		var time_left_start = summon.time_left_until_start(curr_day, curr_time)
		if time_left_start == 0:
			# interrupt everything, summon demon
			thought.stop()
			if not summon.check_requirements(mood, skills):
				# GAME OVER
				demon_died.emit()
			else:
				curr_action = summoning_action
				curr_action.until_time_of_day = summon.time_end
	

	# update action
	if curr_action != null:
		curr_action.tick(curr_day, curr_time, mood, needs, skills)
	
	# update needs
	for n_name in needs:
		needs[n_name].tick(curr_day, curr_time)
	update_mood()

	# update skills
	for s_name in skills:
		skills[s_name].tick(curr_day, curr_time)
	
	# set animation
	if curr_action == null:
		# no action, show mood
		if mood > 0:
			sprite.animation = &"noaction_happy"
		else:
			sprite.animation = &"noaction_sad"
	else:
		sprite.animation = curr_action.animation_name

func update_mood():
	var need_vals: Array[int] = []
	for n_name in needs:
		need_vals.append(needs[n_name].curr_val)
	# weighted average of needs to calculate mood
	var old_mood: int = mood
	need_vals.sort()
	mood = need_vals[0] * 6
	for i in range(1, need_vals.size()):
		mood += need_vals[i] * (6 - i)
	mood = mood / (6 + 5 + 4 + 3 + 2 + 1)
	need_update.emit("Mood", old_mood, mood)
	
func end_action(end_summon:bool, die: bool):
	curr_action = null
	if end_summon:
		summon.queue_free()
		summon = null
		for n in needs:
			needs[n].sickness()
	if die:
		demon_died.emit()

func _on_need_update(need_name: String, old_val: int, new_val: int):
	need_update.emit(need_name, old_val, new_val)
func _on_skill_update
(
	skill_name: String,
	old_lvl: int, old_exp: int, 
	new_lvl: int, new_exp: int,
	lvl_up: int
):
	skill_update.emit(skill_name, old_lvl, old_exp, new_lvl, new_exp, lvl_up)


func _on_action_selector_item_clicked(index: int, _at_position: Vector2, mouse_button_index: int):
	if mouse_button_index != MOUSE_BUTTON_LEFT:
		return
	var action = action_templates.get_child(index)
	if action.check_mood(mood, needs):
		curr_action = action
		thought.stop()
	else:
		thought.think("I am not in the mood for that!", 3.0)

func _on_need_catastrophy(need_name: String):
	if curr_action != null and curr_action.catastrophe:
		return
	if need_name in need_catastrophe_actions:
		curr_action = need_catastrophe_actions[need_name]
		catastrophe_sound.play()
