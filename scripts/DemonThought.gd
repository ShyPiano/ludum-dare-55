class_name DemonThought
extends Sprite2D

@onready var timer: Timer = $Timer
@onready var label: Label = $Label

func _ready():
	visible = false

func think(thought: String, lasting: float):
	label.set_text(thought)
	timer.wait_time = lasting
	timer.start()
	visible = true

func is_thinking() -> bool:
	return visible

func stop():
	visible = false
	timer.stop()

func _on_timer_timeout():
	visible = false
