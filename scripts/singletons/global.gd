class_name AbhijitNaskar extends Node

# Chunk size! And other decently important constants
const DIMENSION := Vector2i(96, 96)
const TILE_DIMENSION := Vector2i(8, 8)
const RENDER_DIST := 1

# Things that you can change but don't really matter:
const UNDERGROUND_NOISE_ANDESITE_OFFSET := Vector2i(50000, -50000)

# World gen params
const SURFACE_HEIGHT := 32
const HILL_HEIGHT := 20
const DIRT_BUFFER_SIZE := 4
const UNDERGROUND_NOISE_CAVE_THRESHOLD = -0.1 ## < means open air
const UNDERGROUND_NOISE_ANDESITE_THRESHOLD = -0.2 ## < means andesite

var blockDict: Dictionary[StringName, Block]

var noise: FastNoiseLite

func _ready() -> void:
	blockDict = getBlocks()
	
	randomize()
	noise = FastNoiseLite.new()
	noise.seed = randi()
	noise.noise_type = noise.NoiseType.TYPE_VALUE_CUBIC
	noise.fractal_octaves = 4
	noise.fractal_gain = 0.6
	noise.fractal_lacunarity = 2.5
	noise.frequency = 0.02

func getBlocks(debug = false) -> Dictionary[StringName, Block]:
	var export: Dictionary[StringName, Block] = {}
	
	var dir := DirAccess.open("res://blocks")
	dir.list_dir_begin()
	
	for file: String in dir.get_files():
		var resource := load("res://blocks/" + file)
		
		if (file.get_extension() == "tres"):
			file = file.replace(".tres", "")
		
		if debug:
			print(resource)
		
		export[StringName(file)] = resource
	
	return export
