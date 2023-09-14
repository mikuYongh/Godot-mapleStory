extends Node
var thread;
var wzTool:MapleResource;
var map:Map;
var portals={};
# Called when the node enters the scene tree for the first time.
func getPlayerSP():
	#寻找出生点
	var viewPortSize=self.map.get_viewport_rect().size;
	var camera=self.map.get_viewport().get_camera_2d();
	for i in portals:
		if i=="name" or i=="_keys":continue;
		var portal=portals[i];
		var name=portal.get("pn","");
		if name=="sp":
			return Vector2(portal.get("x",0)+viewPortSize.x/2,portal.get("y",0)+viewPortSize.y/2)
	return null;

func getPlayerPn(pn):
	#寻找pn
	var viewPortSize=self.map.get_viewport_rect().size;
	var camera=self.map.get_viewport().get_camera_2d();
	for i in portals:
		if i=="name" or i=="_keys":continue;
		var portal=portals[i];
		var name=portal.get("pn","");
		if name==pn&&name!="":
			return Vector2(portal.get("x",0)+viewPortSize.x/2,portal.get("y",0)+viewPortSize.y/2)
	return null;

func _StartLoad(map,wzNode,Map_Id):
	if !wzNode.has("portal"):return;
	self.map=map;
	var before=map.get_node("before");
	var portalNode=Node2D.new();
	portalNode.name="portal";
	before.add_child(portalNode)
	portals=wzNode["portal"];
	var spLen=portals["_keys"].size();
	#var animKey="Obj/"+str(oS)+".img/"+l0+"/"+l1+"/"+l2;
	for i in range(0,spLen):
		var node:Dictionary=portals[str(i)];
		var image=node.get("image","default")
		var name=node["pn"];
		var type=node["pt"];
		var x=node["x"];
		var y=node["y"];
		var spriteNode=null;
		var tomap=null;
		var nn;
		if node.has("tm"):
			tomap=node["tm"]
		var toname=null;
		if node.has("tn"):
			toname=node["tn"]
		var info={"name":name,"type":type,"tomap":tomap,"toname":toname,"self":self}
		var staticBody=StaticBody2D.new();
		staticBody.position=Vector2(400,300)
		staticBody.set_collision_layer_value(15,true)
		#staticBody.set_collision_mask_value(15,true)
		staticBody.set_meta("info",info)
		var collision=CollisionShape2D.new();
		if (type==0):
			
			pass;
		if (type==1):
			
			var shape2D=SegmentShape2D.new();
			shape2D.a=Vector2(x-20,y)
			shape2D.b=Vector2(x+20,y)
			collision.debug_color=Color.RED
			collision.shape=shape2D;
			
			
			pass;
		if (type==2):
			nn="Map/MapHelper.img/portal/game/"+"pv";
			var result=wzTool.get_by_path(nn);
			if !result:
				continue;
			spriteNode=result.data;
			var shape2D=SegmentShape2D.new();
			shape2D.a=Vector2(x-30,y)
			shape2D.b=Vector2(x+30,y)
			collision.debug_color=Color.RED
			collision.shape=shape2D;
		
			pass;
		if (type==3):
			var shape2D=SegmentShape2D.new();
			shape2D.a=Vector2(x-50,y-50)
			shape2D.b=Vector2(x+50,y-50)
			collision.debug_color=Color.RED
			collision.shape=shape2D;
			pass;
		if (type==4):
			nn="Map/MapHelper.img/portal/game/"+"pv";
			var result=wzTool.get_by_path(nn);
			if !result:
				continue;
			spriteNode=result.data;
			var shape2D=SegmentShape2D.new();
			shape2D.a=Vector2(x-30,y)
			shape2D.b=Vector2(x+30,y)
			collision.debug_color=Color.RED
			collision.shape=shape2D;
			pass;
		if (type==5):
		
			pass;
		if (type==6):
			
			pass;
		if (type==7):
			nn="Map/MapHelper.img/portal/game/"+"pv";
			var result=wzTool.get_by_path(nn);
			if !result:
				continue;
			spriteNode=result.data;
			pass;
		pass;
		if (type==8):
			pass;
		if (type==9):
			pass;
		if (type==10):
			nn="Map/MapHelper.img/portal/game/"+"ph/default/portalContinue";
			var result=wzTool.get_by_path(nn);
			if !result:
				continue;
			spriteNode=result.data;
			pass;
		if (type==11):
			nn="Map/MapHelper.img/portal/game/"+"psh/"+image+"/portalContinue";
			var result=wzTool.get_by_path(nn);
			if !result:
				continue;
			spriteNode=result.data;
			pass;
		if spriteNode:
			var animKey=nn;
			var as2D=MyAnimatedSprite2D.new();
			var sF=SpriteFrames.new();
			sF.add_animation(nn);
			as2D.sprite_frames=sF;
			var origin;#这里可能还得改
			var width;
			var height;
			var frameInfo={};
			var AnimLen=spriteNode["_keys"].size();
			for k in range(0,AnimLen):
				if !spriteNode.has(str(k)):continue;
				var animNode=spriteNode[str(k)];
				var img=Game.Wz_getImage(animNode,spriteNode);
				if img:
					as2D.sprite_frames.add_frame(animKey,img["img"],1+img["delay"]/1000/2,k)
					if k==0:
						origin=img["origin"]
						width=img["width"]
						height=img["height"]
					frameInfo[k]={"x":img["origin"].x-origin.x,"y":img["origin"].y-origin.y};
				pass;
				as2D.connect("frame_changed",Callable(self,"_frame_changed").bind(as2D,frameInfo))
			as2D.position.x=x+400-width/2
			as2D.position.y=y+300-height/2-origin.y/2+5
			as2D.add_to_group("load")
			#as2D.name=oS+"_"+l0+"_"+l1+"_"+l2;
			as2D.centered=false;
			as2D.set_meta("node",spriteNode)
			as2D.visibility_layer=i;
			as2D.z_index=2000
			#as2D.set_process_input(true)
			as2D.setAnimKey(animKey)
			#as2D.connect("clicked",Callable(self,"_click").bind(info))
			
			portalNode.add_child(as2D);
			as2D.play(animKey)
			#as2D.add_child(input_event)
		staticBody.add_child(collision)
		portalNode.add_child(staticBody)	
	# 绑定信号函数到InputEvent节点上
			#input_event.connect("button_pressed",Callable(self, "_click"))
	
