class_name Chunk extends Node2D

var chunkPosition := Vector2i.ZERO

var blocks: Dictionary = {}

@onready var tileMap = $TileMapLayer

func _ready() -> void:
	global_position = chunkPosition * Global.DIMENSION * Global.TILE_DIMENSION
	
	generate()
	update()

func generate() -> void:
	blocks.clear()
	
	for x in range(-1, Global.DIMENSION.x + 1):
		for y in range(-1, Global.DIMENSION.y + 1):
			var coord := Vector2i(x, y)
			
			if (
				x < 0 or
				y < 0 or
				x >= Global.DIMENSION.x or
				y >= Global.DIMENSION.y
			):
				blocks[coord] = &"_chunkConnect"
				continue
			
			var globalPosition := chunkPosition * Global.DIMENSION + coord
			
			var height := Global.noise.get_noise_1d(globalPosition.x) # -1 to 1
			
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

func update() -> void:
	var terrainCells: Array[Vector2i] = []
	
	for x in range(-1, Global.DIMENSION.x + 1):
		for y in range(-1, Global.DIMENSION.y + 1):
			var coord := Vector2i(x, y)
			
			var blockID = blocks[coord]
			
			if blockID == &"_":
				continue
			
			terrainCells.append(coord)
	
	tileMap.set_cells_terrain_connect(
		terrainCells,
		0,
		0,
	)
	
	for x in range(-1, Global.DIMENSION.x + 1):
		for y in range(-1, Global.DIMENSION.y + 1):
			var coord := Vector2i(x, y) 
			var coordFromCell = tileMap.get_cell_atlas_coords(coord)
			
			if coordFromCell == Vector2i(-1, -1):
				continue
			
			var block: Block = Global.blockDict.get(
				blocks[coord], Global.blockDict[&"test"]
			)
			
			tileMap.set_cell(coord, block.sourceAtlas, coordFromCell)

func _input(event: InputEvent) -> void:
	if not event.is_action_pressed("x"):
		return

	Global.noise.seed += 1
	generate()
	update()
