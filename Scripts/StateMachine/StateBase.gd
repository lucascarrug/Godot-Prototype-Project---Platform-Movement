class_name StateBase 
extends Node

# Reference to node which is going to be controlled.
@onready var controller_node : Node = self.owner
# Reference to state machine.
var state_machine : StateMachine

## Commun methods.
func start():
	pass
	
	
func end():
	pass
