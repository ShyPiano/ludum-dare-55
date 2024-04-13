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

func _on_pause_btn_pressed():
	pause_pressed.emit()
func _on_fast_frwd_btn_pressed():
	fast_frwd_pressed.emit()

func update_need_bar(need_name: String, _old_val: int, new_val: int):
	need_bars[need_name].value = new_val
