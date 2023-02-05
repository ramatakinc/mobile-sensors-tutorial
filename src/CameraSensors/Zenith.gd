extends Spatial

var pitch: float = 0.0
var roll: float = 0.0
var yaw: float = 0.0

var initial_yaw : float = 0.0

var k : float = 0.98

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
	pitch = lerp_angle(pitch_acc, pitch + gyroscope.x * delta, k)
	yaw = lerp_angle(yaw_magnet, yaw + gyroscope.y * delta, k)
	roll = lerp_angle(roll_acc, roll + gyroscope.z * delta, k) 
	
	rotation = Vector3(pitch, yaw - initial_yaw, roll)
