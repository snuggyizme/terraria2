@icon("res://assets/sprites/_debug/redStar.png")
class_name StructureGenerationPass extends GenerationPass

@export var allowedBlockOverrides: Array[StringName]
@export var structureType: Script

func generate(context: GenerationContext) -> void:
	var structures: Dictionary[Vector2i, Structure] = context.world.structures
	
	for structurePos: Vector2i in structures.keys():
		var structure: Structure = structures[structurePos]
		var blocksInChunk: Array[Vector2i] = [] 
		
		# The structure is not of type <structureType>: skip
		if is_instance_of(structure, structureType):
			continue
		
		# The structure has been scanned in another chunk and had a wrong block: skip
		if structure.markedInvalid:
			continue
		
		# The structure has a wrong block: skip
		for blockPos: Vector2i in structure.blocks.keys():
			var globalPos: Vector2i = structurePos + blockPos
			
			# Add to list of blocks we can place if we end up wanting to
			if context.isGlobalPosInChunkPos(globalPos, context.chunkPos):
				blocksInChunk.append(globalPos)
			
			if not context.getGlobalBlock(globalPos) in allowedBlockOverrides:
				structure.markedInvalid = true # you fucking failure
				break
		if structure.markedInvalid:
			continue
		
		# Yip yip yipee!!!! We make structure now
		for blockPos: Vector2i in blocksInChunk:
			var block: StringName = structure.blocks[blockPos]
			context.setBlock(context.getLocalPos(blockPos), block)
		
