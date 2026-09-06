class_name DevourerOfGods extends Node

var world: WorldGenerationContext

func fetchWorld() -> void:
	world = Global.worldGenerationContext

func saveToFile(saveTres: bool) -> void:
	fetchWorld()
	
	var ext: String = ".tres" if saveTres else ".res"
	
	if not DirAccess.dir_exists_absolute("user://worlds"):
		DirAccess.make_dir_absolute("user://worlds")
	
	var result: Error = ResourceSaver.save(
		world, "user://worlds".path_join(
			world.name + ext
		)
	)
	
	print("SAVE TO FILE - ", result as Error)

func getSavedWorlds() -> Array[WorldGenerationContext]:
	var export: Array[WorldGenerationContext] = []
	
	if not DirAccess.dir_exists_absolute("user://worlds"):
		DirAccess.make_dir_absolute("user://worlds")
	
	var worldsFolder: DirAccess = DirAccess.open("user://worlds")
	if worldsFolder == null:
		print("LOADING WORLDS - CANT LOAD FOLDER")
		return export
	
	worldsFolder.list_dir_begin()
	
	for file: String in worldsFolder.get_files():
		if file.ends_with(".res") or file.ends_with(".tres"):
			var resource := load("user://worlds/" + file)
			
			if resource is WorldGenerationContext:
				export.append(resource)
			else:
				print("LOADING WORLDS - CANT LOAD RESOURCE")
		
	
	worldsFolder.list_dir_end()
	
	return export

func setBlock(globalPos: Vector2i, block: StringName) -> void:
	fetchWorld()
	
	var chunkPos := Vector2i(
		floori(float(globalPos.x) / Global.DIMENSION.x),
		floori(float(globalPos.y) / Global.DIMENSION.y),
	)
	
	var localPos := Vector2i(
		posmod(globalPos.x, Global.DIMENSION.x),
		posmod(globalPos.y, Global.DIMENSION.y)
	)
	
	if world.chunks.has(chunkPos): # Set persistant chunk data + mem chunk
		world.chunks[chunkPos].blocks[localPos] = block
		world.chunkData[chunkPos].blocks[localPos] = block
	elif world.chunkData.has(chunkPos): # Set persistant chunk data
		world.chunkData[chunkPos].blocks[localPos] = block
	else: # Add to requested data to be fulfilled by a generation pass
		if not world.pendingBlocks.has(chunkPos):
			world.pendingBlocks[chunkPos] = {}
		
		world.pendingBlocks[chunkPos][localPos] = block

func getBlock(globalPos: Vector2i) -> StringName:
	fetchWorld()
	
	var chunkPos := Vector2i(
		floori(float(globalPos.x) / Global.DIMENSION.x),
		floori(float(globalPos.y) / Global.DIMENSION.y),
	)
	
	var localPos := Vector2i(
		posmod(globalPos.x, Global.DIMENSION.x),
		posmod(globalPos.y, Global.DIMENSION.y)
	)
	
	# Should this generate the chunk to get it or nah?
	if world.chunkData.has(chunkPos):
		return world.chunkData[chunkPos].blocks.get(localPos, &"_missing")
	return &"_missing"

func isBlock(globalPos: Vector2i, block: StringName) -> bool:
	return ( getBlock(globalPos) == block )
