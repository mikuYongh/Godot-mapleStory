extends Node
class_name CursorCTRL
var data;
var normalCurSor;
var as2D:AnimatedSprite2D;
var icon:Sprite2D;
var sF:SpriteFrames;
var getData={};#拿的道具数据
var canPut=false;
@onready var wzTool:MapleWz=self.get_node("/root/MapleWz")
# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	sF=SpriteFrames.new();
	as2D=AnimatedSprite2D.new();
	as2D.z_index=4000
	icon=Sprite2D.new();
	icon.modulate=Color(1,1,1,0.7)
	var n=wzTool.get_by_path("UI/Basic.img/Cursor");
	if n==null:return;
	data=n.data;
	_loadCuror(0,normalCurSor,"normal");
	_loadCuror(5,normalCurSor,"catch");
	_loadCuror(11,normalCurSor,"get");
	_loadCuror(12,normalCurSor,"pressed");
	_loadCuror(13,normalCurSor,"hover");
	
	add_child(as2D)
	as2D.add_child(icon)
	_play("normal");
	
	pass # Replace with function body.

func _input(event):
	if event is InputEventMouseMotion:	
		if as2D:
			as2D.position=event.position;
	if event is InputEventMouseButton:
		if as2D:
			if event.is_pressed():
				if !canPut:
					getData={}
				_play("pressed")
			else:
				_play("normal")
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if getData.size()>0&&as2D:
		if as2D.animation!="cursor_get":
			var m=getData.get("img");
			icon.texture=m;
			_play("get");
	else:
		icon.texture=null;
			
	pass

func _loadCuror(index,cursor,name):
	var cursorData=data.get(str(index),null);
	if cursorData==null:return;
	sF.add_animation("cursor_"+name);
	as2D.sprite_frames=sF;
	var keys:Array=cursorData.get("_keys",[]);
	if keys.is_empty():return;
	for i in range(0,keys.size()):
		var no=cursorData.get(str(i),null)
		if no==null:return;
		var img=Game.Wz_getImage(no,cursorData);
		if img:
			as2D.offset=Vector2(img["width"]/2,img["height"]/2)
			as2D.sprite_frames.add_frame("cursor_"+name,img["img"],1+img["delay"]/1000,i);
			as2D.speed_scale=1.5
		pass
	
	pass;
func _play(key):
	if as2D:
		as2D.play("cursor_"+key);
	pass;

func setGetData(data:Dictionary):
	getData=data;
