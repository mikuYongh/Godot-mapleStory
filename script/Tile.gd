extends Node2D
var thread;
var wzTool;
# Called when the node enters the scene tree for the first time.


func _StartLoad(map,wzNode,Map_Id):
	var HttpTool=map.get_node("/root").get_node("main/HTTPMain");
	for i in range(0,8):
		var layerViewer=map.get_node("layer_"+str(i+1));
		if !layerViewer:return;
		var nodev:Node2D=Node2D.new();
		nodev.name="tile";
		layerViewer.add_child(nodev,false);
		var nodeViewer=layerViewer.get_node("tile");
		var node:Dictionary =wzNode[str(i)];
		var info:Dictionary=node["info"]
		if info.has("tS"):
			var tileSet=info["tS"]
			if tileSet:
				var tileNode=node["tile"];
				var tileNum=tileNode["_keys"].size();
				#var result=await HttpTool.send("Map/Tile/"+str(tileSet)+".img");
				#var result=await Game._getWZ("Map/Tile/"+str(tileSet)+".img")
				var result=wzTool.get_by_path("Map/Tile/"+str(tileSet)+".img").data;
				for t in range(0,tileNum):
					var childNode=tileNode[str(t)];
					var x=childNode["x"];
					var y=childNode["y"];
					var u=childNode["u"];
					var no=childNode["no"];
					var zM=childNode["zM"];				
					if result:
						var innode=result[str(u)][str(no)];
						var img=Game.Wz_getImage(innode,result[str(u)]);
						if img:
							var origin=img["origin"]
							var tt=Sprite2D.new()
							tt.texture=img["img"];
							tt.texture_filter=CanvasItem.TEXTURE_FILTER_NEAREST
							tt.position.x=x-origin.x+400+img["width"]/2
							tt.position.y=y-origin.y+300+img["height"]/2
							tt.add_to_group("load")
							tt.z_index=1000+img["z"]+10;
					
							nodeViewer.add_child(tt,true);
					
					
		
		
	
	
func load(map,wzNode, Map_Id):
		#thread.start(_StartLoad(Map_Id),1)
		#thread=Thread.new()
		wzTool=map.get_node("/root").get_node("main/WzTool")
		#var callback=Callable(self,"_StartLoad");
		#callback.call(map,wzNode,Map_Id)
		#thread.start(callback,1)
		_StartLoad(map,wzNode,Map_Id)

func _exit_tree():
	if thread:
		thread.wait_to_finish();
