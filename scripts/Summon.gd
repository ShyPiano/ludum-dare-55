class_name Summon
extends Node

const TWENTY_FOUR_HOURS = 1440
const MIN_TIME_BETWEEN_SUMMONS = 1440
const MAX_TIME_BETWEEN_SUMMONS = 2880
const MIN_DURATION = 360
const MAX_DURATION = 720

var day_start: int
var time_start: int
var day_end: int
var time_end: int

func init(curr_day: int, curr_time: int):
	var offset: int = randi_range(MIN_TIME_BETWEEN_SUMMONS, MAX_TIME_BETWEEN_SUMMONS)
	time_start = curr_time + offset
	day_start = curr_day + (time_start / TWENTY_FOUR_HOURS)
	time_start = time_start % TWENTY_FOUR_HOURS
	
	var duration: int = randi_range(MIN_DURATION, MAX_DURATION)
	time_end = time_start + duration
	day_end = day_start + (time_end / TWENTY_FOUR_HOURS)
	time_end = time_end % TWENTY_FOUR_HOURS
