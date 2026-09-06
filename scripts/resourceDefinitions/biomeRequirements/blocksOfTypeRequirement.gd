class_name BlocksOfTypeBiomeRequirement extends BiomeRequirement

@export var block: StringName
@export var count: int

func check(blocks: Dictionary[Vector2i, StringName]) -> bool:
	var detected: int = 0
	for value in blocks.values():
		if value == block:
			detected += 1
	
	return ( detected > count )
