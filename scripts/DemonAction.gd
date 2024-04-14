class_name DemonAction
extends Node

signal action_end(end_summon: bool, die: bool)

@export var action_name: String
@export var selectable: bool = true
@export var catastrophe: bool = false
@export var needs_effect: Dictionary = {
	"Hunger": 0,
	"Energy": 0,
	"Bladder": 0,
	"Hygiene": 0,
	"Comfort": 0,
	"Fun": 0
}
@export var skills_effect: Dictionary = {
	"Metamorphosis": 0,
	"Possession": 0,
	"Precognition": 0,
	"Bargaining": 0,
}

@export var min_needs: Dictionary = {
	"Mood": -1000,
	"Hunger": -1000,
	"Energy": -1000,
	"Bladder": -1000,
	"Hygiene": -1000,
	"Comfort": -1000,
	"Fun": -1000
}
@export var until_time_of_day: int = -1
@export var action_duration: int = -1
@export var until_need_topped: String = ""

@export var die_after_action: bool = false
@export var end_summon_after_action: bool = false

@export var animation_name: StringName = &"noaction_happy"

func tick(_curr_day: int, curr_time: int, mood: int, needs: Dictionary, skills: Dictionary):
	# update needs
	for n_name in needs_effect:
		needs[n_name].replenish(needs_effect[n_name])
	
	# update skills
	for s_name in skills_effect:
		skills[s_name].study(skills_effect[s_name])
	
	# check if action ends
	if not check_mood(mood, needs):
		end_action()
	if curr_time == until_time_of_day:
		end_action()
	if action_duration > 0:
		action_duration -= 1
		if action_duration == 0:
			end_action()
	if until_need_topped != "":
		if needs[until_need_topped].curr_val == needs[until_need_topped].MAX_VAL:
			end_action()

func check_mood(mood: int, needs: Dictionary) -> bool:
	for n_name in min_needs:
		if n_name == "Mood":
			if mood < min_needs[n_name]:
				return false
		elif needs[n_name].curr_val < min_needs[n_name]:
			return false
	return true

func end_action():
	action_end.emit(end_summon_after_action, die_after_action)
