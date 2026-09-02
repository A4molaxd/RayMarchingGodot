extends Panel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

@export var camera: MeshInstance3D

@export var object1: MeshInstance3D
@export var object2: MeshInstance3D


@onready var shader = preload("res://new_shader_material.tres")

var pos = Vector3(0, 0, 1)
var angles = Vector2(0, PI/2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var lr = Input.get_axis("left", "right")
	var bf = Input.get_axis("backward", "forward")
	pos.x += lr * delta * cos(-angles.x) + bf * delta * cos(-angles.x - PI/2) 
	pos.y -= Input.get_axis("down", "up") * delta
	pos.z += lr * delta * sin(-angles.x) + bf * delta * sin(-angles.x - PI/2)
	
	angles.x -= Input.get_axis("turnLeft", "turnRight") * delta*2
	angles.y = clamp(angles.y - Input.get_axis("turnDown", "turnUp") * delta*2, 0.0001, PI - 0.0001)
	
	camera.position = pos
	
	camera.get_child(0).rotation = Vector3(angles.y - PI/2, angles.x, 0)

	shader.set_shader_parameter("dir", -camera.get_child(0).global_transform.basis.z.normalized());
	shader.set_shader_parameter("right", camera.get_child(0).global_transform.basis.x.normalized());
	shader.set_shader_parameter("up", camera.get_child(0).global_transform.basis.y.normalized());
	shader.set_shader_parameter("pos", pos);
	camera.position = pos*Vector3(1, -1, 1)
	camera.get_child(0).rotation = Vector3(-(angles.y - PI/2), angles.x, 0)
	shader.set_shader_parameter("object1", Vector4(object1.position.x, object1.position.y, object1.position.z, object1.scale.x))
	shader.set_shader_parameter("object21", Vector3(object2.position.x, object2.position.y, object2.position.z))
	shader.set_shader_parameter("object22", Vector3(object2.scale.x, object2.scale.y, object2.scale.z))
	#if Input.is_action_just_pressed("changeMode"):
		#self.visible = not self.visible
