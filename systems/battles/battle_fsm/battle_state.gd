class_name BattleState
extends Node2D

# --- References --- #
@onready var fsm: BattleFsm = $".."
@onready var root: BattleManager = $"../.."

# --- Functions --- #
func state_entered():
	print("state entered")

func action_performed():
	print("action performed")

func state_exited():
	print("state exited")
