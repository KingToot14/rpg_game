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
@export var shader_texture: ViewportTexture

# --- Functions --- #
func _ready() -> void:
	RenderingServer.global_shader_parameter_set('overworld_shader_texture', shader_texture)

func _process(delta) -> void:
	for i in range(4):
		var player = DataManager.players[i]
		if player.role != PlayerDataChunk.PlayerRole.NONE:
			#TODO: Change this
			player.heal(heal_rate * 20 * delta)
