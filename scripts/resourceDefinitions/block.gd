class_name Block extends Resource

@export_group("Display")
@export var displayName: String
@export var displayDesc: String

@export_group("Visuals")
@export var sourceAtlas: int
@export_enum("prototype(00)", "tileV1") var atlasType: int

@export_group("Features")
