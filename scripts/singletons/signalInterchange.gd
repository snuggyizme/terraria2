class_name TrainStation extends Node

signal chunkFinishedGen
signal chunkFinishedTerrainMask
signal chunkFinishedSetCellsTerrainConnect
signal chunkFinishedTile

func _chunkFinishedGen() -> void:
	chunkFinishedGen.emit()

func _chunkFinishedTerrainMask() -> void:
	chunkFinishedTerrainMask.emit()

func _chunkFinishedSetCellsTerrainConnect() -> void:
	chunkFinishedSetCellsTerrainConnect.emit()

func _chunkFinishedTile() -> void:
	chunkFinishedTile.emit()
