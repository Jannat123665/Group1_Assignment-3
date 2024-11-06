extends Node3D

var g: float = 9.81 # gravity
var length1: float = -1.0 # length of the first pendulum arm
var length2: float = -1.0 # length of the second pendulum arm
var mass1: float = 1.0 # mass of the first pendulum bob
var mass2: float = 1.0 # mass of the second pendulum bob

var angle1: float = PI / 4 # start angle for the first arm
var angle2: float = PI / 6 # start angle for the second arm
var angle1_velocity: float = 0.0
var angle2_velocity: float = 0.0

var arm1: Node3D
var arm2: Node3D
var bob1: Node3D
var bob2: Node3D

func _ready():

	arm1 = $Arm1/String1
	bob1 = $Arm1/Bob2
	arm2 = $Arm1/Arm2/String1
	bob2 = $Arm1/Arm2/Bob2

	
	if arm1 == null or bob1 == null or arm2 == null or bob2 == null:
		print("Error: One or more nodes are not assigned correctly.")
		return

func _physics_process(delta):

	var num1 = -g * (2 * mass1 + mass2) * sin(angle1)
	var num2 = -mass2 * g * sin(angle1 - 2 * angle2)
	var num3 = -2 * sin(angle1 - angle2) * mass2
	var num4 = angle2_velocity ** 2 * length2 + angle1_velocity ** 2 * length1 * cos(angle1 - angle2)
	var denominator = length1 * (2 * mass1 + mass2 - mass2 * cos(2 * angle1 - 2 * angle2))
	var angle1_acceleration = (num1 + num2 + num3 * num4) / denominator

	num1 = 2 * sin(angle1 - angle2)
	num2 = (angle1_velocity ** 2 * length1 * (mass1 + mass2))
	num3 = g * (mass1 + mass2) * cos(angle1)
	num4 = angle2_velocity ** 2 * length2 * mass2 * cos(angle1 - angle2)
	denominator = length2 * (2 * mass1 + mass2 - mass2 * cos(2 * angle1 - 2 * angle2))
	var angle2_acceleration = (num1 * (num2 + num3 + num4)) / denominator


	angle1_velocity += angle1_acceleration * delta
	angle2_velocity += angle2_acceleration * delta
	angle1 += angle1_velocity * delta
	angle2 += angle2_velocity * delta

	# 
	update_pendulum_positions()

func update_pendulum_positions():

	var bob1_position = Vector3(length1 * sin(angle1), -length1 * cos(angle1), 0)
	bob1.global_transform.origin = arm1.global_transform.origin + bob1_position

	
	arm1.look_at(bob1.global_transform.origin, Vector3(1, 1, 1))

	
	arm2.global_transform.origin = bob1.global_transform.origin

	
	var bob2_position = Vector3(length2 * sin(angle2), -length2 * cos(angle2), 0)
	bob2.global_transform.origin = arm2.global_transform.origin + bob2_position

	
	arm2.look_at(bob2.global_transform.origin, Vector3(1, 1, 1))
