class_name AreaInformation
extends Node2D

# --- Variables --- #
@export_group("Areas")
@export_file("*.tscn") var top_area: String
@export_file("*.tscn") var bottom_area: String
@export_file("*.tscn") var left_area: String
@export_file("*.tscn") var right_area: String

@export_group("Conditions")
@export var heal_rate: float = 0.20

@export_group("Shaders")
@export var shader_texture: Texture2D

# --- Functions --- #
func _ready() -> void:
	RenderingServer.global_shader_parameter_set('overworld_shader_texture', shader_texture)
