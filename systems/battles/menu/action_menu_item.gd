class_name ActionMenuItem
extends BaseButton

# --- Variables --- #
@export var item: Resource

# --- References --- #
@onready var icon_rect := $"icon" as TextureRect
@onready var backing := $"backing" as Control
@onready var cooldown_label := $"cooldown_label" as RichTextLabel

# --- Functions --- #
func _ready() -> void:
	pressed.connect(set_item)

func show_outline() -> void:
	backing.visible = true

func hide_outline() -> void:
	backing.visible = false

func set_menu_item(new_item: Resource) -> void:
	item = new_item
	
	visible = not not item
	
	if item and "icon" in item:
		icon_rect.texture = item.icon
	
	# cooldown
	if not (item and 'remaining_cooldown' in item):
		return
	
	if item.remaining_cooldown > 0:
		icon_rect.material.set_shader_parameter('intensity', 0.5)
		cooldown_label.clear()
		cooldown_label.push_outline_size(2)
		cooldown_label.append_text(str(item.remaining_cooldown))
		cooldown_label.pop()
	else:
		icon_rect.material.set_shader_parameter('intensity', 0.0)
		cooldown_label.text = ""

func set_item() -> void:
	if item is Attack and item.remaining_cooldown > 0:
		return
	
	Globals.set_item(item)
	release_focus()
