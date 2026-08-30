class_name Threshold extends Resource

enum Type { LESS_THAN, GREATER_THAN }

@export var type: Type
@export_range(-1, 1, 0.01, "or_greater") var threshold: float

func test(value: float) -> bool:
	if type == Type.LESS_THAN:
		return ( value < threshold )
	return ( value > threshold )
