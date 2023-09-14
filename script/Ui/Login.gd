extends UI
# Called when the node enters the scene tree for the first time.
var map:Map;
var background;
var tween_background;
var login_button:Button;
var camera:Camera2D;
func _init():
	var audio = AudioStreamPlayer.new()
	audio.name="AudioBGM"
	audio.set_script(load("res://script/Bgm.gd"));
	add_child(audio)
	#WzHttp=Game.HttpScene.instantiate();
	var audioEF = AudioStreamPlayer.new()
	audioEF.name="AudioEffect"
	audioEF.set_script(load("res://script/Bgm.gd"));
	add_child(audioEF)
	
	var cursor=CursorCTRL.new();
	cursor.name="cursor"
	add_child(cursor)
	
func _ready():


	setWzTool($WzTool)
	addImage("Login.img/Common/frame",0,0)
	login_button=addButton("Login.img/Title/BtLogin",620,220);
	addEditText(470,225,147,25,12,"账号")
	addEditText(470,255,147,25,12,"密码")
	map=$map;
	camera=$map/Camera2D
	background=$map/background/StaticBackground/NORMAL;
	map.loadMap("Login.img")
	tween_background=background.create_tween();
	#tween_background.bind_node(map)
	login_button.button_down.connect(login)
	
	pass # Replace with function body.

func login():
	print("登录")
	#var t=background.create_tween();
	#t.tween_property(background, "position", Vector2(400,900),1)
	#t.tween_property(background, "position", Vector2(400,1400),1)
	#t.play()
	#camera.position.y=-700;
	
	camera.position.y=-1200;
	#camera.position.y=-1700;
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
