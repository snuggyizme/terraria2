class_name Chunk extends Node2D

var chunkPosition := Vector2i.ZERO

var blocks: Array = []

@onready var tileMap = $TileMapLayer

func _ready() -> void:
	generate()
	update()

func generate() -> void:
	for x in range(Global.DIMENSION.x):
		blocks.append([])
		blocks[x].resize(Global.DIMENSION.y)
		
		for y in range(Global.DIMENSION.y):
			var globalPosition := chunkPosition * Global.DIMENSION + Vector2i(x, y)
			
			var height := Global.noise.get_noise_1d(globalPosition.x) # -1 to 1
			
			var surfaceY := int(
				Global.SURFACE_HEIGHT + 
				Global.HILL_HEIGHT * height
			)
			
			if globalPosition.y < surfaceY:
				blocks[x][y] = &"_"
			elif globalPosition.y == surfaceY:
				blocks[x][y] = &"grass"
			elif globalPosition.y < surfaceY + Global.DIRT_BUFFER_SIZE:
				blocks[x][y] = &"dirt"
			else:
				# If no one cares about this poor block it's gonna be rock hard
				blocks[x][y] = &"stone"
				
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
					blocks[x][y] = &"andesite"
				# Caves override andesite because I like Cave Johnson;
				if caveNoise < Global.UNDERGROUND_NOISE_CAVE_THRESHOLD:
					blocks[x][y] = &"_"

func update() -> void:
	var terrainCells: Array[Vector2i] = []
	
	tileMap.clear()
	
	for x in range(Global.DIMENSION.x):
		for y in range(Global.DIMENSION.y):
			var blockID = blocks[x][y]
			
			if blockID == &"_":
				continue
			
			terrainCells.append(Vector2i(x, y))
	
	tileMap.set_cells_terrain_connect(
		terrainCells,
		0,
		0,
	)
	
	for x in range(Global.DIMENSION.x):
		for y in range(Global.DIMENSION.y):
			var coordFromCell = tileMap.get_cell_atlas_coords(Vector2i(x, y))
			
			if coordFromCell == Vector2i(-1, -1):
				continue
			
			var block: Block = Global.blockDict.get(
				blocks[x][y], Global.blockDict[&"test"]
			)
			
			tileMap.erase_cell(coordFromCell)
			tileMap.set_cell(Vector2i(x, y), block.sourceAtlas, coordFromCell)

func _input(_event: InputEvent) -> void:
	print("hai")
	Global.noise.seed += 1
	generate()
	update()
	print("ouch")
