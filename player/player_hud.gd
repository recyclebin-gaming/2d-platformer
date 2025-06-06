extends Node2D
@onready var player: CharacterBody2D = $"../.."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$HealthBar.value = player.health
	if player.stamina == 3:
		$StaminaBar/ColorRect3.visible = true
		$StaminaBar/ColorRect2.visible = true
		$StaminaBar/ColorRect.visible = true
	if player.stamina == 2:
		$StaminaBar/ColorRect3.visible = false
		$StaminaBar/ColorRect2.visible = true
		$StaminaBar/ColorRect.visible = true
	if player.stamina == 1:
		$StaminaBar/ColorRect3.visible = false
		$StaminaBar/ColorRect2.visible = false
		$StaminaBar/ColorRect.visible = true
	if player.stamina == 0:
		$StaminaBar/ColorRect3.visible = false
		$StaminaBar/ColorRect2.visible = false
		$StaminaBar/ColorRect.visible = false
	
