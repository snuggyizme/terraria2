class_name TheDevourerOfCods extends Node

@export var passes: Array[GenerationPass]

func generate(context: GenerationContext) -> void:
	if Global.worldGenerationContext == null:
		Global.makeNewWorld()
	
	for i in passes:
		i.generate(context)
