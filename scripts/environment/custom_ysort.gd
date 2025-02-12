class_name CustomYsort
extends Node2D

# --- Variables --- #
@export var base_z_order := 100

var slopes: Array[float] = []

# --- Functions --- #
func _ready() -> void:
	var marks: Array[Vector2] = []
	
	# get all line points
	for child in get_children():
		if child is not Marker2D: continue
		marks.append(child.global_position)
	
	# calculate slopes
	for i in range(1, len(marks)):
		var slope := (marks[i].y - marks[i - 1].y) / (marks[i].x - marks[i - 1].x)
		
		slopes.append(marks[i].x)							# end point
		slopes.append(slope)								# slope
		slopes.append(marks[i].y - slope * marks[i].x)		# intercept

func _process(_delta: float) -> void:
	var player_pos := Globals.overworld_manager.player.global_position as Vector2
	
	# check inner
	for i in range(0, len(slopes), 3):
		if player_pos.x < slopes[i] or i == len(slopes) - 3:
			# calculate point on the line
			var point = slopes[i + 1] * player_pos.x + slopes[i + 2]
			
			z_index = base_z_order + (1 if player_pos.y < point else -1)
			
			return
