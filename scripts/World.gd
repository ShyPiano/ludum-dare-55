extends Node

signal game_end(days_lasted: int)

@onready var demon: Demon = $Demon
@onready var ticker: Timer = $Ticker
@onready var hud: Hud = $HUD

# curr_time: number of minutes passed since in-game midnight
# start at 09:00
const MINUTES_IN_DAY: int = 1440
@export var day_start_time: int = 540
var curr_time: int = day_start_time
var curr_day: int = 0
var next_summon: Summon = null

const FAST_FRWD_SPEED: float = 6.0
const NORMAL_SPEED: float = 2.0
var fast_frwd = false

func _ready():
	tick()
	set_ticker_speed()

func tick():
	# update current time
	curr_time = (curr_time + 1) % MINUTES_IN_DAY
	if curr_time == 0:
		curr_day += 1
	hud.update_clock(curr_day, curr_time)
	
	demon.tick(curr_day, curr_time)
	
	if next_summon == null:
		hud.hide_summon_alert()
		hud.hide_summon_success()
		return
	
	var time_until_summon_start: int = next_summon.time_left_until_start(curr_day, curr_time)
	var time_until_summon_end: int = next_summon.time_left_until_end(curr_day, curr_time)
	if time_until_summon_start == MINUTES_IN_DAY:
		# time to show the alert!
		hud.prepare_summon_alert(next_summon)
		hud.show_summon_alert()
	if time_until_summon_start == 0:
		# summon start!
		hud.hide_summon_alert()
		hud.show_summon_success()
	if time_until_summon_end == 0:
		# summon end
		hud.hide_summon_success()

func set_ticker_speed():
	if fast_frwd:
		ticker.wait_time = 1 / FAST_FRWD_SPEED
	else:
		ticker.wait_time = 1 / NORMAL_SPEED

func _on_pause_pressed():
	ticker.paused = !ticker.paused

func _on_fast_fwrd_pressed():
	fast_frwd = not fast_frwd
	set_ticker_speed()


func _on_demon_need_update(need_name: String, old_val: int, new_val: int):
	hud.update_need_bar(need_name, old_val, new_val)
func _on_demon_skill_update
(
	skill_name: String,
	old_lvl: int, old_exp: int,
	new_lvl: int, new_exp: int,
	lvl_up: int
):
	hud.update_skill_bar(skill_name, old_lvl, old_exp, new_lvl, new_exp, lvl_up)

func _on_demon_died():
	game_end.emit(((curr_day * MINUTES_IN_DAY) + curr_time) / MINUTES_IN_DAY)

func _on_demon_summoning(summon: Summon):
	next_summon = summon
