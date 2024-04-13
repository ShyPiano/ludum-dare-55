class_name DemonAction
extends Node

signal action_end

@export var action_name: String
@export var needs_effect: Dictionary = {
	"Hunger": 0,
	"Energy": 0,
	"Bladder": 0,
	"Hygiene": 0,
	"Comfort": 0,
	"Fun": 0
}
@export var action_duration: int = -1

func tick():
	if action_duration > 0:
		action_duration -= 1
		if action_duration == 0:
			end_action()

func end_action():
	action_end.emit()
