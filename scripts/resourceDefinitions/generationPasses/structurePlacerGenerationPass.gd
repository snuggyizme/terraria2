@icon("res://assets/sprites/_debug/redStar.png")
class_name StructurePlacerGenerationPass extends GenerationPass

@export var structureType: Script
@export var replaceableBlocks: Array[StringName]

func generate(context: GenerationContext) -> void:
	var structures: Dictionary[Vector2i, Structure] = context.world.structures
	for coord: Vector2i in structures.keys():
		var structure: Structure = structures[coord]
		
		if not is_instance_of(structure, structureType):
			continue
		
		for blockPos: Vector2i in structure.blocks.keys():
			var addedCoord: Vector2i = coord + blockPos
			
			var localPos: Vector2i = context.globalToLocal(addedCoord)
			
			if not context.isInCurrentChunk(addedCoord):
				continue
			
			if not context.getBlock(localPos) in replaceableBlocks:
				continue
			
			context.setBlock(
				localPos,
				structure.blocks[blockPos]
			)
