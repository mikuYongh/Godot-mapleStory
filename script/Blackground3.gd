extends Node2D
#因为高级控件并不能很好的应用场景 所以重写Background 抛弃godot4的高级控件以算法来实现背景
#参照法老王冒险岛 及MapleStoryGM等
var wzTool:MapleResource;
func _init():
	
	pass # Replace with function body.

func _StartLoad(map:Map,wzNode,Map_Id):
	print("开始加载 背景 ",Map_Id)
	wzTool=map.get_node("/root").get_node("main/WzTool")
	var prentNode;
	if map.has_node("background"):
		prentNode=map.get_node("background")
	else:
		prentNode=Node2D.new();
		prentNode.name="background"
		map.add_child(prentNode)
	var HttpTool=map.get_node("/root").get_node("main/HTTPMain");
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
			var info={"node":node,"bS":bS,"front":front,"ani":ani,"no":no,"x":x,"y":y,"rx":rx,"ry":ry,"type":type,"cx":cx,"cy":cy,"a":alpha,"f":f}
			#var result=await Game._getWZ("Map/Back/"+str(bS)+".img")
			if str(bS).length()==0:continue;
			var data=wzTool.get_by_path("Map/Back/"+str(bS)+".img")
			if !data:continue;
			var result=data.data;
			if result:
				#创建layer
				var layerNode;
				if prentNode.has_node("Blayer_"+str(no)):
					layerNode=prentNode.get_node("Blayer_"+str(no));
				else:
					layerNode=CanvasLayer.new()
					layerNode.name="Blayer_"+str(no)
					layerNode.add_to_group("load");
					#layerNode.follow_viewport_enabled=true
					layerNode.layer=no-7;
					prentNode.add_child(layerNode)
				pass;
				if !result["back"].has(str(no)):continue;
				var r=result["back"][str(no)];
				var img=Game.Wz_getImage(r,result["back"]);
				if img:
					var brg=BrgNode.new();
					brg.add_back(layerNode,r,info,img);
					pass
			
			
func load(map,wzNode, Map_Id):
		_StartLoad(map,wzNode,Map_Id)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
