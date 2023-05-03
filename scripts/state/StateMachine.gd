extends Node

class_name StateMachine

@export var initial_state := NodePath()

@onready var state: State = get_node(initial_state)

func _ready() -> void:
	for child in get_children():
		child.stateMachine = self
	state.enter()
	
func switchState(newStateName: String) -> void:
	print("switch state = ", newStateName)

	state.exit()
	state = get_node(newStateName)
	state.enter()

func _process(delta: float):
	state.update(delta)
