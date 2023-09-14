extends RefCounted
class_name Game
const HttpScene=preload("../scene/HttpManager.tscn");
var WzHttp;
var loadCount=0;

func set_WzHttp(n):
	WzHttp=n;
	
static func Wz_getImage(node:Dictionary,lastnode:Dictionary):
	#增加对Uol的支持 考虑到加入索引可能会增加大小 使用lastnode
	if node.size()>0:
		
		if node["type"]=="uol":
			uolRef(node,lastnode);
			node=lastnode[node["name"]]
		if !node.has("_image"):
			return null;
		var image=node["_image"]
		var uri=image["uri"];
		var texture=image["texture"]
		var width=image["width"];
		var height=image["height"];
		var orgin={"x":0,"y":0}
		var z=node.get("z",0)
		var a0=node.get("a0",-1);
		var a1=node.get("a1",-1);
		if node.has("origin"):
			orgin={"x":node["origin"]["X"],"y":node["origin"]["Y"]}
		var delay=600;	
		if node.has("delay"):
			delay=int(node["delay"]);
		if image:
		
			#var result = Image.new()
			#var b_data=uri
			#var a=Marshalls.base64_to_raw(b_data)
			#result.load_png_from_buffer(a)
			
			#result.save_png("res://2.png")
			#var t=ImageTexture.new()
			#t.set_image(result) #,7;
			#result=null;
			#a=null;
			return {"img":texture,"width":width,"height":height,"z":z,"origin":orgin,"delay":delay,"a0":a0,"a1":a1};
		
	return null;	
static func uolRef(node,lastnode):
	var path=node["path"]
	var name=node["name"]
	if path.begins_with(".."):return;
	lastnode[str(name)]=lastnode[str(path)];
	
static func _getWZ(path):
	ResourceLoader.load_threaded_request("res://wz_client/"+path+".xml.json","JSON",true,ResourceLoader.CACHE_MODE_REUSE)
	#var state=ResourceLoader.load_threaded_get_status("res://wz_client/"+path+".xml.json")
	var json=ResourceLoader.load_threaded_get("res://wz_client/"+path+".xml.json");
	var data=json.get_data();
	if data==null:return;
	return data 
		
	

	
	

