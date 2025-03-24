class_name StatusEffectButton
extends TextureRect

# --- Variables --- #
var effect: StatusEffect

# --- References --- #
@onready var stacks_label := $"stacks" as RichTextLabel

# --- Functions --- #
func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered() -> void:
	if not effect:
		return
	
	Tooltip.set_width(100)
	Tooltip.set_title_text(effect.name)
	Tooltip.set_body_text(effect.description)
	Tooltip.show_tooltip()

func _on_mouse_exited() -> void:
	if not effect:
		return
	
	Tooltip.hide_tooltip()

func set_effect(new_effect: StatusEffect) -> void:
	# clear tooltip if just removed
	if effect and not new_effect:
		if Tooltip.has_title(effect.name):
			Tooltip.hide_tooltip()
	
	effect = new_effect
	
	visible = not not effect
	
	if not effect:
		return
	
	texture = effect.get_icon()
	
	if effect.max_stack > 1:
		stacks_label.text = " " + str(effect.stacks)
	else:
		stacks_label.text = ""
