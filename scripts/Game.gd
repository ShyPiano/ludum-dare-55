extends Node

const game_over_scene: PackedScene = preload("res://scenes/ui/game_over.tscn")
const world_scene: PackedScene = preload("res://scenes/world.tscn")

@onready var main_menu: Node = $MainMenu
var game_over: GameOver = null
var world: Node = null
@onready var bg: Node = $Background

func new_game(_demon_name: String = ""):
	clear()
	world = world_scene.instantiate()
	add_child(world)
	world.game_end.connect(show_game_over)

func show_game_over(days_lasted: int):
	clear()
	game_over = (game_over_scene.instantiate() as GameOver)
	add_child(game_over)
	game_over.update_days(days_lasted)
	game_over.retry.connect(new_game)

func clear():
	if main_menu != null:
		main_menu.queue_free()
	if world != null:
		world.queue_free()
	if game_over != null:
		game_over.queue_free()
