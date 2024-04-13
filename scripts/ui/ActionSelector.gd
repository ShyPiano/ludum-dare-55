class_name DemonActionSelector
extends ItemList

func populate(actions: Array[DemonAction]):
	for a in actions:
		add_item(a.action_name)

func show_actions():
	visible = true

func hide_actions():
	visible = false
	deselect_all()
