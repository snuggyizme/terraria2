class_name Structure extends Resource

var blocks: Dictionary[Vector2i, StringName]

func generate(_globalPos: Vector2i) -> void:
	pass

func parseStringShape(
	string: String, key: Dictionary[String, StringName]
) -> Dictionary[Vector2i, StringName]:
	var parsedBlocks: Dictionary[Vector2i, StringName] = {}
	var lines: Array[String] = string.strip_edges().split("\n")
	
	for y in range(lines.size()):
		var line: String = lines[y]
		
		for x in line.length():
			var block: StringName = key.get(line[x])
			
			if block != null:
				parsedBlocks[Vector2i(x, y)] = block
	
	return parsedBlocks
