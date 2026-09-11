class_name WorldGenerationContext extends RefCounted

var mySeed: int = 0
var dimension: Vector2i
var structures: Dictionary[Vector2i, Structure] = {}

func _init(
	sizeInChunks: Vector2i
) -> void:
	dimension = sizeInChunks
	mySeed = randi()

func generateStructures() -> void:
	pass
