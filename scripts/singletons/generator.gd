class_name TheDevourerOfCods extends Node

@export var passes: Array[GenerationPass]

func generate(context: GenerationContext) -> void:
	if Global.worldGenerationContext == null:
		Global.makeNewWorld()
	
	if context.world.chunkData.has(context.chunkPos): # Load chunk
		loadChunk(context.chunkPos, context.world.chunkData[context.chunkPos])
	else: # Generate chunk
		for i in passes:
			i.generate(context)

func loadChunk(pos: Vector2i, chunkData: ChunkData) -> void:
	var chunk: Chunk = Global.worldGenerationContext.chunks.get(pos)
	
	if chunk != null and not is_instance_valid(chunk):
		Global.worldGenerationContext.chunks.erase(pos)
		
		if Global.chunkController.loadedChunks.has(pos):
			Global.chunkController.loadedChunks.erase(pos)
		
		chunk = null
	
	if chunk == null:
		chunk = preload("res://scenes/chunk.tscn").instantiate()
		chunk.position = pos
		chunk.blocks = chunkData.blocks
		
		Global.chunkController.loadedChunks[pos] = chunk
		Global.worldGenerationContext.chunks[pos] = chunk
		Global.chunkController.chunkCreated.emit(await chunk.chunkReady)
		
		add_child(chunk)
	else:
		chunk.blocks = chunkData.blocks
		chunk.setChunkCells(chunkData.atlasIndices, chunkData.atlasCoords)
