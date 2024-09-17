extends Node3D



@export var current:bool = false;

const WALKING_SPEED:float = 0.05;
const LOOKING_SPEED:float = 0.01;

var HEAD_NODE_POINTER:Node3D = null;
var FP_CAM_POINTER:Camera3D = null;
var TP_CAM_POINTER:Camera3D = null;

var is_fp:bool = true; #true means first person false means third person


var head_rotation_vector:Vector3 = Vector3.ZERO;


func _ready():
	if is_current():
		become_current();
	$AnimationPlayer.play("loop")
	HEAD_NODE_POINTER = $head;
	FP_CAM_POINTER = $head/first_person_cam;
	TP_CAM_POINTER = $head/third_person_cam;



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
	FP_CAM_POINTER.current = true;	


func is_current():
	return current;

func move_forward():
	position.x -= WALKING_SPEED * sin(head_rotation_vector.y);
	position.z -= WALKING_SPEED * cos(head_rotation_vector.y); 
	
func move_back():
	position.x -= WALKING_SPEED * sin(head_rotation_vector.y+3.14);
	position.z -= WALKING_SPEED * cos(head_rotation_vector.y+3.14); 
	
	
func move_left():
	position.x -= WALKING_SPEED * sin(head_rotation_vector.y+1.512);
	position.z -= WALKING_SPEED * cos(head_rotation_vector.y+1.512);
 
	
func move_right():
	position.x -= WALKING_SPEED * sin(head_rotation_vector.y-1.512);
	position.z -= WALKING_SPEED * cos(head_rotation_vector.y-1.512);
 
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


func _on_selection_area_area_entered(area):
	$selection_area.visible = true;


func _on_selection_area_area_exited(area):
	$selection_area.visible = false;
