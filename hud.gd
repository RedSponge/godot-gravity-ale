extends CanvasLayer

@export var score: int;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	display_score(score)

func display_score(new_score: int):
	$Score.text = "Score: " + str(new_score)
