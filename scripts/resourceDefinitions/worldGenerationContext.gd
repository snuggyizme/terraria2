class_name WorldGenerationContext extends Resource

var chunks: Dictionary[Vector2i, Chunk]
@export var chunkData: Dictionary[Vector2i, ChunkData]
@export var mySeed: int = 0
@export var dimension: Vector2i
@export var structures: Dictionary[Vector2i, Structure] = {}
@export var name: String
@export var pendingBlocks: Dictionary[Vector2i, Dictionary] # Dictionary[Vector2i, Dictionary[Vector2i, StringName]]

var worldRect := Rect2i(
	Global.DIMENSION * -Global.WORLD_DIMENSION / 2.0,
	Global.DIMENSION * +Global.WORLD_DIMENSION,
)

func addChunkData(chunkPos: Vector2i) -> void:
	var chunk: Chunk = chunks[chunkPos]
	var data := ChunkData.new()
	data.blocks = chunk.blocks
	data.atlasIndices = chunk.getAtlasIndices()
	data.atlasCoords = chunk.getAtlasCoords()
	
	data.save()
	
	chunkData[chunkPos] = data 

func setup(
	sizeInChunks: Vector2i, s: int
) -> void:
	dimension = sizeInChunks
	mySeed = s
	name = str(randi())
	
	for chunk: ChunkData in chunkData.values():
		chunk.loadData()

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
