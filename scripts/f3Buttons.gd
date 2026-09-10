class_name F3Buttons extends PanelContainer

func _onSaveWorldRESButtonPressed() -> void:
	World.saveToFile(false)


func _onSaveWorldTRESButtonPressed() -> void:
	World.saveToFile(true)
