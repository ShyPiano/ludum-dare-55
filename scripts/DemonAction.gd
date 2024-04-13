class_name DemonAction
extends Node

signal action_end

@export var action_name: String
@export var selectable: bool = true
@export var needs_effect: Dictionary = {
	"Hunger": 0,
	"Energy": 0,
	"Bladder": 0,
	"Hygiene": 0,
	"Comfort": 0,
	"Fun": 0
}
@export var until_time_of_day: int = -1
@export var action_duration: int = -1
@export var need_topped_for_end: String = ""

@export var die_after_action: bool = false

func tick(_curr_day: int, curr_time: int, needs: Dictionary):
	if curr_time == until_time_of_day:
		end_action()
	if action_duration > 0:
		action_duration -= 1
		if action_duration == 0:
			end_action()
	elif need_topped_for_end != "":
		if needs[need_topped_for_end].curr_val == needs[need_topped_for_end].MAX_VAL:
			end_action()
		

func end_action():
	action_end.emit(die_after_action)
