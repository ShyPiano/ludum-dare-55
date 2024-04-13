class_name GameOver
extends Node

@onready var days_label: Label = $DaysLastedLbl
func update_days(days: int):
	var days_str: String
	if days != 1:
		days_str = str(days, " days")
	else:
		days_str = str(days, " day")
	days_label.set_text(days_label.get_text().replace("[DAYS]", days_str))

signal retry(demon_name: String)
func _on_retry_button_pressed():
	# TODO: ask user for a name
	# or generate a random name?
	retry.emit("")
