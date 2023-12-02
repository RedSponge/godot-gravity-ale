extends Node2D

@export var targetable: Node2D;


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if targetable == null:
		hide()
	else:
		show()
		position = targetable.global_position

func set_target(new_targetable: Node2D) -> void:
	self.targetable = new_targetable
