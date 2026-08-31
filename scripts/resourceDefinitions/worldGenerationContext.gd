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
	var rect := Rect2i(
		-Global.WORLD_DIMENSION / 2.0,
		+Global.WORLD_DIMENSION,
	)
	
	for i in range(Global.structureCountShrine):
		var randX: int = randi_range(rect.position.x, rect.end.x - 1)
		var randY: int = randi_range(rect.position.y, rect.end.y - 1)
		var coord := Vector2i(randX, randY)
		
		var structure := ShrineStructure.new()
		structure.generate(coord)
		
		structures[coord] = structure
