class_name LootObject
extends Interactable

# --- Variables --- #
@export var loot_path: String

@export_group("Sprites")
@export var collected_sprite: Texture2D
@onready var sprite := $"sprite"

# --- Functions --- #
func _ready():
	super()
	interacted_with.connect(collect_loot)

func collect_loot():
	print("Collected loot from path: ", loot_path)
	sprite.texture = collected_sprite
	interactable = false
	set_box_visibility(false)
