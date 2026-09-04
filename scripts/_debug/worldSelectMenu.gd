class_name WorldSelectMenu extends Control

@export var vBox: VBoxContainer

func _ready() -> void:
	var worlds: Array[WorldGenerationContext] = World.getSavedWorlds()
	for i in worlds:
		var worldContainer: WorldContainer = preload("res://scenes/_debug/worldContainer.tscn").instantiate()
		print(i)
		worldContainer.world = i
		worldContainer.opened.connect(_onWorldLoaded)
		vBox.add_child(worldContainer)

func _onNewWorldButtonPressed() -> void:
	Global.makeNewWorld()
	get_tree().change_scene_to_file("res://scenes/world.tscn")

func _onWorldLoaded(world: WorldGenerationContext) -> void:
	Global.worldGenerationContext = world
	get_tree().change_scene_to_file("res://scenes/world.tscn")
