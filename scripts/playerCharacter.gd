class_name PlayerCharacter extends CharacterBody2D

@export var baseSpeed: float
@export var baseJump: float
@export var baseGravity: float
@export var baseAccel: float
@export var baseFriction: float
@export var startThreshold: float

var startTimer: float = 0.0

func _physics_process(delta: float) -> void:
	# Skip if we are a newborn child, as we are loading
	if startTimer < startThreshold:
		startTimer += delta
		return
	
	if is_on_floor():
		if Input.is_action_pressed("w"):
			velocity.y -= baseJump # No delta because it's a single frame force?
	else:
		velocity.y += baseGravity * delta
	
	var direction = Input.get_axis("a", "d")
	if direction:
		velocity.x = min(
			velocity.x + baseAccel * direction * delta,
			baseSpeed
		)
	else:
		velocity.x = move_toward(velocity.x, 0, baseFriction)
	
	move_and_slide()
