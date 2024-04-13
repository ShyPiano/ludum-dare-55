class_name Demon
extends Node

signal demon_died
signal need_update(need_name: String, old_val: int, new_val: int)

var mood: int
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
@onready var summoning_action: DemonAction = $ActionTemplates/Summoned

@export var action_templates: Node
@export var action_selector: DemonActionSelector

const summon_scene: PackedScene = preload("res://scenes/summon.tscn")
var summon: Summon = null

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
		summon = summon_scene.instantiate()
		add_child(summon)
		summon.init(curr_day, curr_time)
		print("SUMMON: ", str(summon.time_start), "-", str(summon.time_end))
	elif summon.day_start == curr_day and summon.time_start == curr_time:
		curr_action = summoning_action
		curr_action.until_time_of_day = summon.time_end

	# update action
	if curr_action != null:
		for n_name in curr_action.needs_effect:
			needs[n_name].replenish(curr_action.needs_effect[n_name])
		curr_action.tick(curr_day, curr_time, needs)
	
	# update needs
	var need_vals: Array[int] = []
	for n_name in needs:
		needs[n_name].tick(curr_day, curr_time)
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
		print(mood)
		# TODO make needs go wonky
	if die:
		demon_died.emit()

func _on_need_update(need_name, old_val, new_val):
	need_update.emit(need_name, old_val, new_val)


func _on_action_selector_item_clicked(index: int, _at_position: Vector2, _mouse_button_index: int):
	curr_action = action_templates.get_child(index)


func _on_need_catastrophy(need_name: String):
	if need_name in need_catastrophe_actions:
		curr_action = need_catastrophe_actions[need_name]
