extends Node2D

signal hit
var speed = 100;

var _is_aiming: bool = false
var _current_target = 0
var velocity: Vector2 = Vector2.ZERO

const FLING_STRENGTH = 1
const FLY_THRESHOLD = 100

signal start_aim
signal choose_target
signal shoot

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play()
	pass # Replace with function body.

func _update_animation():
	if _is_aiming:
		$AnimatedSprite2D.animation = "aim"
	else:
		if velocity.length_squared() > FLY_THRESHOLD * FLY_THRESHOLD:
			$AnimatedSprite2D.animation = "fly"
		else:
			$AnimatedSprite2D.animation = "idle"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_move(delta)
	if !is_aiming():
		if Input.is_action_pressed("take_aim"):
			_start_aiming()
	else:
		_aim()
		if !Input.is_action_pressed("take_aim"):
			_shoot()
	_update_animation()
	

func _move(delta):
	position += velocity * delta
	
func is_aiming() -> bool:
	return _is_aiming

func _fling_towards(target):
	self.velocity = (target.global_position - global_position) * FLING_STRENGTH

func _shoot():
	var targetables = get_tree().get_nodes_in_group("targetable")
	if len(targetables) == 0:
		return
	var target = targetables[_current_target]
	_fling_towards(target)
	_is_aiming = false
	shoot.emit(target)

func _compute_new_current_target(current, targets):
	var new_target = current
	if Input.is_action_just_pressed("aim_right"):
		new_target += 1
	if Input.is_action_just_pressed("aim_left"):
		# Alright thanks to modulu later
		new_target += len(targets) - 1
	
	new_target %= len(targets)
	return new_target
	
func _rotate_gun_towards(target):
	var angle = get_angle_to(target.global_position)
	$Gun.rotation = lerp_angle($Gun.rotation, angle, 0.1)

func _face(target):
	var angle = get_angle_to(target.global_position)
	$AnimatedSprite2D.flip_h = abs(angle) > PI / 2

func _aim():
	var targetables = get_tree().get_nodes_in_group("targetable")
	if len(targetables) == 0:
		return
	_set_target_index(_compute_new_current_target(_current_target, targetables))	
	_update_aim_rendering_towards(targetables[_current_target])

func _update_aim_rendering_towards(target: Node2D):
	_rotate_gun_towards(target)
	_face(target)

func _set_target_index(new_target_index: int):
	var targetables = get_tree().get_nodes_in_group("targetable")
	if len(targetables) > 0:
		choose_target.emit(targetables[new_target_index])
	_current_target = new_target_index

func _start_aiming():
	start_aim.emit()
	_is_aiming = true
	_set_target_index(0)

func _on_area_2d_area_entered(_area):
	hit.emit()
	hide()

func start(new_position: Vector2):
	position = new_position
	
