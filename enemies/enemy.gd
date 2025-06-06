extends CharacterBody2D
@onready var player: CharacterBody2D = $"/root/world/Player"
@onready var timer: Timer = $Timer
const BULLET = preload("res://enemies/bullet.tscn")

const SPEED = 1400
const JUMP_VELOCITY = -400.0

var destination = 0
var distance = 0
var atk_cooldown = false
var awake = false
var load = false
@export var death = false


func save():
	var save_dict = {
		"filename" : get_scene_file_path(),
		"pos_x" : position.x,
		"pos_y" : position.y,
		"death" : death
	}
	return save_dict
	
	
func _ready() -> void:
	await get_tree().create_timer(0.1).timeout
	load = true
	$Left.visible = false
	$Right.visible = false
	$Left/CollisionShape2D.disabled = true
	$Right/CollisionShape2D.disabled = true
	
func _physics_process(delta: float) -> void:
	if load == true and death == false:
		var space_rid = get_world_2d().space
		var space_states = PhysicsServer2D.space_get_direct_state(space_rid)
		var id = []
		for node in get_tree().get_nodes_in_group("enemy"):
			id.append(node.get_rid()) 
		var ray = PhysicsRayQueryParameters2D.create(global_position, player.global_position, collision_layer, id)
		var result = space_states.intersect_ray(ray)
		if not result.is_empty():
			if result.collider == player:
				awake = true
			
			
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if awake: 	
		$NavigationAgent2D.target_position = player.global_position
		destination = global_position.direction_to(
			$NavigationAgent2D.get_next_path_position()).x * SPEED
		velocity.x = lerp(float(velocity.x), float(destination), 0.7 * delta)
		
		$Label.text = var_to_str(timer.time_left)
		distance = global_position - player.global_position
		if distance.length() < 600:
			if timer.is_stopped():
				if distance.x > 0:
					$AnimationPlayer.play("left_attack")
					timer.start()
				else:
					$AnimationPlayer.play("right_attack")
					timer.start()
		else:
			if timer.is_stopped():
				var bullet = BULLET.instantiate()
				bullet.global_position = global_position
				get_parent().add_child(bullet)
				timer.start()
			
		
	move_and_slide()


func _on_right_body_entered(body: Node2D) -> void:
	if body == player && death == false:
		player.emit_signal("hit")


func _on_left_body_entered(body: Node2D) -> void:
	if body == player && death == false:
		player.emit_signal("hit")


func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body == player:
		if player.stamina < 3:
			player.stamina += 2
		queue_free()
