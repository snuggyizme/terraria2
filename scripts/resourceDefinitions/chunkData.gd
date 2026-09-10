class_name ChunkData extends Resource

@export var saveBlocks: PackedStringArray
@export var saveAtlasIndices: PackedInt32Array
@export var saveAtlasCoords: PackedVector2Array

var blocks: Dictionary[Vector2i, StringName] = {}
var atlasIndices: Dictionary[Vector2i, int] = {}
var atlasCoords: Dictionary[Vector2i, Vector2i] = {}

func loadData() -> void:
	var size: Vector2i = Global.DIMENSION + Vector2i.ONE * 2

	blocks.clear()
	atlasIndices.clear()
	atlasCoords.clear()

	for i in saveBlocks.size():
		var coord := Vector2i(
			i % size.x - 1,
			floori(i / float(size.x) - 1) # I want no warnings they piss me off. Thus we be typing
		)

		blocks[coord] = StringName(saveBlocks[i])
		atlasIndices[coord] = saveAtlasIndices[i]
		atlasCoords[coord] = Vector2i(saveAtlasCoords[i])

func save() -> void:
	var size: Vector2i = Global.DIMENSION + Vector2i.ONE * 2
	var cellCount := size.x * size.y

	saveBlocks.resize(cellCount)
	saveAtlasIndices.resize(cellCount)
	saveAtlasCoords.resize(cellCount)
	
	for y in range(-1, Global.DIMENSION.y + 1):
		for x in range(-1, Global.DIMENSION.x + 1):
			var coord := Vector2i(x, y)
			var index := (x + 1) + (y + 1) * size.x

			saveBlocks[index] = String(blocks[coord])
			saveAtlasIndices[index] = atlasIndices[coord]
			saveAtlasCoords[index] = Vector2(atlasCoords[coord])
