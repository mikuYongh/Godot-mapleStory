extends MapleWindow
var title:Sprite2D;
var btClose:Button;
var offset=Vector2(612,392)/2
@onready var mapleMap=self.get_node("/root/main/SubViewportContainer/SubViewport/map");
var map;
var n;
var parentMap;
# Called when the node enters the scene tree for the first time.
func _ready():
	init2(640,490);
	self.get_node("/root/main/SubViewportContainer/SubViewport/map")
	btClose=addButton("Basic.img/BtClose",self.size.x-5,8);
	title=addImage(path+"/title",10,5,false)
	_loadWorldMap("WorldMap")
	ui_input.connect(Callable(self,"gui_input"))
	pass # Replace with function body.

func _loadWorldMap(name):
	n=Node2D.new();
	var result=MapleWz.get_by_path("Map/WorldMap/"+name+".img")
	if result is RefCounted:
		var data=result.data;
		var info=data.get("info");
		parentMap=info.get("parentMap",null)
		var pimg=data.get("BaseImg").get("0")._image
		var img=pimg.texture;
		var mapList=data.get("MapList")
		var mapLink=data.get("MapLink");
		if mapLink:
			var lkLen=mapLink["_keys"].size();
			for i2 in range(0,lkLen):
				var node=mapLink[str(i2)];
				var link=node.get("link");
				var toolTip=node.get("toolTip")
				var linkimg=link.get("linkImg");
				var linkmap=link.get("linkMap");
				var lk_sp=TextureRect.new();
				lk_sp.add_to_group("loadm",true)
				lk_sp.texture=linkimg._image.texture;
				lk_sp.modulate=Color(1,1,1,0)
				'var pos=Vector2(0,0)
				if i2==0:
					pos=Vector2(112,46);
				if i2==1:
					pos=Vector2(18,91);
				if i2==2:
					pos=Vector2(226,110);
				if i2==3:
					pos=Vector2(190,211);
				if i2==4:
					pos=Vector2(147,139);
				if i2==5:
					pos=Vector2(38,201);
				if i2==6:
					pos=Vector2(452,184);
				if i2==7:
					pos=Vector2(268,295);
				if i2==8:
					pos=Vector2(7,311);
				if i2==9:
					pos=Vector2(152,56);
				if i2==10:
					pos=Vector2(16,191);
					'
				var pos=Vector2(pimg.width/2,pimg.height/2)-Vector2(linkimg.origin.X,linkimg.origin.Y);
				lk_sp.position=pos;
				var entered=func():
					lk_sp.modulate=Color(1,1,1,1)
					pass
				var exited=func():
					lk_sp.modulate=Color(1,1,1,0)
					pass
				var click=func (event):
					if event as InputEventMouseButton&&event.pressed:
						#self.remove_from_group("loadm")
						n.queue_free();
						await n.is_queued_for_deletion();
						_loadWorldMap(linkmap)
						
					pass
				lk_sp.z_index=lkLen-i2
				lk_sp.mouse_entered.connect(entered);
				lk_sp.mouse_exited.connect(exited);
				lk_sp.gui_input.connect(click)
				
				#lk_sp.position=Vector2(linkimg.origin.X,linkimg.origin.Y)
				n.add_child(lk_sp)
				#$map.add_child(lk_sp)
		$map.texture=img;
		var spLen=mapList["_keys"].size();
		for i in range(0,spLen):
			var po=mapList[str(i)];
			var spot=po.get("spot");
			var type=po.get("type")
			var po_img=MapleWz.get_by_path("Map/MapHelper.img/worldMap/mapImage/"+str(type)).data
			var po_sp=TextureRect.new();
			po_sp.texture=po_img._image.texture;
			po_sp.add_to_group("loadm",true)
			po_sp.z_index=100
			po_sp.position=Vector2(spot.X,spot.Y)+offset+$map.position
			po_sp.gui_input.connect(Callable(self,"point_click").bind(po))
			n.add_child(po_sp)
		$map.add_child(n)
			
		
	pass;
func gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index==2&&event.pressed:
			if parentMap is String:
				n.queue_free();
				await n.is_queued_for_deletion();
				_loadWorldMap(parentMap)
				
	
func point_click(event,data):
	if event is InputEventMouseButton:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)&&event.pressed:
			print(data)
			var mapNo=data.get("mapNo");
			if mapNo.has("0"):
				var mapid=mapNo["0"];
				mapleMap.tomap(str(mapid))
				close()
