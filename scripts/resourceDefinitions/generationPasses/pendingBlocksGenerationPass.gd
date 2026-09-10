@icon("res://assets/sprites/_debug/redStar.png")
class_name PendingBlocksGenerationPass extends GenerationPass

func generate(context: GenerationContext) -> void:
	var world: WorldGenerationContext = context.world
	
	if world.pendingBlocks.has(context.chunkPos):
		for localPos in world.pendingBlocks[context.chunkPos].keys():
			context.setBlock(
				localPos,
				world.pendingBlocks[context.chunkPos][localPos]
			)
