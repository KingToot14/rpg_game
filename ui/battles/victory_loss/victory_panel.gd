class_name VictoryPanel
extends Control

# --- Variables --- #
@export var xp_bars: Array[PlayerXpBar] = []

# --- References --- #
@onready var xp_label := %'xp_label' as RichTextLabel
@onready var return_button := %'return_button' as BaseButton

# --- Functions --- #
func _ready() -> void:
	hide()
	return_button.hide()

func show_xp(value: int) -> void:
	update_label(value)
	
	var tween = create_tween()
	
	tween.tween_property(self, 'position:y', position.y, 0.40).from(290).set_trans(Tween.TRANS_BACK)
	tween.tween_interval(0.50)
	tween.finished.connect(set_xp.bind(value))
	
	show()

func update_label(value: int) -> void:
	var xp_string = str(value)
	
	xp_label.text = "[center]Essence Gained: " + xp_string

func set_xp(value: int) -> void:
	for xp_bar in xp_bars:
		xp_bar.add_xp(value)
	
	# wait for adding to be completed
	for xp_bar in xp_bars:
		print(xp_bar.is_done_adding)
		
		if not xp_bar.is_done_adding:
			await xp_bar.done_adding
	
	show_return_button()

func show_return_button() -> void:
	var tween = create_tween().set_parallel()
	
	return_button.modulate.a = 0.0
	
	tween.tween_property(return_button, ^'position:x', return_button.position.x, 0.15).from(return_button.position.x - 10)
	tween.tween_property(return_button, ^'modulate:a', 1.0, 0.15)
	
	return_button.show()
