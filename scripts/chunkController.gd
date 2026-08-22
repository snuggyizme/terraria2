class_name ChunkController extends Node2D

signal chunkCreated(times: Dictionary)

const CHUNK_SCENE: PackedScene = preload("res://scenes/chunk.tscn") 

@export var player: PlayerCharacter

var loadedChunks: Dictionary = {}
var playerChunk: Vector2i
var chunkSizePixels: Vector2i = Global.DIMENSION * Global.TILE_DIMENSION

func _physics_process(_delta: float) -> void:
	var currentPlayerChunk = Vector2i(
		floor(player.global_position.x / chunkSizePixels.x),
		floor(player.global_position.y / chunkSizePixels.y),
	)
	
	if currentPlayerChunk != playerChunk:
		print("Moved to new chunk")
		playerChunk = currentPlayerChunk
		update()

func update() -> void:
	var wantedChunks: Array = []
	for x in range(-Global.RENDER_DIST, Global.RENDER_DIST + 1):
		for y in range(-Global.RENDER_DIST, Global.RENDER_DIST + 1):
			wantedChunks.append(playerChunk + Vector2i(x, y))
	
	var queue: Array = []
	for i in wantedChunks:
		if i in loadedChunks:
			continue
		
		queue.append(i)
		
	
	for i in queue:
		var chunk: Chunk = CHUNK_SCENE.instantiate()
		chunk.chunkPosition = i
		add_child(chunk)
		loadedChunks[i] = chunk
		
		chunkCreated.emit(await chunk.chunkReady)
