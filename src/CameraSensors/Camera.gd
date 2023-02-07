extends Camera

var pitch: float = 0.0
var roll: float = 0.0
var yaw: float = 0.0

var initial_yaw : float = 0.0

var kp : float = 0.98
var kr : float = 0.98
var ky : float = 0.98

var yaw_enabled : bool = true
var pitch_enabled : bool = true
var roll_enabled : bool = true

onready var check_acc := $"../CanvasLayer/PanelContainer/VBoxContainer/CheckBox"
onready var check_magn := $"../CanvasLayer/PanelContainer/VBoxContainer/CheckBox2"
onready var check_gyro := $"../CanvasLayer/PanelContainer/VBoxContainer/CheckBox3"

func _ready():
	yield(get_tree(),"idle_frame")
	var magnet: Vector3 = Input.get_magnetometer()
	print(magnet)
	initial_yaw = atan2(-magnet.x, magnet.z) 

func _physics_process(delta):
	var magnet: Vector3 = Input.get_magnetometer().rotated(-Vector3.FORWARD, rotation.z).rotated(Vector3.RIGHT, rotation.x)
	var gravity: Vector3 = Input.get_gravity()
	var roll_acc = atan2(-gravity.x, -gravity.y) 
	gravity = gravity.rotated(-Vector3.FORWARD, rotation.z)
	var pitch_acc = atan2(gravity.z, -gravity.y)
	var yaw_magnet = atan2(-magnet.x, magnet.z)
	
	var gyroscope: Vector3 = Input.get_gyroscope().rotated(-Vector3.FORWARD, roll)
	pitch = lerp_angle(pitch_acc, pitch + gyroscope.x * delta, kp) * int(pitch_enabled)
	yaw = lerp_angle(yaw_magnet, yaw + gyroscope.y * delta, ky) * int(yaw_enabled)
	roll = lerp_angle(roll_acc, roll + gyroscope.z * delta, kr) * int(roll_enabled)
	
	rotation = Vector3(pitch, yaw - initial_yaw, roll)


func _on_Timer_timeout():
	$"../CanvasLayer/PanelContainer/VBoxContainer/Label".text = "Accelerometer: %s\nMagnetometer: %s\nGyroscope: %s\n" % [var2str(Input.get_gravity()), var2str(Input.get_magnetometer()), var2str(Input.get_gyroscope())]


func _update_ks():
	roll_enabled = true
	pitch_enabled = true
	yaw_enabled = true
	
	if not (check_acc.pressed or check_gyro.pressed):
		pitch_enabled = false
		roll_enabled = false
	elif check_acc.pressed and check_gyro.pressed:
		kp = 0.98
		kr = 0.98
	else:
		kp = 0 if not check_gyro.pressed else 1
		kr = 0 if not check_gyro.pressed else 1
		
	if not (check_magn.pressed or check_gyro.pressed):
		yaw_enabled = false
	elif check_magn.pressed and check_gyro.pressed:
		ky = 0.98
	else:
		ky = 0 if not check_gyro.pressed else 1
	pass
