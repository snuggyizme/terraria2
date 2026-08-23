class_name F3Menu extends CanvasLayer

@export var chunkController: ChunkController
@export var leftLabel: Label
@export var ticks: Array[Sprite2D]

var chunkTimes: Array[Dictionary] = []
var avgChunkTimes: Dictionary

func _ready() -> void:
	chunkController.chunkCreated.connect(_onChunkCreated)
	visible = false
	
	SignalInterchange.chunkFinishedGen.connect(_chunkFinishedGen)
	SignalInterchange.chunkFinishedTerrainMask.connect(_chunkFinishedTerrainMask)
	SignalInterchange.chunkFinishedSetCellsTerrainConnect.connect(_chunkFinishedSetCellsTerrainConnect)
	SignalInterchange.chunkFinishedTile.connect(_chunkFinishedTile)

func _process(_delta: float) -> void:
	if avgChunkTimes == null or not avgChunkTimes.has(&"genTime"):
		return
	
	var text: String = ""
	
	# FPS
	text += "FPS: " + str(Engine.get_frames_per_second()) + "\n"
	
	# Process & Physics
	text += "Process time: " + str(Performance.get_monitor(Performance.TIME_PROCESS) * 1000.0) + "\n"
	text += "Physics time: " + str(Performance.get_monitor(Performance.TIME_PHYSICS_PROCESS) * 1000.0) + "\n"
	
	# Avg Chunk Times
	text += "Avg chunk times:" + "\n"
	text += "   1. Generate: " + avgChunkTimes[&"genTime"] + "\n"
	text += "   2. Terrain Mask: " + avgChunkTimes[&"terrainMaskTime"] + "\n"
	text += "   3. Set Cells Terrain Connect: " + avgChunkTimes.setCellsTerrainConnectTime + "\n" # This works, woah.
	text += "   4. Tile: " + avgChunkTimes.tileTime + "\n"
	
	
	
	leftLabel.text = text

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("f3"):
		visible = not visible

func _onChunkCreated(times: Dictionary) -> void:
	chunkTimes.append(times)
	avgChunkTimes = avgChunks(chunkTimes)

func _chunkFinishedGen() -> void:
	showTick(0)

func _chunkFinishedTerrainMask() -> void:
	showTick(1)

func _chunkFinishedSetCellsTerrainConnect() -> void:
	showTick(2)

func _chunkFinishedTile() -> void:
	showTick(3)

func showTick(i: int) -> void:
	var tick: Sprite2D = ticks[i]
	tick.visible = true
	tick.modulate.a = 1.0
	var tween = create_tween()
	tween.tween_property(
		tick, "modulate:a", 0.0, 0.7,
	)
	tween.tween_callback(
		tick.hide
	)

func avgChunks(times: Array[Dictionary]) -> Dictionary:
	var avg: Dictionary
	
	for i in times[0].keys():
		avg[i] = 0.0
	
	for i in range(len(times)):
		for j in times[i].keys():
			avg[j] += times[i][j]
	
	for i in avg.keys():
		avg[i] = str(snapped(avg[i] / len(times), 0.01))
	
	return avg
