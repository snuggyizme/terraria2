class_name Chunk extends Node2D

signal finishedGen
signal finishedTerrainMask(frameCount: int)
signal finishedSetCellsTerrainConnect
signal finishedTile

signal chunkReady(times: Dictionary, skip: bool)

var chunkPosition := Vector2i.ZERO
var blocks: Dictionary[Vector2i, StringName] = {}

var startTime: float
var genTime: float
var terrainMaskTime: float
var setCellsTerrainConnectTime: float
var tileTime: float

@onready var tileMap: TileMapLayer = $TileMapLayer

func _ready() -> void:
	print("{", chunkPosition, "}: ", "Onready")
	finishedGen.connect(SignalInterchange._chunkFinishedGen)
	finishedTerrainMask.connect(SignalInterchange._chunkFinishedTerrainMask)
	finishedSetCellsTerrainConnect.connect(SignalInterchange._chunkFinishedSetCellsTerrainConnect)
	finishedTile.connect(SignalInterchange._chunkFinishedTile)
	
	global_position = chunkPosition * Global.DIMENSION * Global.TILE_DIMENSION
	
	startTime = Time.get_ticks_msec()
	
	var generated: bool = generate()
	print("{", chunkPosition, "}: ", "Generate returned")
	
	if generated:
		print("{", chunkPosition, "}: ", "Start update")
		update()
	else:
		print("{", chunkPosition, "}: ", "Emit ready")
		chunkReady.emit({}, true)

func generate() -> bool:
	blocks.clear()
	
	var context := GenerationContext.new(
		chunkPosition,
		blocks,
		Global.worldGenerationContext
	)
	
	var carry: bool = Generator.generate(context, self)
	
	for x in range(-1, Global.DIMENSION.x + 1):
		for y in range(-1, Global.DIMENSION.y + 1):
			var coord := Vector2i(x, y)
			
			if blocks.has(coord):
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
	
	return carry

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
	
	terrainCells.resize(terrainCellsSize) # I don't know if I need this or not # FUCK I DO I DO I DO
	#                                                                                 ^^^^^^^^^^^^^^
	#                                                                                  Me when wife 
	
	terrainMaskTime = Time.get_ticks_msec() - startTime - genTime- awaitTime
	finishedTerrainMask.emit(frameCount)
	
	
	
	
	tileMap.set_cells_terrain_connect(
		terrainCells,
		0,
		0,
	)
	
	
	
	
	setCellsTerrainConnectTime = Time.get_ticks_msec() - startTime - genTime - awaitTime - terrainMaskTime
	finishedSetCellsTerrainConnect.emit()
	
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
	
	tileTime = Time.get_ticks_msec() - startTime - genTime - awaitTime - terrainMaskTime - setCellsTerrainConnectTime
	finishedTile.emit()
	
	chunkReady.emit(
		{
			&"genTime": genTime,
			&"terrainMaskTime": terrainMaskTime,
			&"setCellsTerrainConnectTime": setCellsTerrainConnectTime,
			&"tileTime": tileTime,
		},
		false
	)

func calcBiomes() -> Array[Biome]:
	var biomes: Array[Biome] = []
	
	for biome: Biome in Global.biomeArray:
		for requirement: BiomeRequirement in biome.requirements:
			if requirement.check(blocks):
				biomes[biome.zOrder] = biome
	
	return biomes

func getAtlasCoords() -> Dictionary[Vector2i, Vector2i]:
	var export: Dictionary[Vector2i, Vector2i] = {}
	for x in range(-1, Global.DIMENSION.x + 1):
		for y in range(-1, Global.DIMENSION.y + 1):
			var coord := Vector2i(x, y)
			
			export[coord] = tileMap.get_cell_atlas_coords(coord)
	return export

func getAtlasIndices() -> Dictionary[Vector2i, int]:
	var export: Dictionary[Vector2i, int] = {}
	for x in range(-1, Global.DIMENSION.x + 1):
		for y in range(-1, Global.DIMENSION.y + 1):
			var coord := Vector2i(x, y)
			
			export[coord] = tileMap.get_cell_source_id(coord)
	return export

func setChunkCells(
	atlasIndices: Dictionary[Vector2i, int],
	atlasCoords: Dictionary[Vector2i, Vector2i]
) -> void:
	for x in range(-1, Global.DIMENSION.x + 1):
		for y in range(-1, Global.DIMENSION.y + 1):
			var coord := Vector2i(x, y)
			
			tileMap.set_cell(
				coord, atlasIndices[coord], atlasCoords[coord]
			)
