class_name ChunkController extends Node2D

signal chunkCreated(times: Dictionary)

const CHUNK_SCENE: PackedScene = preload("res://scenes/chunk.tscn") 

@export var player: PlayerCharacter

var loadedChunks: Dictionary = {}
var playerChunk: Vector2i
var chunkSizePixels: Vector2i = Global.DIMENSION * Global.TILE_DIMENSION
var updateRunning: bool = false
var updatePending: bool = false

func _ready() -> void:
	Global.chunkController = self

func _physics_process(_delta: float) -> void:
	var currentPlayerChunk = Vector2i(
		floor(player.global_position.x / chunkSizePixels.x),
		floor(player.global_position.y / chunkSizePixels.y),
	)
	
	if currentPlayerChunk != playerChunk:
		print("Moved to new chunk")
		playerChunk = currentPlayerChunk
		requestUpdate()

func requestUpdate() -> void:
	if updateRunning:
		updatePending = true
		return
	
	update()

func update() -> void:
	updateRunning = true
	updatePending = false
	
	var wantedChunks: Array = []
	for x in range(-Global.RENDER_DIST, Global.RENDER_DIST + 1):
		for y in range(-Global.RENDER_DIST, Global.RENDER_DIST + 1):
			wantedChunks.append(playerChunk + Vector2i(x, y))
	
	# Find and load all chunks we want but dont have
	var queue: Array = []
	for chunkPos in wantedChunks:
		if chunkPos in loadedChunks:
			continue
		
		queue.append(chunkPos)
		
	for i in queue:
		var chunk: Chunk = CHUNK_SCENE.instantiate()
		chunk.chunkPosition = i
		add_child(chunk)
		loadedChunks[i] = chunk
		Global.worldGenerationContext.chunks[i] = chunk
		
		chunkCreated.emit(await chunk.chunkReady)
		
		Global.worldGenerationContext.addChunkData(i)
	
	# Find and unload all chunks we dont want but have
	for i in loadedChunks.keys():
		if i not in wantedChunks:
			loadedChunks[i].queue_free()
			loadedChunks.erase(i)
	
	updateRunning = false
	
	if updatePending:
		update()
