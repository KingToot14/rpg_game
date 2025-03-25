class_name ItemDataChunk
extends Resource

# --- Variables --- #
@export var name: String
@export var key: StringName
@export_multiline var description: String
@export var in_battle := false
# @@show_if(in_battle)
@export var attack: Attack

@export var inventory: StringName
@export var icon: Texture2D
@export var quantity: int

# --- Functions --- #
func get_save_data() -> Dictionary:
	return {
		'key': 		key,
		'quantity': quantity
	}
