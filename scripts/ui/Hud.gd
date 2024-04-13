class_name Hud
extends CanvasLayer

signal pause_pressed

@export var need_bars: Dictionary
func _ready():
	for n in need_bars:
		need_bars[n] = (get_node(need_bars[n]) as ProgressBar)

func _on_pause_btn_pressed():
	pause_pressed.emit()

func update_need_bar(need_name: String, _old_val: int, new_val: int):
	need_bars[need_name].value = new_val
