@icon("res://assets/sprites/_debug/redStar.png")
class_name NoiseReplacerGenerationPass extends GenerationPass

@export var targets: Array[StringName]
@export var block: StringName
@export var noiseIdentifier: StringName
@export var threshold: Threshold
@export var offset: int = 0

func generate(context: GenerationContext) -> void:
	var noise: FastNoiseLite = Global.get(noiseIdentifier)
	
	for x in range(-1, Global.DIMENSION.x + 1):
		for y in range(-1, Global.DIMENSION.y + 1):
			var coord := Vector2i(x, y)
			var global: Vector2i = context.getGlobalPos(coord)
			var value: float = noise.get_noise_2dv(global + Vector2i.ONE * offset)
			
			if threshold.test(value):
				if context.getBlock(coord) in targets:
					context.setBlock(coord, block)
