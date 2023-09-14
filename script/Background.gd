extends Node2D
signal Start_LoadBackground();
var thread;
var Wz
var backgrounds=[];
var camera:Camera2D;
var staticBackground;
var scrollBackground:ParallaxBackground;
var viewPort:SubViewport;
var viewPortWidth;
var viewPortHeight;
var wzTool:MapleResource;
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	thread=Thread.new();
	camera=get_node("/root").get_node("main/SubViewportContainer/SubViewport/Camera2D");
	staticBackground=self;
	#scrollBackground=$ScrollBackground;
	viewPort=get_node("/root").get_node("main/SubViewportContainer/SubViewport");
	if viewPort:
		viewPortWidth=viewPort.size.x;
		viewPortHeight=viewPort.size.y;
	else:
		viewPortWidth=800;
		viewPortHeight=600;
	wzTool=get_node("/root").get_node("main/WzTool")
func _StartLoad(wzNode,Map_Id):
	print("开始加载 背景 ",Map_Id)
	var backNum=0
	var HttpTool=get_node("/root").get_node("main/HTTPMain");
	var backArray=wzNode["back"];
	var keys=wzNode["back"]["_keys"];
	var depth=0
	for a in keys:
		if a!="name":
			depth=depth+1;
			var node=backArray[a]
			var bS=node["bS"];
			var front=node["front"];
			var no=node["no"];
			var ani=node["ani"];
			var x=node["x"];
			var y=node["y"];
			var rx=node["rx"]
			var ry=node["ry"]
			var type=node["type"]
			var cx=0;
			var cy=0;
			if node.has("cx"):
				cx=node["cx"]
			if node.has("cy"):
				cy=node["cy"]
			var alpha=node["a"]
			var f=0;
			if node.has("f"):
				f=node["f"];
			var info={"node":node,"bS":bS,"front":front,"ani":ani,"no":no,"x":x,"y":y,"rx":rx,"ry":ry,"type":type,"cx":cx,"cy":cy,"a":alpha,"f":f,"name":a}
			#var result=await Game._getWZ("Map/Back/"+str(bS)+".img")
			if str(bS).length()==0:continue;
			var data=wzTool.get_by_path("Map/Back/"+str(bS)+".img")
			
			if !data:continue;
			var result=data.data;
			if result:
				var r=null;
				if ani==1:
					if !result["ani"].has(str(no)):continue;
					r=result["ani"][str(no)];
					var len=r["_keys"];
					var as2D=AnimatedSprite2D.new();
					var sF=SpriteFrames.new();
					var animKey="Map/Back/"+str(bS)+".img/ani/"+str(no);
					sF.add_animation(animKey);
					as2D.sprite_frames=sF;
					var moveType=null;
					var moveH=null;
					var moveP=null;
					for i in len:
						var da=r[i];
						if int(i)==0:
							moveType=da.get("moveType",0);
							moveH=da.get("moveH",0);
							moveP=da.get("moveP",0);
						var img=Game.Wz_getImage(da,r);
						var origin;
						var width;
						var height;
						if img:
							as2D.sprite_frames.add_frame(animKey,img["img"],1+img["delay"]/1000/2)
							origin=img["origin"]
							width=img["width"]
							height=img["height"]
						as2D.position.x=x+400-width/2
						as2D.position.y=y+300-height/2
						as2D.add_to_group("load")
						#as2D.name="ani";
						as2D.centered=false;
						#as2D.set_meta("node",spriteNode)
						as2D.z_index=int(i);
						#$StaticBackground/ANIM.add_child(as2D,false);
						as2D.play(animKey)
						pass;
				else:	
					
					if !result["back"].has(str(no)):continue;
					r=result["back"][str(no)];
					var origin={"x":r["origin"]["X"],"y":r["origin"]["Y"]}
					var img=Game.Wz_getImage(r,result["back"]);
					if img:
						
						var back=Back3.new();
						print("加载背景","Map/Back/"+str(bS)+".img")
						var pback=ParallaxBackground.new()
						pback.scroll_ignore_camera_zoom=true
						add_child(pback)
						#back.add_back(pback,r,info,img,info.name)
						back.add_back(self,r,info,img)
				
			
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

	
	
func _process(delta):
	
	pass;
	#var HMOVES=$StaticBackground/HMOVE.get_children(true)
	#for i in HMOVES:
	#	var Hspeed=i.get_meta("HSpeed");
	#	$StaticBackground/HMOVE.motion_offset=Vector2(i.get_meta("HMove"),viewPortWidth/2)
	#	i.set_meta("HMove",i.get_meta("HMove")+Hspeed/16)
	#pass;
	#if camera:
	#	var x=camera.get_screen_center_position().x;
	#	var y=camera.get_screen_center_position().y;
		
		#$StaticBackground/TILED.position=Vector2(x,y)
		#$StaticBackground/NORMAL.position.x=-x;
			#if VSpeed!=0:
			#	node.position.y+=VSpeed;
			#if HSpeed!=0:
			#	node.position.x+=HSpeed;			

func _exit_tree():
	if thread:
		thread.wait_to_finish();


func _on_map_load_background(wzNode, Map_Id):
	if thread:
	#thread.start(_StartLoad(Map_Id),1)
		#var callback=Callable(self,"_StartLoad");
		#callback.call(wzNode,Map_Id)
		#thread.start(callback,1)
		_StartLoad(wzNode,Map_Id)
