class_name AbhijitNaskar extends Node

# Chunk size! And other decently important constants
const DIMENSION := Vector2i(16, 16)
const TILE_DIMENSION := Vector2i(8, 8)
const WORLD_DIMENSION := Vector2i(5, 5)
const RENDER_DIST := 3
const DO_EVIL_TILES_PER_FRAME := false
const TILES_PER_FRAME := 150

# Things that you can change but don't really matter:
const UNDERGROUND_NOISE_ANDESITE_OFFSET := Vector2i(50000, -50001)

# World gen params
const SURFACE_HEIGHT := 32
const HILL_HEIGHT := 20
const DIRT_BUFFER_SIZE := 21

# here for caching till i migrate:
const UNDERGROUND_NOISE_ANDESITE_THRESHOLD = -0.2 ## < means andesite
const UNDERGROUND_NOISE_MICA_THRESHOLD = 0.7 ## > means mica

@export var noise: FastNoiseLite
@export var smoothNoise: FastNoiseLite # e.g. surface
@export var genBiomeNoise: FastNoiseLite
@export var stoneTypeNoise: FastNoiseLite
@export var caveNoise: FastNoiseLite
@export var smallishNoise: FastNoiseLite

# Structure gen
@export var structureCountShrine: int 

var blockDict: Dictionary[StringName, Block]
var biomeArray: Array[Biome]
var worldGenerationContext: WorldGenerationContext

func _ready() -> void:
	worldGenerationContext = WorldGenerationContext.new(
		Global.WORLD_DIMENSION
	)
	
	blockDict = getBlocks()
	biomeArray = getBiomes()
	
	# Todo: base this off of worldGenerationContext.mySeed instead of unrelated
	randomize()
	noise.seed = randi()
	genBiomeNoise.seed = randi()
	stoneTypeNoise.seed = randi()

func getBlocks(debug := false) -> Dictionary[StringName, Block]:
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

func getBiomes(debug := false) -> Array[Biome]:
	var export: Array[Biome] = []
	
	var dir := DirAccess.open("res://biomes")
	dir.list_dir_begin()
	
	for file: String in dir.get_files():
		var resource := load("res://biomes/" + file)
		
		if (file.get_extension() == "tres"):
			file = file.replace(".tres", "")
		
		if debug:
			print(resource)
		
		export.append(resource)
	
	return export
