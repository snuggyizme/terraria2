class_name WorldGenerationContext extends RefCounted

var mySeed: int = 0
var dimension: Vector2i

func _init(
	sizeInChunks: Vector2i
) -> void:
	dimension = sizeInChunks
	mySeed = randi()
