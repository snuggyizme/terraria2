class_name F3Menu extends CanvasLayer

@export var chunkController: ChunkController
@export var leftLabel: Label
@export var ticks: Array[Sprite2D]

@export_group("Skip")
@export var skipSprite: Sprite2D
@export var skipTrans1: Tween.TransitionType
@export var skipEase1: Tween.EaseType
@export var skipTrans2: Tween.TransitionType
@export var skipEase2: Tween.EaseType
@export var skipRotation: float

var chunkTimes: Array[Dictionary] = []
var avgChunkTimes: Dictionary
var latestFrameCount
var tweens: Array[Tween] = [null, null, null, null]
var tween1: Tween
var tween2: Tween

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
	var frameCounter: String = " (Latest frame count: " + latestFrameCount + ")\n" if Global.DO_EVIL_TILES_PER_FRAME else "\n"
	
	text += "Avg chunk times:" + "\n"
	text += "   1. Generate: " + avgChunkTimes[&"genTime"] + "\n"
	text += "   2. Terrain Mask: " + avgChunkTimes[&"terrainMaskTime"] + frameCounter
	text += "   3. Set Cells Terrain Connect: " + avgChunkTimes.setCellsTerrainConnectTime + "\n" # This works, woah.
	text += "   4. Tile: " + avgChunkTimes.tileTime + "\n"
	
	
	leftLabel.text = text

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("f3"):
		visible = not visible

func _onChunkCreated(times: Dictionary, skip: bool) -> void:
	if skip:
		skipSprite.modulate.a = 1.0
		skipSprite.rotation_degrees = 0.0
		skipSprite.scale = Vector2.ONE * 0.8
		
		if tween1 != null:
			tween1.kill()
		
		if tween2 != null:
			tween2.kill()
		
		tween1 = create_tween().parallel().set_trans(skipTrans1).set_ease(skipEase1)
		tween1.tween_property(
			skipSprite, "modulate:a", 0.0, 0.6
		)
		tween1.tween_property( # why on earth don't these scale???
			skipSprite, "scale", Vector2.ONE * 3.0, 0.25
		)
		tween1.chain().tween_property( # ????????????? do yo job ?
			skipSprite, "scale", Vector2.ONE * 0.8, 0.35
		)
		
		tween2 = create_tween().parallel().set_trans(skipTrans2).set_ease(skipEase2)
		tween2.tween_property(
			skipSprite, "rotation_degrees", skipRotation, 0.25
		)
		tween2.tween_property(
			skipSprite, "rotation_degrees", 0.0, 0.35
		)
		return
	
	chunkTimes.append(times)
	avgChunkTimes = avgChunks(chunkTimes)

func _chunkFinishedGen() -> void:
	showTick(0)

func _chunkFinishedTerrainMask(frameCount) -> void:
	latestFrameCount = str(frameCount)
	showTick(1)

func _chunkFinishedSetCellsTerrainConnect() -> void:
	showTick(2)

func _chunkFinishedTile() -> void:
	showTick(3)

func showTick(i: int) -> void:
	var tick: Sprite2D = ticks[i]
	tick.visible = true
	tick.modulate.a = 1.0
	
	if tweens[i] != null:
		tweens[i].kill()
	
	tweens[i] = create_tween()
	tweens[i].tween_property(
		tick, "modulate:a", 0.0, 0.7,
	)
	tweens[i].tween_callback(
		tick.hide
	)

func avgChunks(times: Array[Dictionary]) -> Dictionary:
	var avg: Dictionary = {
		&"genTime": 0.0,
		&"terrainMaskTime": 0.0,
		&"setCellsTerrainConnectTime": 0.0,
		&"tileTime": 0.0,
	}
	
	for i in range(len(times)):
		for j in times[i].keys():
			avg[j] += times[i][j]
	
	for i in avg.keys():
		avg[i] = str(snapped(avg[i] / len(times), 0.01))
	
	return avg
