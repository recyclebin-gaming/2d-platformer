extends CollisionPolygon2D
@export var erm: Polygon2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_deferred("polygon", erm.polygon)
	global_position = erm.global_position
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
