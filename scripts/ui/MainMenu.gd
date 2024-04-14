extends Node

signal start(name: String)
func _on_button_pressed():
	start.emit("")
