class_name DemonSkill
extends Node

signal skill_update(skill_name: String,
	old_lvl: int, old_exp: int,
	curr_lvl: int, curr_exp: int,
	lvl_up: int)

@export var skill_name: String
var curr_lvl: int = 1
var curr_exp: int = 0
var lvl_up_threshold = 60
const THRESHOLD_MULTIPLIER = 1.2
var next_tick_delta: int = 0

func tick(_curr_day: int, _curr_time: int):
	var old_exp: int = curr_exp
	var old_lvl: int = curr_lvl
	inc(next_tick_delta)
	skill_update.emit(skill_name, old_lvl, old_exp, curr_lvl, curr_exp, lvl_up_threshold)
	next_tick_delta = 0

func study(val: int):
	next_tick_delta = val

func inc(new_val: int):
	curr_exp += new_val
	if curr_exp >= lvl_up_threshold:
		curr_exp = 0
		curr_lvl += 1
		lvl_up_threshold *= THRESHOLD_MULTIPLIER
