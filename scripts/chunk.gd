class_name Chunk extends Node2D

signal finishedGen
signal finishedTerrainMask(frameCount: int)
signal finishedSetCellsTerrainConnect
signal finishedTile

signal chunkReady(times: Dictionary)

var chunkPosition := Vector2i.ZERO
var blocks: Dictionary[Vector2i, StringName] = {}

var startTime: float
var genTime: float
var terrainMaskTime: float
var setCellsTerrainConnectTime: float
var tileTime: float

@onready var tileMap: TileMapLayer = $TileMapLayer

func _ready() -> void:
	finishedGen.connect(SignalInterchange._chunkFinishedGen)
	finishedTerrainMask.connect(SignalInterchange._chunkFinishedTerrainMask)
	finishedSetCellsTerrainConnect.connect(SignalInterchange._chunkFinishedSetCellsTerrainConnect)
	finishedTile.connect(SignalInterchange._chunkFinishedTile)
	
	global_position = chunkPosition * Global.DIMENSION * Global.TILE_DIMENSION
	
	startTime = Time.get_ticks_msec()
	generate()
	update()

func generate() -> void:
	blocks.clear()
	
	for x in range(-1, Global.DIMENSION.x + 1):
		for y in range(-1, Global.DIMENSION.y + 1):
			var coord := Vector2i(x, y)
			
			var globalPosition: Vector2i = chunkPosition * Global.DIMENSION + coord
			
			var height: float = Global.noise.get_noise_1d(globalPosition.x) # -1 to 1
			
			var surfaceY := int(
				Global.SURFACE_HEIGHT + 
				Global.HILL_HEIGHT * height
			)
			
			if globalPosition.y < surfaceY:
				blocks[coord] = &"_"
			elif globalPosition.y == surfaceY:
				blocks[coord] = &"grass"
			elif globalPosition.y < surfaceY + Global.DIRT_BUFFER_SIZE:
				blocks[coord] = &"dirt"
			else:
				# If no one cares about this poor block it's gonna be rock hard
				blocks[coord] = &"stone"
				
				# 2D noise for caves
				var caveNoise: float = Global.noise.get_noise_2dv(
					globalPosition
				)
				# 2D noise for andesite
				var noiseAndesite: float = Global.noise.get_noise_2dv(
					globalPosition + Global.UNDERGROUND_NOISE_ANDESITE_OFFSET
				)
				# Check andesite first;
				if noiseAndesite < Global.UNDERGROUND_NOISE_ANDESITE_THRESHOLD:
					blocks[coord] = &"andesite"
				# Caves override andesite because I like Cave Johnson;
				if caveNoise < Global.UNDERGROUND_NOISE_CAVE_THRESHOLD:
					blocks[coord] = &"_"
			
			if (
				blocks[coord] != &"_" and
				(
					x < 0 or
					y < 0 or
					x >= Global.DIMENSION.x or
					y >= Global.DIMENSION.y
				)
			):
				blocks[coord] = &"_chunkConnect"
	
	genTime = Time.get_ticks_msec() - startTime
	finishedGen.emit()

func update() -> void:
	await get_tree().process_frame
	await get_tree().process_frame
	
	var awaitTime = Time.get_ticks_msec() - startTime - genTime

	var terrainCells: Array[Vector2i] = []
	terrainCells.resize((Global.DIMENSION.x + 2) * (Global.DIMENSION.y + 2))
	var terrainCellsSize := 0
	
	var counter := 0
	var frameCount := 1
	for x in range(-1, Global.DIMENSION.x + 1):
		for y in range(-1, Global.DIMENSION.y + 1):
			if counter >= Global.TILES_PER_FRAME and Global.DO_EVIL_TILES_PER_FRAME:
				counter = 0
				frameCount += 1
				await get_tree().process_frame
			
			var coord := Vector2i(x, y)
			
			if blocks[coord] == &"_":
				continue
			
			terrainCells[terrainCellsSize] = coord
			terrainCellsSize += 1
			
			counter += 1
	
	terrainCells.resize(terrainCellsSize)
	
	terrainMaskTime = Time.get_ticks_msec() - startTime - genTime- awaitTime  #
	finishedTerrainMask.emit(frameCount) # 
	
	tileMap.set_cells_terrain_connect(
		terrainCells,
		0,
		0,
	)
	
	setCellsTerrainConnectTime = Time.get_ticks_msec() - startTime - genTime - awaitTime - terrainMaskTime #
	finishedSetCellsTerrainConnect.emit() # 
	
	var fallbackBlock: Block = Global.blockDict[&"test"]
	var emptyCoord: Vector2i = Vector2i(-1, -1)

	for x in range(-1, Global.DIMENSION.x + 1):
		for y in range(-1, Global.DIMENSION.y + 1):
			var coord := Vector2i(x, y) 
			var coordFromCell := tileMap.get_cell_atlas_coords(coord)
			
			if coordFromCell == emptyCoord:
				continue
			
			var block: Block = Global.blockDict.get(
				blocks[coord], fallbackBlock
			)
			
			tileMap.set_cell(coord, block.sourceAtlas, coordFromCell)
	
	tileTime = Time.get_ticks_msec() - startTime - genTime - awaitTime - terrainMaskTime - setCellsTerrainConnectTime #
	finishedTile.emit() #
	
	chunkReady.emit({ #
		&"genTime": genTime, #
		&"terrainMaskTime": terrainMaskTime, #
		&"setCellsTerrainConnectTime": setCellsTerrainConnectTime, #
		&"tileTime": tileTime, #
	}) #
