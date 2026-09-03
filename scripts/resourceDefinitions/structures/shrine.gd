class_name ShrineStructure extends Structure

const SHAPE: String = """
  BB  
 BBBB 
BBXXBB
BB  BB
      
      
      
BBBBBB
BBBBBB
"""

const KEY: Dictionary[String, StringName] = {
	"B": &"_replaceBrickRandom",
	" ": &"_",
	"X": &"shineStone",
}

func _init(globalPos) -> void:
	generate(globalPos)

func generate(_globalPos: Vector2i) -> void:
	blocks = parseStringShape(SHAPE, KEY)
	
	var brickType = [
		&"redBrick", &"greenBrick", &"greyBrick", &"blueBrick"
	].pick_random()
	
	for coord in blocks.keys():
		if blocks[coord] == &"_replaceBrickRandom":
			blocks[coord] = brickType
