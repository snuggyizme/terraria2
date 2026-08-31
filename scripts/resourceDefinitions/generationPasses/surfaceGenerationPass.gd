@icon("res://assets/sprites/oliveStar.png")
class_name SurfaceGenerationPass extends GenerationPass

@export var air: StringName
@export var grass: StringName
@export var dirt: StringName
@export var stone: StringName
@export var dirtWaviness: float = 2.0
@export var grassNoiseIdentifier: StringName
@export var dirtNoiseIdentifier: StringName

func generate(context: GenerationContext) -> void:
	var grassNoise: FastNoiseLite = Global.get(grassNoiseIdentifier)
	var dirtNoise: FastNoiseLite = Global.get(dirtNoiseIdentifier)
	
	for x in range(-1, Global.DIMENSION.x + 1):
		for y in range(-1, Global.DIMENSION.y + 1):
			var localPos := Vector2i(x, y)
			var globalPos: Vector2i = context.getGlobalPos(localPos)
			
			var height: float = grassNoise.get_noise_1d(globalPos.x)
			var dirtSize := int(
				dirtNoise.get_noise_1d(globalPos.x + 999) * dirtWaviness
			)
			
			var surfaceY := int(
				Global.SURFACE_HEIGHT + Global.HILL_HEIGHT * height
			)
			
			if globalPos.y < surfaceY:
				context.setBlock(localPos, air)
			elif globalPos.y == surfaceY:
				context.setBlock(localPos, grass)
			elif globalPos.y < (surfaceY + Global.DIRT_BUFFER_SIZE + dirtSize):
				context.setBlock(localPos, dirt)
			else:
				context.setBlock(localPos, stone)
