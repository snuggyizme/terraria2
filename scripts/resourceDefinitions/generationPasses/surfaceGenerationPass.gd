class_name SurfaceGenerationPass extends Node

@export var air: String
@export var grass: String
@export var dirt: String
@export var stone: String
@export var dirtWaviness: float = 2.0

func generate(context: GenerationContext) -> void:
	for x in range(-1, Global.DIMENSION.x + 1):
		for y in range(-1, Global.DIMENSION.y + 1):
			var localPos := Vector2i(x, y)
			var globalPos: Vector2i = context.getGlobalPos(localPos)
			
			var height: float = Global.noise.get_noise_1dv(globalPos.x)
			var dirtSize := int(
				Global.noise.get_noise_1dv(globalPos.x + 999) * dirtWaviness
			)
			
			var surfaceY := int(
				Global.SURFACE_HEIGHT + Global.HILL_HEIGHT * height
			)
			
			if globalPos.y < surfaceY:
				context.setBlock(localPos, air)
			elif globalPos.y == surfaceY:
				context.setBlock(localPos, grass)
			elif globalPos.y > (surfaceY + Global.DIRT_BUFFER_SIZE + dirtSize):
				context.setBlock(localPos, dirt)
			else:
				context.setBlock(localPos, stone)
