extends CharacterBody2D
signal hit
@onready var world: Node = $".."

const SAVE_PATH = "user://save_json.json"
const SPEED = 800.0
const JUMP_VELOCITY = -16400.0
@export var jump_curve: Curve
var jump_stamina = 1
var health = 100	

	
func _physics_process(delta: float) -> void:
	var boost = 0
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		velocity.y += 30
		
	# Handle jump.
	if Input.is_action_pressed("jump"):
		if jump_stamina > 0:
			boost = 200
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
	move_and_slide()


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("attack") && $Area2D/Timer.time_left <= 0:
		$Area2D/Timer.start()
		$Area2D/Sprite2D.visible = true
		$Area2D/CollisionShape2D.disabled = false
		
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
	health -= 20
	$AnimationPlayer.play("hitflash")
	if health <= 0:
		Global.death()
