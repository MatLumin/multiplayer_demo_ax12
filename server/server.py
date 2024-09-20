from __future__ import annotations
from flask import *;
from flask_sock import Sock;
from typing import *;


app:Flask = Flask("meow");
sock:Sock = Sock(app);

PLAYERS:Dict[str, Player] = dict();

PLAYER_AFK_TIMEOUT = 10;

class Player:
	def __init__(self, username):
		self.username = username;
		self.x = 0;
		self.z = 0;
		self.velocity_x = 0;
		self.velocity_z = 0;
		self.head_rot_x = 0;
		self.head_rot_y = 0;
		PLAYERS[username]=(self);


	def __str__(self)->str:
		return f"<Player {self.username} {self.x} {self.z} | {self.head_rot_x} {self.head_rot_y} | {self.velocity_x} {self.velocity_z}>";


	def __repr__(self)->str:
		return str(self);

	def to_dict(self)->Dict[str, Any]:
		return {
		"x":self.x,
		"z":self.z,
		"head_rot_x":self.head_rot_x,
		"head_rot_y":self.head_rot_y,
		"username":self.username,
		"velocity_x":self.velocity_x,
		"velocity_z":self.velocity_z
		};



def read_file_content(path:str)->str:
	with open(path, "r") as f1:
		return f1.read();


def generate_players_report()->str:
	output:str = "";
	for i1 in PLAYERS:
		output += PLAYERS[i1].__str__()+"\n";
	return output;



@app.route("/index")
def hh__index():
	return read_file_content(path="testing_client.html");


@app.route("/admin")
def hh__admin():
	return read_file_content("admin.html");

@app.route("/get_players_report_string")
def hh_get_players_report_string()->str:
	players_report:str = generate_players_report();
	return players_report;


@app.route("/create_player")
def hh_create_player():
	given_username:str = request.args.get("username");
	new_instance:Player = Player(username=given_username);
	print(PLAYERS);
	return "done";



@app.route("/set_player_pos")
def sh__set_player_pos():
	given_username:str = request.args.get("username");

	x:float = request.args.get("x");
	z:float = request.args.get("z");

	head_rot_y:float = request.args.get("head_rot_y");
	head_rot_x:float = request.args.get("head_rot_x");

	velocity_z:float = request.args.get("velocity_z", 0); 
	velocity_x:float = request.args.get("velocity_x", 0);

	target = PLAYERS[given_username]
	target.x = x; 
	target.z = z;
	target.head_rot_y = head_rot_y;
	target.head_rot_x = head_rot_x;
	target.velocity_x = velocity_x;
	target.velocity_z = velocity_z;

	return "ok";




@app.route("/get_players_data")
def sh__get_players_data():
	output = list();
	for i1 in PLAYERS:
		output.append(PLAYERS[i1].to_dict());
	return output;


