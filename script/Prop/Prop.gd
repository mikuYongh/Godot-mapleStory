class_name Prop
var info;
var icon
var type="";
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func setId(id):
	var group=int(id)/10000;
	var t=int(group/100);
	if t==4:
		type="Etc";
	if type=="":return;
	var result=MapleWz.get_by_path("Item/"+type+"/"+"0"+str(group)+".img"+"/"+id);
	if !result:return;
	var data:Dictionary=result.data;
	info=data.get("info");
	icon=info.get("icon")._image.texture
	return self;

	
	#MapleWz.get_by_path("UI/Basic.img/"+style).data();
	pass;
	
	
	
	
