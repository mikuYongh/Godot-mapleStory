extends MapleWindow

var btClose:Button;
var btGather:Button;
var btFull:Button;
var btSmall:Button;
var isSmall=true;
# Called when the node enters the scene tree for the first time.
func _ready():
	init();
	btClose=addButton("Basic.img/BtClose",self.size.x-18,8);
	btGather=addButton("UIWindow.img/Item/BtGather",self.size.x-33,8);
	btFull=addButton("UIWindow.img/Item/BtFull",self.size.x-48,8);
	btSmall=addButton("UIWindow.img/Item/BtSmall",self.size.x-48,8);
	btSmall.visible=false;
	btFull.pressed.connect(Callable(self,"change_size"))
	btSmall.pressed.connect(Callable(self,"change_size"))
	btClose.pressed.connect(Callable(self,"close"))
	addTab(2,21,"UIWindow.img/Item/Tab","Tab2")
	initList()
	pass # Replace with function body.

func change_size():
	isSmall=!isSmall;
	if !isSmall:
		changeBackground("FullBackgrnd")
		btFull.visible=true;
		btSmall.visible=false;
	else:
		changeBackground("backgrnd")
	btFull.visible=false;
	btSmall.visible=true;
	btSmall.position=Vector2(self.size.x-48-btClose.icon.get_width()/2,btClose.position.y);
	btClose.position=Vector2(self.size.x-18-btClose.icon.get_width()/2,btClose.position.y);
	btGather.position=Vector2(self.size.x-33-btGather.icon.get_width()/2,btGather.position.y);

func initList():
	#var props=["04250001","04250202","04250001","04250001","04250100","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001","04250001"]
	var props=["01112301","01302001","01302002","01302003","01302003","01302003","01302003","01302003","01302003","01302003","01302003","01302003","01302003","01302003","01302003","01302003","01302003","01302003","01302003","01302003","01302003","01302003","01302003","01302003","01302003","01302003","01302003","01302003","01302003","01302003","01302003","01302003","01302003","01302003","01302003","01302003","01302003","01302003","01302003","01302003","01302003","01302003","01302003","01302003","01302003","01302003","01302003","01302003","01302003","01302003"]
	for p in props:
		var prop=Equip.new().setId(p);
		if !prop:return;
		var i=TextureRect.new();
		i.texture=prop.icon;
		$MapleGridView.addCellNode(i)
		
