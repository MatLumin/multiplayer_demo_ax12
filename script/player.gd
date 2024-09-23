extends Node3D


var SHARED_CONST = load("res://script/SHARED_CONST.gd");

@export var username:String = "None";

@export var current:bool = false;



const LOOKING_SPEED:float = 0.02;

var HEAD_NODE_POINTER:Node3D = null;
var FP_CAM_POINTER:Camera3D = null;
var TP_CAM_POINTER:Camera3D = null;

var is_fp:bool = true; #true means first person false means third person

var velocity_vector:Vector3 = Vector3.ZERO;
const WALKING_SPEED:float = 0.2;
var walking_fricition = 0.01;
var head_rotation_vector:Vector3 = Vector3.ZERO;

func indexual_rounding(index, number):
	#0.n index is 1
	#0.0n index is 2
	#n.0 index is 0
	return round(number*(10**index))/(10**index)

func _ready():
	if is_current():
		become_current();
	$AnimationPlayer.play("loop")
	HEAD_NODE_POINTER = $head;
	FP_CAM_POINTER = $head/first_person_cam;
	TP_CAM_POINTER = $head/third_person_cam;
	print(self.username);
	$declare_player_on_server_setter.request(SHARED_CONST.SERVER_HOST+"/create_player?username=%s" % self.username);
	$username_display.mesh.text = username;
	

func switch_to_fp():
	is_fp = true;
	FP_CAM_POINTER.current = true;
	TP_CAM_POINTER.current = false;

func switch_to_tp():
	is_fp = false;
	FP_CAM_POINTER.current = false;
	TP_CAM_POINTER.current = true;

func become_current():
	return;
	FP_CAM_POINTER.current = false;	


func is_current():
	return current;

func move_forward():
	velocity_vector.x = -WALKING_SPEED * sin(head_rotation_vector.y);
	velocity_vector.z = -WALKING_SPEED * cos(head_rotation_vector.y); 
	
func move_back():
	velocity_vector.x = -WALKING_SPEED * sin(head_rotation_vector.y+3.14);
	velocity_vector.z = -WALKING_SPEED * cos(head_rotation_vector.y+3.14); 
	
	
func move_left():
	velocity_vector.x = -WALKING_SPEED * sin(head_rotation_vector.y+1.512);
	velocity_vector.z = -WALKING_SPEED * cos(head_rotation_vector.y+1.512);
 
	
func move_right():
	velocity_vector.x = -WALKING_SPEED * sin(head_rotation_vector.y-1.512);
	velocity_vector.z = -WALKING_SPEED * cos(head_rotation_vector.y-1.512);
 
func do_nothin():
	pass


func _input(event):
	if is_current() == false:
		return 
	var is_mouse_motion:bool = event is InputEventMouseMotion;
	var is_forward:bool = event.is_action("move_forward_player");
	var is_backward:bool = event.is_action("move_backward_player");
	var is_left:bool = event.is_action("move_left_player");
	var is_right:bool = event.is_action("move_right_player");
	var is_fp_tp_switch = event.is_action_released("fp_tp_switch");

		
	if (is_mouse_motion):
		var relative:Vector2 = event.relative;
		head_rotation_vector.y -= relative.x * LOOKING_SPEED;
		head_rotation_vector.x -= relative.y * LOOKING_SPEED;
	
	if is_forward:
		move_forward();
	if is_backward:
		move_back();
	if is_left:
		move_left();
	if is_right:
		move_right()
	if is_fp_tp_switch:
		if is_fp == false:
			switch_to_fp();
		elif is_fp == true:
			switch_to_tp();
		
	

	

		

func _process(delta):
	HEAD_NODE_POINTER.rotation.x = head_rotation_vector.x;
	HEAD_NODE_POINTER.rotation.y = head_rotation_vector.y;
	position.x += velocity_vector.x;
	position.z += velocity_vector.z;
	
	var velx = velocity_vector.x; 
	var velz = velocity_vector.z; 

	if velx != 0:
		velocity_vector.x += walking_fricition * (velx/abs(velx)*-1);
	if velz != 0:
		velocity_vector.z += walking_fricition * (velz/abs(velz)*-1);
		
	velocity_vector.x=indexual_rounding(2,velocity_vector.x);
	velocity_vector.z=indexual_rounding(2,velocity_vector.z);
			
	print(velocity_vector)
	
func _on_selection_area_area_entered(area):
	$selection_area.visible = true;


func _on_selection_area_area_exited(area):
	$selection_area.visible = false;


func _on_update_self_data_on_server_timer_timeout():
	
	var x = (position.x);
	var z = (position.z);
	var username = username;
	var head_rot_y = (head_rotation_vector.y);
	var head_rot_x = (head_rotation_vector.x);
	var velocity_x = velocity_vector.x; 
	var velocity_z = velocity_vector.z;
	var other = "/set_player_pos?x={x}&z={z}&head_rot_y={head_rot_y}&head_rot_x={head_rot_x}&username={username}&velocity_x={velocity_x}&velocity_z={velocity_z}".format({"x":x,"z":z,"head_rot_y":head_rot_y,"head_rot_x":head_rot_x, "username":username, "velocity_x":velocity_x, "velocity_z":velocity_z});
	var url = SHARED_CONST.SERVER_HOST+other;
	$update_self_data_on_server_setter.request(
		url
		);
	$update_self_data_on_server_timer.start();
		
		
func update_self_data(x, z, head_rot_x, head_rot_y, velocity_x, velocity_z):
	self.position.z = z;
	self.position.x = x;
	self.head_rotation_vector.x = head_rot_x;
	self.head_rotation_vector.y = head_rot_y;
	#self.velocity_vector.x = velocity_x;
	#self.velocity_vector.z = velocity_z;
	
