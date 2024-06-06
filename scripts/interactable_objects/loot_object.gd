class_name LootObject
extends Interactable

# --- Variables --- #
@export var loot_key: String
@export var loot: Array[LootItem]

@export_group("Sprites")
@export var collected_sprite: Texture2D
@onready var sprite := $"sprite"

# --- Functions --- #
func _ready() -> void:
	super()
	interacted_with.connect(collect_loot)
	
	check_loot()

func check_loot() -> void:
	if DataManager.is_open(loot_key):
		set_collected()

func collect_loot() -> void:
	# Load loot
	for item in loot:
		print("Sent \'", item.item_key, "\' (x", item.quantity, ") to \'", item.inventory, "\'")
	
	# Set flag
	DataManager.open_chest(loot_key)
	
	# Set interactivity
	set_collected()

func set_collected() -> void:
	sprite.texture = collected_sprite
	interactable = false
	set_box_visibility(false)
