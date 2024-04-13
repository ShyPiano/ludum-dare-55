extends Node

const game_over_scene: PackedScene = preload("res://scenes/ui/game_over.tscn")
const world_scene: PackedScene = preload("res://scenes/world.tscn")

@onready var world: Node = $World

func new_game(_demon_name: String = ""):
	clear()
	var w_node: Node = world_scene.instantiate()
	add_child(w_node)
	w_node.game_end.connect(game_over)

func game_over(days_lasted: int):
	clear()
	var go_node: GameOver = (game_over_scene.instantiate() as GameOver)
	add_child(go_node)
	go_node.update_days(days_lasted)
	go_node.retry.connect(new_game)

func clear():
	for child in get_children():
		child.queue_free()
