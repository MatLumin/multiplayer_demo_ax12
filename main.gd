extends Node3D

var SHARED_CONST = load("res://script/SHARED_CONST.gd");
var main_char_username = "";
var main_char_pointer = null;
var PLAYERS = {};

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var main_char_candidates = get_tree().get_nodes_in_group("session_main_char");
	if len(main_char_candidates) == 0:
		pass
	else: 
		main_char_pointer = main_char_candidates[0];
		main_char_username = main_char_pointer.username;
		PLAYERS[main_char_username] = (main_char_pointer);

func _on_other_players_data_update_timer_timeout():
	$other_players_data_getter.request(SHARED_CONST.SERVER_HOST+"/get_players_data");
	$other_players_data_update_timer.start();
	
	
func create_a_new_player(username):
	var target = load("res://classes/player.tscn").instantiate();
	add_child(target);
	PLAYERS[username] = target;
	

func _on_other_players_data_getter_request_completed(result, response_code, headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8());
	
	for player_data in json:
		var x = float(player_data["x"]);
		var z = float(player_data["z"]);
		var head_rot_y = float(player_data["head_rot_y"]);
		var head_rot_x = float(player_data["head_rot_x"]);
		var username = player_data["username"];
		
		var velocity_x = float(player_data["velocity_x"]);
		var velocity_z = float(player_data["velocity_z"]);
		if username == main_char_username:
			continue;
		if username not in PLAYERS:
			create_a_new_player(username)
		var target = PLAYERS[username];
		target.update_self_data(x, z, head_rot_x, head_rot_y, velocity_x, velocity_z);
		
