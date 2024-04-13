class_name Demon
extends Node

signal demon_died

var curr_action: DemonAction = null :
	set(action_template):
		if action_template == null:
			if curr_action != null:
				curr_action.queue_free()
				curr_action = null
			return
		curr_action = action_template.duplicate()
		curr_action.action_end.connect(end_action)

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

@export var action_templates: Node
@export var action_selector: DemonActionSelector

func _ready():
	# prepare action selector
	var actions: Array[DemonAction] = []
	for node in action_templates.get_children():
		var action: DemonAction = node as DemonAction
		if action.selectable:
			actions.append(node as DemonAction)
	action_selector.populate(actions)
	action_selector.visible = false

func tick(curr_day: int, curr_time: int):
	# update action
	if curr_action != null:
		for n_name in curr_action.needs_effect:
			needs[n_name].replenish(curr_action.needs_effect[n_name])
		curr_action.tick(curr_day, curr_time, needs)
	
	# update needs
	for n_name in needs:
		needs[n_name].tick(curr_day, curr_time)

func end_action(die: bool):
	curr_action = null
	if die:
		demon_died.emit()

signal need_update(need_name: String, old_val: int, new_val: int)
func _on_need_update(need_name, old_val, new_val):
	need_update.emit(need_name, old_val, new_val)


func _on_mouse_click_area_input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int):
	if not event is InputEventMouseButton:
		return
	if curr_action == null and event.is_pressed():
		action_selector.visible = not action_selector.visible


func _on_action_selector_item_clicked(index: int, _at_position: Vector2, _mouse_button_index: int):
	action_selector.visible = false
	action_selector.deselect_all()
	curr_action = action_templates.get_child(index)


func _on_need_catastrophy(need_name: String):
	if need_name in need_catastrophe_actions:
		curr_action = need_catastrophe_actions[need_name]
