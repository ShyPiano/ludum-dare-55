class_name Hud
extends CanvasLayer

signal pause_pressed
signal fast_frwd_pressed

@onready var need_bars: Dictionary = {
	"Hunger" = $NeedBarsBox/HungerNeedBar,
	"Energy" = $NeedBarsBox/EnergyNeedBar,
	"Bladder" = $NeedBarsBox/BladderNeedBar,
	"Hygiene" = $NeedBarsBox/HygieneNeedBar,
	"Comfort" = $NeedBarsBox/ComfortNeedBar,
	"Fun" = $NeedBarsBox/FunNeedBar,
}

@onready var clock: Label = $Clock
@onready var date: Label = $Date

func _on_pause_btn_pressed():
	pause_pressed.emit()
func _on_fast_frwd_btn_pressed():
	fast_frwd_pressed.emit()

func update_need_bar(need_name: String, _old_val: int, new_val: int):
	if need_name == "Mood":
		pass
		# TODO update mood bar
	else:
		need_bars[need_name].value = new_val

func update_clock(curr_day: int, curr_time: int):
	date.set_text(str("Day ", curr_day + 1))
	var hour_str: String = str((curr_time / 60)).pad_zeros(2)
	var min_str: String = str(curr_time % 60).pad_zeros(2)
	clock.set_text(hour_str + ":" + min_str)
