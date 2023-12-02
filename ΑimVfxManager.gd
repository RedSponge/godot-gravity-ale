extends Node

@export var canvas_item: CanvasItem;
var _desired: float = 0;
var _power: float = 0;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	_power = lerp(_power, _desired, 0.1)
	# _set_vfx_power(_power)

func _set_vfx_power(vfx_power: float):
	_set_barrel_percent(vfx_power)
	_set_scatter_percent(vfx_power)

func _set_barrel_percent(barrel_percent: float):
	_get_material().set_shader_parameter("u_barrel_power", barrel_percent)

func _set_scatter_percent(scatter_percent: float):
	_get_material().set_shader_parameter("u_scatter_percent", scatter_percent)

func _get_material() -> Material:
	return canvas_item.material

func _on_player_start_aim():
	_desired = 0.05

func _on_player_shoot(_target):
	_desired = 0
