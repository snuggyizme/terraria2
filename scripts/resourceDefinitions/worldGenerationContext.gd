class_name WorldGenerationContext extends Resource

var chunks: Dictionary[Vector2i, Chunk]
var mySeed: int = 0
var dimension: Vector2i
var structures: Dictionary[Vector2i, Structure] = {}
var name: String = str(randi())

var worldRect := Rect2i(
	Global.DIMENSION * -Global.WORLD_DIMENSION / 2.0,
	Global.DIMENSION * +Global.WORLD_DIMENSION,
)

func _init(
	sizeInChunks: Vector2i
) -> void:
	dimension = sizeInChunks
	mySeed = randi()

func generateStructures() -> void:
	for i in range(Global.structureCountShrine):
		var pos: Vector2i = getRandomGlobalPosition()
		var structure := ShrineStructure.new(pos)
		structures[pos] = structure

func getRandomGlobalPosition() -> Vector2i:
	return Vector2i(
		randi_range(worldRect.position.x, worldRect.end.x),
		randi_range(worldRect.position.y, worldRect.end.y),
	)
