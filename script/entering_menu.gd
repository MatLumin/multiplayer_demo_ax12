extends Control
var SHARED_CONST = load("res://script/SHARED_CONST.gd");

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_button_down():
	var username = $username.text;
	var new_player = load("res://classes/player.tscn").instantiate();
	new_player.current = true;
	new_player.username = username;
	var the_tree = get_tree();
	the_tree.change_scene_to_file("res://levels/main.tscn")
	the_tree.get_root().add_child(new_player);
	new_player.add_to_group("session_main_char")
	


func _on_button_2_button_down():
	var the_tree = get_tree();
	the_tree.change_scene_to_file("res://levels/main.tscn")