func _click(info):
	if info.tomap==999999999:return;
	self.map.get_node("/root").get_node("main/SubViewportContainer/SubViewport/map");
	
	var arr:Array=self.map.get_tree().get_nodes_in_group("load")
	for i in arr:
		self.map.get_tree().queue_delete(i)
	#var tween=map.get_tree().create_tween();
	#tween.tween_property(get_tree(), "modulate", Color(255,255,255,0),3).from(Color(1,1,1,1))
	#tween.play();
	#tween.tween_callback(map.loadMap.bind(str(info.tomap))).set_delay(1)
	
	#tween.chain().tween_property(as2D, "modulate", Color(1,1,1,1), img["delay"]/1000/2).from(Color(1,1,1,0)
	map.loadMap(str(info.tomap),info.toname);
	pass;		
func _frame_changed(as2D:AnimatedSprite2D,frameInfo):
	as2D.offset.x=-frameInfo[as2D.frame].x;
	as2D.offset.y=-frameInfo[as2D.frame].y;
	pass;

func _exit_tree():
	if thread:
		thread.wait_to_finish()

func load(map,wznode, Map_Id):
	#thread=Thread.new();
	wzTool=map.get_node("/root").get_node("main/WzTool")
	#var callback=Callable(self,"_StartLoad");
	#callback.call_deferred(map,wznode,Map_Id);
	_StartLoad(map,wznode,Map_Id)
	pass # Replace with function body.
