extends Node

@export var demon: Demon
@export var ticker: Timer
@export var hud: Hud

# curr_time: number of minutes passed since in-game midnight
# start at 09:00
const MINUTES_IN_DAY: int = 1440
@export var day_start_time: int = 540
var curr_time: int = day_start_time
var curr_day: int = 0

func _on_ticker_timeout():
	demon.tick()
	curr_time = (curr_time + 1) % MINUTES_IN_DAY
	if curr_time == 0:
		curr_day += 1


func _on_pause_pressed():
	ticker.paused = !ticker.paused


func _on_demon_need_update(need_name: String, old_val: int, new_val: int):
	hud.update_need_bar(need_name, old_val, new_val)
