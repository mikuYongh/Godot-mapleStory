extends Node2D
class_name Map
signal loadBackground(wznode,Map_Id)
signal loadTile(wznode,Map_Id)
signal loadObj(wznode,Map_Id)
signal loadNpc(wznode,Map_Id)
signal loadPortal(wznode,Map_Id)
var wzNode=null;
var info;
var world;
var footholds={};
var ropes={};
var viewPortWidth;
var viewPortHeight;
var portal=null;
var thread:Thread;
var npcGD;
var playerList=[];
var mapId;
var loading=false;
@onready var subViewPort:SubViewport=self.find_parent("SubViewport")
@onready var cameraMain:Camera2D=self.get_viewport().get_camera_2d();
@onready var mainPlayer:Charactor=self.get_viewport().get_camera_2d().get_parent();
@onready var bgmNode:BgmManager=self.get_node("/root/AduioBGM")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.

func _init():
	thread=Thread.new();
	pass;
	
func _ready():
	playerList.append(mainPlayer)
	if subViewPort==null:
		viewPortWidth=800;
		viewPortHeight=600;
	else:
		viewPortWidth=subViewPort.get_size().x;
		viewPortHeight=subViewPort.get_size().y
	world={"width":viewPortWidth,"height":viewPortHeight}
	#subViewPort.get_viewport().get_camera_2d()
	#cameraMain=get_node("/root").get_node("main/Camera2D");
		
	
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func loadrope(wznode:Dictionary):
	var ropes={};
	if !wznode.has("ladderRope"):return;
	for index in wznode["ladderRope"]:
		if index=="name"||index=="_keys":continue;
		var Nrope=wznode["ladderRope"][index];
		ropes[index]=Nrope;
	return ropes;
	pass;
func loadfoothold(wznode:Dictionary):
	var footholds={}
	if !wznode.has("foothold"):return;
	for layern in wznode["foothold"]:
		if layern=="name"||layern=="_keys":continue;
		var Nlayer=wznode["foothold"][layern];
		for groupn in Nlayer:
			if groupn=="name"||groupn=="_keys":continue;
			var Ngroup=Nlayer[groupn]
			for fhnode in Ngroup:
				if fhnode=="name"||fhnode=="_keys":continue;
				var node=Ngroup[fhnode];
				var id=int(node["name"]);
				var group=int(groupn);
				var layer=int(layern);
				var x1=node["x1"];
				var y1=node["y1"]
				var x2=node["x2"]
				var y2=node["y2"]
				var prev=node["prev"]
				var next=node["next"]
				var line=[[x1,y1],[x2,y2]]
				footholds[id]={"id":id,"group":group,"layer":layer,"x1":x1,"y1":y1,"x2":x2,"y2":y2,"prev":prev,"next":next,"line":line}
	return footholds;			
				
	
func _draw():
	#if wzNode:
	#	footholds=loadfoothold(wzNode);
	#	var keys=footholds.keys();
	#	for key in keys:
	#		var foothold=footholds[key];
	#		draw_line(Vector2(foothold.line[0][0]+viewPortWidth/2,foothold.line[0][1]+viewPortHeight/2),Vector2(foothold.line[1][0]+viewPortWidth/2,foothold.line[1][1]+viewPortHeight/2),Color.BLUE,2)
	pass;
func tomap(Map_id,name="sp"):
	if loading==true:return;
	var mm=preload("res://scene/MapLoad.tscn")
	var mi=mm.instantiate();
	get_node("/root").add_child(mi)
	loading=true;
	await mi.Anifinish
	if mainPlayer:
		mainPlayer.state=Charactor.STATE.STAND
		var arr:Array=self.get_tree().get_nodes_in_group("load")
		for i in arr:
			self.get_tree().queue_delete(i)
		loadMap(str(Map_id),name);
	await mi.finish
	loading=false;

