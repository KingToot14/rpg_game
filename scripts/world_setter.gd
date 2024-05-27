class_name WorldSetter
extends SubViewport

# --- Variabels --- #
@export var visibility_layer: int = 2

# --- Functions --- #
func _ready():
	var viewport = get_tree().root
	
	# Use global world instead of local world
	world_2d = viewport.world_2d
	
	# Remove visibility flags from main viewport
	if visibility_layer > 0:
		viewport.set_canvas_cull_mask_bit(visibility_layer - 1, false)
