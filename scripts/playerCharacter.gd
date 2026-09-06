class_name PlayerCharacter extends CharacterBody2D

@export var baseSpeed: float
@export var baseJump: float
@export var baseGravity: float
@export var baseAccel: float
@export var baseFriction: float
@export var startThreshold: float
@export var stepHeight: float
@export var noclipSpeed: float

var startTimer: float = 0.0
var noclip: bool = false

func _physics_process(delta: float) -> void:
	# Skip if we are a newborn child, as we are loading
	if startTimer < startThreshold:
		startTimer += delta
		return
	
	if Input.is_action_just_pressed("f2"):
		noclip = not noclip
	
	if noclip:
		noclipProcess(delta)
	else:
		normalProcess(delta)

func normalProcess(delta: float) -> void:
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
	
	# ~move and slide~
	move_and_slide()

func noclipProcess(delta: float) -> void:
	var dir = Input.get_vector(
		"a", "d", "w", "s",
	)
	global_position += dir * noclipSpeed * delta
