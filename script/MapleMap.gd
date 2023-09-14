

extends Control
#MapleMap 模拟场景

var WzHttp;#HTTP类
var uiWindows;
signal Start_LoadMap(WzHttp)
func _init():
	pass;
func _ready():
	#ProjectSettings.load_resource_pack("src/pck.json")
	#add_child(WzHttp);
	await emit_signal("Start_LoadMap","000040000")
	uiWindows=get_node("UIWindows")
	#251000000 001000001 101000000

	
func _input(event):
	if event is InputEventKey:
		if event.is_pressed()&&event.keycode==KEY_W:
			if !uiWindows:return;
			var item=preload("res://scene/UI/WorldMap.tscn")
			var i:MapleWindow=item.instantiate();
			i.showWindow(uiWindows)
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



