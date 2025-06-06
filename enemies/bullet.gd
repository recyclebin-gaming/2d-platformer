extends CharacterBody2D
@onready var player: CharacterBody2D = $"/root/world/Player"
const SPEED = 1200	
@onready var dest = global_position.direction_to(player.global_position)


func _physics_process(delta: float) -> void:
	velocity = dest * SPEED
	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == player:
		player.emit_signal("hit")
	if !body.is_in_group("enemy"):
		queue_free()
