class_name TrainStation extends Node

signal chunkFinishedGen
signal chunkFinishedTerrainMask(frameCount: int)
signal chunkFinishedSetCellsTerrainConnect
signal chunkFinishedTile

func _chunkFinishedGen() -> void:
	chunkFinishedGen.emit()

func _chunkFinishedTerrainMask(frameCount: int) -> void:
	chunkFinishedTerrainMask.emit(frameCount)

func _chunkFinishedSetCellsTerrainConnect() -> void:
	chunkFinishedSetCellsTerrainConnect.emit()

func _chunkFinishedTile() -> void:
	chunkFinishedTile.emit()
