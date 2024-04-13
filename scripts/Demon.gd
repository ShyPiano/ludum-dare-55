class_name Demon
extends Node

var curr_action: DemonAction = null :
	set(action_template):
		if action_template == null:
			curr_action = null
			return
		curr_action = action_template.duplicate()
		curr_action.action_end.connect(end_action)

@export var needs: Dictionary = {
	"Hunger": NodePath(^"Needs/Hunger"),
	"Energy": NodePath(^"Needs/Energy"),
	"Bladder": NodePath(^"Needs/Bladder"),
	"Hygiene": NodePath(^"Needs/Hygiene"),
	"Comfort": NodePath(^"Needs/Comfort"),
	"Fun": NodePath(^"Needs/Fun")
}

func _ready():
	for n in needs:
		needs[n] = (get_node(needs[n]) as DemonNeed)
	# TODO remove debug action:
	curr_action = get_node(^"ActionTemplates/HaveMeal")

func tick():
	if curr_action != null:
		for n_name in curr_action.needs_effect:
			needs[n_name].replenish(curr_action.needs_effect[n_name])
		curr_action.tick()

	for n_name in needs:
		needs[n_name].tick()

func end_action():
	curr_action = null

signal need_update(need_name: String, old_val: int, new_val: int)
func _on_need_update(need_name, old_val, new_val):
	need_update.emit(need_name, old_val, new_val)
