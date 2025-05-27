extends Node2D
@export var erm: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Area2D/Camera2D.zoom.x = erm.x
	$Area2D/Camera2D.zoom.y = erm.x

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		$Area2D/Camera2D.enabled = true
		$Area2D/Camera2D.make_current()
		print("yay")


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		$Area2D/Camera2D.enabled = false
		print("nay")
