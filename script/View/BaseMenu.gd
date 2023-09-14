extends UI
class_name BaseMenu;
# Called when the node enters the scene tree for the first time.
@onready var menu1=preload("res://scene/UI/Menu.tscn").instantiate();
@onready var menu2=preload("res://scene/UI/Menu.tscn").instantiate();
func _ready():
	var wzTool=get_node("/root/MapleWz")
	setWzTool(wzTool);
	menu2.setPath("ShortCut")
	add_child(menu1)
	add_child(menu2)
	menu2.item_click_event.connect(Callable(self,"item_click").bind(menu2));
	addImage("StatusBar.img/base/backgrnd",0,600-71)
	addImage("StatusBar.img/base/backgrnd2",0,600-71)
	addImage("StatusBar.img/gauge/bar",555,597,true)
	addImage("StatusBar.img/gauge/graduation",555,597,true)
	addButton("StatusBar.img/BtShop",630,612,true,{"isCustorClickHover":true,"isMenu":true})
	addButton("StatusBar.img/BtChat",675,612,true,{"isCustorClickHover":true,"isMenu":true})
	addButton("StatusBar.img/BtNPT",720,612,true,{"isCustorClickHover":true,"isMenu":true})
	var BtMenu=addButton("StatusBar.img/BtMenu",765,612,true,{"isCustorClickHover":true,"isMenu":true})
	var BtShort=addButton("StatusBar.img/BtShort",810,612,true,{"isCustorClickHover":true,"isMenu":true})
	BtMenu.pressed.connect(Callable(self,"click_menu1"))
	BtShort.pressed.connect(Callable(self,"click_menu2"))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func item_click(key,menu):
	print(key)
	if key=="BtItem":
		var item=preload("res://scene/UI/Item.tscn")
		var i:MapleWindow=item.instantiate();
		i.showWindow(get_node("/root/main/UIWindows"))
	if key=="BtEquip":
		var item=preload("res://scene/UI/Equip.tscn")
		var i:MapleWindow=item.instantiate();
		i.showWindow(get_node("/root/main/UIWindows"))
	menu.visible=false;
	pass
func click_menu1():
	menu1.visible=true;
	pass
	
func click_menu2():
	menu2.visible=true;
	pass;
	
func _process(delta):
	pass
