class_name DemonNeed
extends Node

signal need_catastrophy(need_name: String)
signal need_update(need_name: String, old_val: int, new_val: int)

@export var need_name: String
@export var curr_val: int = 750
const MAX_VAL: int = 1000
const MIN_VAL:int  = -1000
@export var decay: int = 1
var next_tick_delta: int = -decay

func tick(_curr_day: int, _curr_time: int):
	var old_val: int = curr_val
	set_value(curr_val + next_tick_delta)
	if curr_val == MIN_VAL:
		need_catastrophy.emit(need_name)
	need_update.emit(need_name, old_val, curr_val)
	next_tick_delta = -decay

func replenish(val: int):
	next_tick_delta = val

func set_value(val: int):
	curr_val = clamp(val, MIN_VAL, MAX_VAL)
