extends CharacterBody2D
signal hit
@onready var world: Node = $".."

const SAVE_PATH = "user://save_json.json"
const SPEED = 800.0
const JUMP_VELOCITY = -16000.0
@export var jump_curve: Curve
var jump_stamina = 1
var health = 100	
var stamina = 3
var dash
var invul = false
var slam


func _physics_process(delta: float) -> void:
	var boost = 0
	if stamina > 3:
		stamina = 3
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		velocity.y += 30
		if Input.is_action_pressed("slam") and stamina >= 2:
			velocity.y = 5000
			stamina -= 2	
			invul = false
			$GPUParticles2D2.emitting = true
	if is_on_floor() and !dash:
		invul = true
		$GPUParticles2D2.emitting = false
		
	stamina = 3
	var dash_direction = Input.get_axis("left", "right")
	if dash_direction and Input.is_action_just_pressed("dash") and stamina > 0:
		dash = true
		stamina -= 1
		await get_tree().create_timer(0.2).timeout
		dash = false
		$GPUParticles2D.emitting = false
		set_collision_layer_value(1, true)
		set_collision_mask_value(1, true)
		
	if dash:
		$GPUParticles2D.emitting = true
		set_collision_layer_value(1, false)
		set_collision_mask_value(1, false)
		velocity.x = 4500 * dash_direction
		velocity.y = 0
		move_and_slide()
		
	# Handle jump.
	if Input.is_action_pressed("jump"):
		if jump_stamina > 0:
			boost = 250
			velocity.y += (jump_curve.sample(jump_stamina) * JUMP_VELOCITY + boost) * delta
			jump_stamina -= 0.06
	if Input.is_action_just_released("jump"):
		jump_stamina = 0
	if is_on_floor():
		jump_stamina = 1
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = (SPEED + boost) * direction 
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED) * delta
		
		
	if velocity.x > 0:
		$AnimatedSprite2D.play("left")
	elif velocity.x < 0:
		$AnimatedSprite2D.play("right")
	elif velocity.x == 0:
		$AnimatedSprite2D.play("idle")
	if velocity.y < 0:
		$AnimatedSprite2D.play("jump")
	
	if not dash:
		move_and_slide()


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("death"):
		Global.death()
	if Input.is_action_just_pressed("reload save"):
		var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
		file.store_line(JSON.stringify(null))

func _on_area_2d_body_entered(body: Node2D) -> void:
	pass


func _on_timer_timeout() -> void:
	$Area2D/Sprite2D.visible = false
	$Area2D/CollisionShape2D.disabled = true
	$Area2D/Timer.stop()


func _on_hit() -> void:
	if invul:
		health -= 20
		$AnimationPlayer.play("hitflash")
		if health <= 0:
			Global.death()
