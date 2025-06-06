extends Node
const SAVE_PATH = "user://save_json.json"
@onready var player: CharacterBody2D = $Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if !file or file.get_line() == "null":
		return
	get_tree().call_group("enemy", "queue_free")
	var json = JSON.new()
	json.parse(file.get_as_text())
	var save_dict = json.data

	
	for enemy_data in save_dict.enemies:
		var enemy = preload("res://enemies/enemy.tscn").instantiate()
		if enemy_data.death == false:
			enemy.position = str_to_var(enemy_data.position)
			add_child(enemy)
	
	get_node("Player").position = str_to_var(save_dict.player["position"])
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Label.text = var_to_str(player.shake_length)
