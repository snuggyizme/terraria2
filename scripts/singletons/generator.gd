class_name TheDevourerOfCods extends Node

@export var passes: Array[GenerationPass]

func generate(context: GenerationContext, chunk: Chunk) -> bool: ## Returns whether or not we should call update() in the chunk
	if Global.worldGenerationContext == null:
		Global.makeNewWorld()
	
	if context.world.chunkData.has(context.chunkPos): # Load chunk
		loadChunk(context, chunk)
		return false
	
	# Generate chunk
	for i in passes:
		i.generate(context)
	return true

func loadChunk(context: GenerationContext, chunk: Chunk) -> void:
	var chunkData: ChunkData = context.world.chunkData[context.chunkPos]
	
	chunkData.loadData()
	
	print("array size: ", chunkData.saveAtlasIndices.size())
	print("dict size: ", chunkData.atlasIndices.size())
	print("has (-1,-1): ", chunkData.atlasIndices.has(Vector2i(-1, -1)))
	print("has (0,-1): ", chunkData.atlasIndices.has(Vector2i(0, -1)))
	print("keys: ", chunkData.atlasIndices.keys())
	
	
	chunk.blocks.clear()
	chunk.blocks.merge(chunkData.blocks)
	
	chunk.setChunkCells(chunkData.atlasIndices, chunkData.atlasCoords)
