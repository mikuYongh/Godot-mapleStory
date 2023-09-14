class_name Equip
var info;
var icon
var type="";


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func setId(id):
	var group=int(id)/10000;
	var t=int(group/100);
	if group==100:
		type="Cap";
	if group==108:
		type="Glove";
	if group==109:
		type="Shield";
	if group==107:
		type="Shoes";
	if group==3:
		type="Hair";
	if group==2:
		type="Face";
	if group==105:
		type="Longcoat";
	if group==110:
		type="Cape";
	if group==106:
		type="Pants";
	if group==180:
		type="PetEquip";
	if group==111:
		type="Ring";
	if group==114 or group==102 or group==101 or group==103 or group==102 or group==112 or group==113 or group==114 or group==115 or group==116 or group==118 or group==119:
		type="Accessory"
	if group==104:
		type="Coat"
	if group==193 or group==190 or group==191 or group==192 or group==198 or group==199:
		type="TamingMob"
	if group==109 or group==121 or group==130:
		type="Weapon"
	if type=="":return;
	print("Character/"+type+"/"+"0"+str(int(id))+".img")
	var result=MapleWz.get_by_path("Character/"+type+"/"+"0"+str(int(id))+".img");
	if !result is RefCounted:return;
	var data:Dictionary=result.data;
	info=data.get("info");
	icon=info.get("icon")._image.texture
	return self;

	
	#MapleWz.get_by_path("UI/Basic.img/"+style).data();
	pass;
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
