class_name ChunkData extends Resource

@export var saveBlocks: PackedStringArray
@export var saveAtlasIndices: PackedInt32Array
@export var saveAtlasCoords: PackedVector2Array

var blocks: Dictionary[Vector2i, StringName]
var atlasIndices: Dictionary[Vector2i, int]
var atlasCoords: Dictionary[Vector2i, Vector2i]

func _ready() -> void:
	var size := Vector2i(Global.DIMENSION + 2)
	
	for i in range(saveBlocks.size()):
		var coord := Vector2i(
			int(i % size.x - 1.0),
			int(i / float(size.x) - 1.0),
		)
		
		blocks[coord] = StringName(saveBlocks[i])
		atlasIndices[coord] = saveAtlasIndices[i]
		atlasCoords[coord] = saveAtlasCoords[i]

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
