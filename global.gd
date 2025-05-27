extends Node

const SAVE_PATH = "user://save_json.json"
const HUD = preload("res://ui/hud.tscn")

func death() -> void:
	var hud = HUD.instantiate()
	hud.get_node("Label").text = "death"
	add_child(hud)
	get_node("/root/world").queue_free()
	#get_node("/root/hud.tscn)
	
	
func save_game():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	var save_dict = {
		level = get_tree().get_first_node_in_group("levels").scene_file_path,
		player = {
			position = var_to_str(get_tree().get_first_node_in_group("player").global_position)
		},
		enemies = [],
	}
	
	for enemy in get_tree().get_nodes_in_group("enemy"):
		save_dict.enemies.push_back({
			position = var_to_str(enemy.position),
			death = enemy.death
		})
	file.store_line(JSON.stringify(save_dict))
	
	
func load_game():
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if !file or file.get_line() == "null":
		get_tree().change_scene_to_file("res://levels/World.tscn")
		return
	var json = JSON.new()
	json.parse(file.get_as_text())
	var save_dict = json.data
	
	get_tree().change_scene_to_file(save_dict.level)


func _process(_delta: float) -> void:
	pass
	
