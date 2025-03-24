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
	
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered() -> void:
	show_outline()
	
	# show tooltip
	#if 'remaining_cooldown' in item and item.remaining_cooldown > 0:
		#Tooltip.set_title_text("On Cooldown")
		#if item.remaining_cooldown != 1:
			#Tooltip.set_body_text("Recharges in " + str(item.remaining_cooldown) + " turns")
		#else:
			#Tooltip.set_body_text("Recharges in " + str(item.remaining_cooldown) + " turn")
		#
		#Tooltip.show_tooltip()

func _on_mouse_exited() -> void:
	hide_outline()
	
	# hide tooltip
	#Tooltip.hide_tooltip()

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
		cooldown_label.text = ""
		return
	
	if item.remaining_cooldown > 0:
		icon_rect.material.set_shader_parameter('intensity', 0.5)
		cooldown_label.text = " " + str(item.remaining_cooldown)
	else:
		icon_rect.material.set_shader_parameter('intensity', 0.0)
		cooldown_label.text = ""

func set_item() -> void:
	if item is Attack and item.remaining_cooldown > 0:
		return
	
	for entity: Entity in get_tree().get_nodes_in_group(&'player'):
		entity.brain._on_action_selected(item)
	
	release_focus()
