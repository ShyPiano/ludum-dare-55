class_name DemonActionSelector
extends ItemList

func populate(actions: Array[DemonAction]):
	for a in actions:
		add_item(a.action_name)
