extends Node

@export var mob_scene: PackedScene
var score
var is_running = false

# Called when the node enters the scene tree for the first time.
func _ready():
	new_game()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func new_game():
	score = 0
	$CanvasGroup/Player.start(%Markers/StartPosition.position)

func game_over():
	%Logic/ScoreTimer.stop()
	%Logic/AsteroidTimer.stop()
	is_running = false;


func _on_score_timer_timeout():
	score += 1


func begin_game():
	if is_running:
		return
	is_running = true
	$Logic/ScoreTimer.start()
	$Logic/AsteroidTimer.start()

func _on_start_timer_timeout():
	begin_game()

func _on_asteroid_timer_timeout():
	var asteroid = mob_scene.instantiate()
	var mob_spawn_location: PathFollow2D = get_node("AsteroidPath/AsteroidSpawnLocation")
	mob_spawn_location.progress_ratio = randf()
	
	var direction = mob_spawn_location.rotation + PI / 2;
	asteroid.position = mob_spawn_location.position;
	
	direction += randf_range(-PI / 4, PI / 4)
	asteroid.rotation = direction
	
	var velocity = Vector2(randf_range(150.0, 250.0), 0)
	asteroid.set_velocity(velocity.rotated(direction))
	
	asteroid.add_to_group("targetable")
	$CanvasGroup.add_child(asteroid)


func _on_player_shoot(_target):
	if !is_running:
		begin_game()
