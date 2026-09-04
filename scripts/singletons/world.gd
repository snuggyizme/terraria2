class_name DevourerOfGods extends Node

func saveToFile() -> void:
	# Make all chunk data resources save their memory representations (dictionaries of
	# stringnames, vectors and ints) back into the packed arrays again.
	for i in Global.worldGenerationContext.chunkData.values():
		i.save()
	
	if not DirAccess.dir_exists_absolute("user://worlds"):
		DirAccess.make_dir_absolute("user://worlds")
	
	var result: Error = ResourceSaver.save(
		Global.worldGenerationContext, "user://worlds".path_join(
			Global.worldGenerationContext.name + ".tres"
		)
	)
	
	print("SAVE TO FILE - ", result)

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
