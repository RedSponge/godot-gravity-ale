extends Node

@export var marker: Node;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_player_choose_target(player_target: Node2D):
	marker.set_target(player_target)
