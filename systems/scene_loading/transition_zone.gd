class_name TransitionZone
extends Area2D

# --- Signals --- #
signal transition_reached(dir: String)

# --- Variables --- #
@export var direction: String

# --- Functions --- #
func _ready():
	body_entered.connect(player_entered)

func player_entered(_body: Node2D):
	transition_reached.emit(direction)
