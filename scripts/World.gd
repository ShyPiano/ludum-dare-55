extends Node

signal game_end(days_lasted: int)

@export var demon: Demon
@export var ticker: Timer
@export var hud: Hud

# curr_time: number of minutes passed since in-game midnight
# start at 09:00
const MINUTES_IN_DAY: int = 1440
@export var day_start_time: int = 540
var curr_time: int = day_start_time
var curr_day: int = 0

func _ready():
	tick()

func tick():
	curr_time = (curr_time + 1) % MINUTES_IN_DAY
	if curr_time == 0:
		curr_day += 1
	hud.update_clock(curr_day, curr_time)
	demon.tick(curr_day, curr_time)


func _on_pause_pressed():
	ticker.paused = !ticker.paused

const FAST_FRWD_SPEED: float = 5.0
const NORMAL_SPEED: float = 1.0
var fast_frwd = false
func _on_fast_fwrd_pressed():
	if not fast_frwd:
		ticker.wait_time = NORMAL_SPEED / FAST_FRWD_SPEED
	else:
		ticker.wait_time = NORMAL_SPEED
	fast_frwd = not fast_frwd


func _on_demon_need_update(need_name: String, old_val: int, new_val: int):
	hud.update_need_bar(need_name, old_val, new_val)

func _on_demon_died():
	game_end.emit(curr_day)
