class_name ActionResource
extends Resource

# --- Enums --- #
enum TargetSide { PLAYER = 1, ENEMY = 2, BOTH = PLAYER | ENEMY }
enum TargetingMode { SINGLE, AOE, ALL, RANDOM }

# --- Variables --- #
@export var name: String
@export var animation_name: StringName
@export var icon: Texture2D

@export_multiline var description: String

@export var side: TargetSide = TargetSide.PLAYER
@export var targeting: TargetingMode = TargetingMode.SINGLE

@export var cooldown: int
var remaining_cooldown: int

# --- Functions --- #
func perform_action(_target: Entity) -> void:
	return

func can_target(target: Entity) -> bool:
	return (side & TargetSide.ENEMY != 0 and not target.is_player()) or (side & TargetSide.PLAYER != 0 and target.is_player())

func highlight_targets() -> void:
	if side & TargetSide.ENEMY:
		var enemies = TargetingHelper.get_entities(&'enemy')
		
		for enemy in enemies:
			enemy.targeting.set_targetable(true)
	if side & TargetSide.PLAYER:
		var players = TargetingHelper.get_entities(&'player')
		
		for player in players:
			player.targeting.set_targetable(true)

#region Cooldown
func start_cooldown(val: int = -1) -> void:
	if val < 0:
		if cooldown > 0:
			val = cooldown + 1
		else:
			val = 0
	
	remaining_cooldown = val

func decrement_cooldown() -> void:
	remaining_cooldown = max(remaining_cooldown - 1, 0)
#endregion
