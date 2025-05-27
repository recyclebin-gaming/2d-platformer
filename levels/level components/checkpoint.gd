extends Node2D
@onready var player: CharacterBody2D = $"/root/world/Player"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == player:
		Global.save_game()
		visible = false
		await get_tree().create_timer(0.3).timeout
		visible = true
