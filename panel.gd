extends Panel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

@export var camera: MeshInstance3D

@export var object1: MeshInstance3D

var pos = Vector3(0, 0, 1)
var angles = Vector2(0, 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	self.set_instance_shader_parameter("dir", Vector3(cos(angles.x)*sin(angles.y), sin(angles.x)*sin(angles.y), cos(angles.y)))
	self.set_instance_shader_parameter("object1", Vector4(object1.position.x, object1.position.y, object1.position.z, object1.scale.x))
	self.set_instance_shader_parameter("pos", pos)
	
	pos.x += Input.get_axis("right", "left") * delta
	pos.y += Input.get_axis("down", "up") * delta
	pos.z += Input.get_axis("backward", "forward") * delta
	
	angles.x -= Input.get_axis("turnLeft", "turnRight") * delta*2
	angles.y = clamp(angles.y - Input.get_axis("turnUp", "turnDown") * delta*2, -PI/2, PI/2)
	
	camera.position = pos
	
	camera.get_child(0).rotation = Vector3(angles.y, angles.x, 0)
	
	if Input.is_action_just_pressed("changeMode"):
		self.visible = not self.visible
