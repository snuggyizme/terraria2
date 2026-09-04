class_name WorldContainer extends PanelContainer

signal opened(world: WorldGenerationContext)

@export var label: Label

var world: WorldGenerationContext

func _init(w: WorldGenerationContext) -> void:
	world = w

func _ready() -> void:
	label.text = world.name

func _onOpenButtonPressed() -> void:
	opened.emit(world)
