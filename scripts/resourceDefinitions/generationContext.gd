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

func getChunkPos(globalPos: Vector2i) -> Vector2i:
	return Vector2i(
		floori(float(globalPos.x) / Global.DIMENSION.x),
		floori(float(globalPos.y) / Global.DIMENSION.y),
	)

func isInNeighbouringChunk(globalPos: Vector2i) -> bool:
	var targetChunkPos := getChunkPos(globalPos)
	
	return (
		( abs(targetChunkPos.x - chunkPos.x) <= 1 ) &&
		( abs(targetChunkPos.x - chunkPos.y <= 1) )
	)

func isInCurrentChunk(globalPos: Vector2i) -> bool:
	var rect := Rect2i(
		chunkPos, chunkPos + Global.DIMENSION
	)
	
	return ( rect.has_point(globalPos) )

func globalToLocal(globalPos: Vector2i) -> Vector2i:
	return Vector2i(
		posmod(globalPos.x, Global.DIMENSION.x),
		posmod(globalPos.y, Global.DIMENSION.y)
	)
