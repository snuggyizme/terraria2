class_name WorldSelectMenu extends Control

@export var vBox: VBoxContainer

func _ready() -> void:
	var worlds: Array[WorldGenerationContext] = World.getSavedWorlds()
	for i in worlds:
		vBox.add_child(WorldContainer.new(i))

func _onNewWorldButtonPressed() -> void:
	Global.makeNewWorld()
	get_tree().change_scene_to_file("res://scenes/world.tscn")
