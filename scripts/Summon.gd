class_name Summon
extends Node

const TWENTY_FOUR_HOURS = 1440
const MIN_TIME_BETWEEN_SUMMONS = 1500 # a bit over 24 hours
const MAX_TIME_BETWEEN_SUMMONS = 2800 # a bit under 48 hours
const MIN_DURATION = 240
const MAX_DURATION = 480

var day_start: int
var time_start: int
var day_end: int
var time_end: int

const REQ_MOOD: int = 0;
var req_skills: Dictionary = {
	"Metamorphosis": 0,
	"Possession": 0,
	"Precognition": 0,
	"Bargaining": 0,
}
const DAY_TO_N_SKILLS_MULTIPLIER: float = 1.5

func init(curr_day: int, curr_time: int):
	var offset: int = randi_range(MIN_TIME_BETWEEN_SUMMONS, MAX_TIME_BETWEEN_SUMMONS)
	time_start = curr_time + offset
	day_start = curr_day + (time_start / TWENTY_FOUR_HOURS)
	time_start = time_start % TWENTY_FOUR_HOURS
	
	var duration: int = randi_range(MIN_DURATION, MAX_DURATION)
	time_end = time_start + duration
	day_end = day_start + (time_end / TWENTY_FOUR_HOURS)
	time_end = time_end % TWENTY_FOUR_HOURS
	
	for i in range(ceili((day_start + 1) * DAY_TO_N_SKILLS_MULTIPLIER)):
		req_skills[req_skills.keys().pick_random()] += 1

func check_requirements(mood: int, skills: Dictionary) -> bool:
	if mood < REQ_MOOD:
		return false
	for s_name in req_skills:
		if skills[s_name].curr_lvl < req_skills[s_name]:
			return false
	return true

func time_left_until_start(curr_day: int, curr_time: int) -> int:
	return ((day_start - curr_day) * TWENTY_FOUR_HOURS + (time_start - curr_time))

func time_left_until_end(curr_day: int, curr_time: int) -> int:
	return ((day_end - curr_day) * TWENTY_FOUR_HOURS + (time_end - curr_time))
