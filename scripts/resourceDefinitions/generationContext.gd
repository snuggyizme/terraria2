class_name GenerationContext extends RefCounted

var chunkPos: Vector2i
var blocks: Dictionary[Vector2i, StringName]
var world: WorldGenerationContext

func _init(
	c: Vector2i, b: Dictionary[Vector2i, StringName], w: WorldGenerationContext
) -> void:
	chunkPos = c
	blocks = b
	world = w

func getGlobalPos(localPos: Vector2i) -> Vector2i:
	return chunkPos * Global.DIMENSION + localPos

func getBlock(localPos: Vector2i) -> StringName:
	return blocks.get(localPos, &"_")

func setBlock(localPos: Vector2i, block: StringName) -> void:
	blocks[localPos] = block

func isSolid(localPos: Vector2i) -> bool:
	return ( getBlock(localPos) != &"_" )