func loadMap(Map_Id:String,sp="sp"):
	#需要做一次彻底的节点清空
	await remove_from_group("load")
	if Map_Id=="Login.img":
		wzNode= Game._getWZ("UI/MapLogin.img")
	else:
		var mi:int=int(Map_Id);
		var m=mi/100000000;
		if Map_Id.length()<9:
			for i in range(0,9-Map_Id.length()):
				Map_Id="0"+Map_Id;
			
		wzNode= Game._getWZ("Map/Map/Map"+str(m)+"/"+Map_Id+".img")
	self.mapId=Map_Id;
	if wzNode&&world:
		#取info
		info=wzNode["info"];
		#VR有可能取不到则
		footholds=loadfoothold(wzNode);
		var bgm=info.get("bgm",null);
		bgmNode.playByMapBGM(bgm)
		var minX=0;
		var maxX=0;
		var maxY=0;
		var minY=0;
		var mostLeft=INF;
		var mostRight=-INF;
		var mostTop=INF;
		var mostBottom=-INF;
		if footholds==null:return;
		var keys=footholds.keys();
		for key in keys:
			var foothold=footholds[key];
			if foothold.x1>mostRight:
				mostRight=foothold.x1
			if foothold.x1<mostLeft:
				mostLeft=foothold.x1
			if foothold.x2>mostRight:
				mostRight=foothold.x2
			if foothold.x2<mostLeft:
				mostLeft=foothold.x2
			if foothold.y1>mostBottom:
				mostBottom=foothold.y1
			if foothold.y1<mostTop:
				mostTop=foothold.y1
			if foothold.y2>mostBottom:
				mostBottom=foothold.y2
			if foothold.y2<mostTop:
				mostTop=foothold.y2
		if !info.has("VRLeft"):
			info["VRRight"]=mostRight+10;
			info["VRLeft"]=mostLeft-10
			info["VRTop"]=min(mostBottom-600,mostTop-360);
			info["VRBottom"]=mostBottom+110;
			pass
		if mostRight==INF||mostLeft==-INF||mostTop==INF||mostBottom==-INF:
			return;
	
		info["width"]=info["VRRight"]-info["VRLeft"];
		info["height"]=info["VRBottom"]-info["VRTop"];
		world["width"]=info["width"];
		world["height"]=info["height"]
		#绘制八层
		var bef=get_node("before");
		
		if bef:
			bef.name="free"
			bef.free();
		for i in range(0,8):
			var n=get_node("layer_"+str(i));
			if n:n.free();
			var canvasLayer=CanvasLayer.new();
			canvasLayer.name="layer_"+str(i);
			canvasLayer.layer=i;
			canvasLayer.add_to_group("load")
			canvasLayer.follow_viewport_enabled=true
			add_child(canvasLayer,true)
			pass;
		#绘制其它层
		
		var beforeLayer=CanvasLayer.new();
		beforeLayer.layer=8;
		beforeLayer.add_to_group("load")
		beforeLayer.follow_viewport_enabled=true;
		beforeLayer.name="before"
		add_child(beforeLayer)
		#var callback=Callable(self,"_StartLoad");
		
		var callback=Callable(self,"loadscript");
		callback.call_deferred(wzNode,Map_Id,sp);
		thread.start(callback,1)
		if cameraMain:
			if !info.has("VRLeft"):
				#cameraMain.position.x=info["VRLeft"]+world["width"]/2
				#cameraMain.position.y=info["VRBottom"]-world["height"]/2
				cameraMain.position.x=info["VRLeft"]+10
				cameraMain.position.y=info["VRBottom"]-10
				cameraMain.limit_left=info["VRLeft"]+world["width"]/2;
				cameraMain.limit_right=info["VRRight"]+world["width"]/2;
				cameraMain.limit_top=info["VRTop"]+world["height"]/2;
				cameraMain.limit_bottom=info["VRBottom"]+world["height"]/2;;
			else:
				cameraMain.position.x=info["VRLeft"]
				cameraMain.position.y=info["VRBottom"]
				#.x=info["VRLeft"]+400
				#cameraMain.position.y=info["VRBottom"]+300
				cameraMain.limit_left=info["VRLeft"]+viewPortWidth/2;
				cameraMain.limit_right=info["VRRight"]+viewPortWidth/2;
				cameraMain.limit_top=info["VRTop"]+viewPortHeight/2;
				cameraMain.limit_bottom=info["VRBottom"]+viewPortHeight/2;
		#设置地图边界 4/15
		cameraMain.reset_smoothing();
		var area=StaticBody2D.new();
		area.collision_layer=12;
		area.add_to_group("load");
		area.set_collision_layer_value(12,true)
		area.position=Vector2(400,300);
		var collision_left=CollisionShape2D.new();
		collision_left.debug_color=Color(0,0,0,0)
		var shape2D_left=SegmentShape2D.new();
		shape2D_left.a=Vector2(info["VRLeft"]+5,info["VRTop"])
		shape2D_left.b=Vector2(info["VRLeft"]+5,info["VRBottom"])
		collision_left.shape=shape2D_left;
		
		var collision_right=CollisionShape2D.new();
		collision_right.debug_color=Color(0,0,0,0)
		var shape2D_right=SegmentShape2D.new();
		shape2D_right.a=Vector2(info["VRRight"]-5,info["VRTop"])
		shape2D_right.b=Vector2(info["VRRight"]-5,info["VRBottom"])
		collision_right.shape=shape2D_right;
		area.add_child(collision_left)
		area.add_child(collision_right)
		add_child(area)
		
		if cameraMain:
			print("相机边界线","L:",cameraMain.limit_left,"T:",cameraMain.limit_top)
			print("地图宽高","W:",world["width"],"H:",world["height"])
				#实例化minimap
		if Map_Id!="Login.img":
			var mini=preload("res://scene/UI/MiniMap.tscn")
			var i=mini.instantiate();
			i.add_to_group("load")
			i.mapId=Map_Id;
			i.map=self;
			get_node("/root/main/UIWindows").add_child(i)
	
func loadscript(wzNode,Map_Id,sp):
	footholds=loadfoothold(wzNode)
	ropes=loadrope(wzNode)
	var obj = load("res://script/Obj.gd")
	obj.new().load(self,wzNode,Map_Id)
	var tile = load("res://script/Tile.gd")
	tile.new().load(self,wzNode,Map_Id)
	#emit_signal("loadBackground",wzNode,Map_Id)
	portal=load("res://script/Portal.gd").new()
	portal.load(self,wzNode,Map_Id);
	
	npcGD=load("res://script/Npc.gd")
	npcGD.new().load(self,wzNode,Map_Id);
	#FootHold
	var foothold=load("res://script/FootHold.gd")
	foothold.new().load(self,footholds)
	
	var rope=load("res://script/Rope.gd")
	rope.new().load(self,ropes)
	
	
	var v=portal.getPlayerPn(sp)
	if v:
		mainPlayer.setPos(v)
	else:
		v=portal.getPlayerSP(sp)
		if v:
			mainPlayer.setPos(v)
	
	var background=load("res://script/Blackground3.gd")
	background.new().load(self,wzNode,Map_Id)		

func _on_main_Start_LoadMap(MapId):
	loadMap(MapId)

func getInfo():
	return info;

func _process(delta):
	queue_redraw();
	

func _exit_tree():
	self.queue_free();

func _on_sub_viewport_container_gui_input(event):
	pass;
			



