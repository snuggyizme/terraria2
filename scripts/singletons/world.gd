class_name DevourerOfGods extends Node

func saveToFile() -> void:
	if not DirAccess.dir_exists_absolute("user://worlds"):
		DirAccess.make_dir_absolute("user://worlds")
	
	var result: Error = ResourceSaver.save(
		Global.worldGenerationContext.duplicate(), "user://worlds".path_join(
			Global.worldGenerationContext.name + ".res"
		)
	)
	
	print(result)

func getSavedWorlds() -> Array[WorldGenerationContext]:
	var export: Array[WorldGenerationContext] = []
	
	if not DirAccess.dir_exists_absolute("user://worlds"):
		DirAccess.make_dir_absolute("user://worlds")
	
	var worldsFolder: DirAccess = DirAccess.open("user://worlds")
	
	worldsFolder.list_dir_begin()
	
	for file: String in worldsFolder.get_files():
		var resource := load("user://worlds/" + file)
		
		export.append(resource)
	
	worldsFolder.list_dir_end()
	
	return export
