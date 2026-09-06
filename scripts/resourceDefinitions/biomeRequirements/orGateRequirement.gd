class_name OrGateBiomeRequirement extends BiomeRequirement

@export var a: BiomeRequirement
@export var b: BiomeRequirement

func check(blocks: Dictionary[Vector2i, StringName]) -> bool:
	return a.check(blocks) or b.check(blocks)
