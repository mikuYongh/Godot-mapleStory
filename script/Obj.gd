extends Node2D
var thread;
var wzTool:MapleResource;

# Called when the node enters the scene tree for the first time.

	

# Called every frame. 'delta' is the elapsed time since the previous frame.
	

	
func _StartLoad(map,wzNode,Map_Id):
	wzTool=map.get_node("/root").get_node("main/WzTool")
	var HttpTool=map.get_node("/root").get_node("main/HTTPMain");
	for i in range(0,8):
		var layerViewer=map.get_node("layer_"+str(i));
		var nodev:Node2D=Node2D.new();
		nodev.name="obj";
		layerViewer.add_child(nodev,false);
		var nodeViewer=layerViewer.get_node("obj");
		var node:Dictionary =wzNode[str(i)];
		var objArr=node["obj"];
		var len=objArr["_keys"].size();
		for nodei in range(0,len):
			var na:Dictionary = objArr[str(nodei)];
			var oS = na["oS"]
			var l0 = na["l0"]
			var l1 = na["l1"]
			var l2 = na["l2"]
			var x = na["x"]
			var y = na["y"]
			var z = na.get("z",0)
			var f = na["f"]
			var zM = na["zM"]
			var cx=na.get("cx",0);
			
			var cy=na.get("cy",0);
			var rx=na.get("rx",0);
			var ry=na.get("ry",0)
			
			var flow=na.get("flow",0)
			#拼接路径
			#var result:Dictionary=Game._getWZ("Map/Obj/"+str(oS)+".img")
			var result=wzTool.get_by_path("Map/Obj/"+str(oS)+".img").data;
			
			if result==null||!result.has(l0)||!result[l0].has(l1)||!result[l0][l1].has(l2): 
				continue;
			var spriteNode:Dictionary = result[l0][l1][l2];
			var spLen=spriteNode["_keys"].size();
			var animKey="Obj/"+str(oS)+".img/"+l0+"/"+l1+"/"+l2;
			var as2D=AnimatedSprite2D.new();
			var sF=SpriteFrames.new();
			sF.add_animation(animKey);
			as2D.sprite_frames=sF;
			var origin=Vector2(0,0);#这里可能还得改
			var width;
			var height;
			var zz;
			
			var frameInfo={};
			for b in range(0,spLen):
				if !spriteNode.has(str(b)):continue;
				
				var dd=spriteNode[str(b)];
				#if dd["type"]=="uol":
					#uol处理
				#	continue;
				var img=Game.Wz_getImage(dd,spriteNode);
				if img:
					as2D.sprite_frames.add_frame(animKey,img["img"],1+img["delay"]/1000/2,b)
					as2D.speed_scale=1.5
					if b==0:
						origin=img["origin"]
						width=img["width"]
						height=img["height"]
						zz=dd.get("z",0);
					frameInfo[b]={"x":img["origin"].x-origin.x,"y":img["origin"].y-origin.y};
					var a0=int(img["a0"])
					var a1=int(img["a1"])
					if a0!=-1&&a1!=-1&&a0!=255:
						var tween=map.get_tree().create_tween().bind_node(as2D)
						tween.tween_property(as2D, "modulate", Color(1,1,1,0), img["delay"]/1000/2).from(Color(1,1,1,1))
						tween.chain().tween_property(as2D, "modulate", Color(1,1,1,1), img["delay"]/1000/2).from(Color(1,1,1,0))
					
						tween.set_loops();
						tween.play()
						pass;	
						#origin=img["origin"]
						#var tt=Sprite2D.new()
						#tt.texture=img["img"];
						#tt.position.x=x-origin.x+400+img["width"]/2
						#tt.position.y=y-origin.y+300+img["height"]/2
						#tt.z_index=i
						#add_child(tt,true);
					#var tt=Sprite2D.new()
					#tt.texture=img["img"];
			as2D.connect("frame_changed",Callable(self,"_frame_changed").bind(as2D,frameInfo))
			as2D.position.x=x-origin.x+map.get_viewport().get_visible_rect().size.x/2
			as2D.position.y=y-origin.y+map.get_viewport().get_visible_rect().size.y/2
			if (f==1):
				as2D.flip_h=true;
			#if spLen>1&&origin.x!=0&&origin.y!=0:
				#as2D.position.y-=height/2;
			#as2D.offset.x=origin.x/2;
			as2D.add_to_group("load")
			as2D.name=oS+"_"+l0+"_"+l1+"_"+l2;
			as2D.centered=false;
			as2D.set_meta("node",spriteNode)
			as2D.set_meta("parent_node",na)
			as2D.set_meta("f",f);
			as2D.set_visibility_layer_bit(i,true)
			if flow==0:
				as2D.z_index=1000+z;
			else:
				as2D.z_index=100+z;
			nodeViewer.add_child(as2D,false);
			as2D.play(animKey)
			

			
			
func _frame_changed(as2D:AnimatedSprite2D,frameInfo):
	if !frameInfo.has(as2D.frame):return;
	as2D.offset.x=-frameInfo[as2D.frame].x
	as2D.offset.y=-frameInfo[as2D.frame].y;
	pass;

func load(map,wzNode, Map_Id):
		#thread=Thread.new();
		#var callback=Callable(self,"_StartLoad");
		#callback.call_deferred(map,wzNode,Map_Id);
		_StartLoad(map,wzNode,Map_Id)
		#thread.start(callback,1)
		
func _exit_tree():
	if thread :
		thread.wait_to_finish()
