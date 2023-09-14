extends MapleWindow
var minUI;
var minMapUI;
var maxMapUI;
var miniMapNode;
var offset=Vector2(5,30)
@export var mapId="";
var map;
var userImg;
var mapinfo;
var miniMapN;
var PNode;

# Called when the node enters the scene tree for the first time.
func _ready():
	init();
	ui_process.connect(process)
	position=Vector2(100,100)
	var min_width=150
	var min_height=20;
	var width=100;
	var height=60;
	#加载minmap
	if mapId=="":return;
	if !map:return;
	mapinfo=map.info;
	
	var mi:int=int(mapId);
	var m=mi/100000000;
	if mapId.length()<9:
		for i in range(0,9-mapId.length()):
			mapId="0"+mapId;
	var result=MapleWz.get_by_path("Map/Map/Map"+str(m)+"/"+mapId+".img");
	var de:Dictionary=result.data;
	if !de.has("miniMap"):return;
	var minmap=de.get("miniMap");
	miniMapNode=minmap;
	miniMapN=minmap.canvas._image;
	width=miniMapN.width;
	height=miniMapN.height+15;
	minUI=addThreeImage("UIWindow.img/MiniMap/Min",0,0,min_width,min_height)
	var mapname=addLabel(5,0,{"color":Color(0,0,0),"text":"彩虹村","size":13},minUI)
	var minBtn_min=addButton("Basic.img/BtMin",min_width-22,6,false,{},minUI)
	minBtn_min.disabled=true;
	var maxBtn_min=addButton("Basic.img/BtMax",min_width-8,6,false,{},minUI)
	maxBtn_min.pressed.connect(Callable(self,"maxBtn_min_click"))
	minMapUI=addNineImage("UIWindow.img/MiniMap/MinMap",0,0,width,height)
	maxMapUI=addNineImage("UIWindow.img/MiniMap/MaxMap",0,0,width,height)
	
	minUI.visible=false
	minMapUI.visible=true;
	maxMapUI.visible=false;
	
	var title_minMap=addImage("UIWindow.img/MiniMap/title",8,5,false,{},minMapUI)
	var title_maxMap=addImage("UIWindow.img/MiniMap/title",8,5,false,{},maxMapUI)
	var minBtn_minMap=addButton("Basic.img/BtMin",width-22,8,false,{},minMapUI)
	minBtn_minMap.pressed.connect(Callable(self,"minBtn_minMap_click"))
	var maxBtn_minMap=addButton("Basic.img/BtMax",width-8,8,false,{},minMapUI)
	maxBtn_minMap.pressed.connect(Callable(self,"maxBtn_minMap_click"))
	
	var minBtn_maxMap=addButton("Basic.img/BtMin",width-22,8,false,{},maxMapUI)
	minBtn_maxMap.pressed.connect(Callable(self,"minBtn_maxMap_click"))
	var maxBtn_maxMap=addButton("Basic.img/BtMax",width-8,8,false,{},maxMapUI)
	maxBtn_maxMap.disabled=true;
	loadMinmap()
	
	pass # Replace with function body.
func maxBtn_min_click():
	minUI.visible=false;
	maxMapUI.visible=false;
	minMapUI.visible=true;
	PNode.visible=true;
	setSizeByNode(minMapUI)
	pass
func minBtn_minMap_click():
	minUI.visible=true;
	maxMapUI.visible=false;
	minMapUI.visible=false;
	PNode.visible=false;
	setSizeByNode(minUI)
	pass

func maxBtn_minMap_click():
	minUI.visible=false;
	maxMapUI.visible=true;
	minMapUI.visible=false;
	PNode.position.y+=42
	setSizeByNode(maxMapUI)
	pass
	
func minBtn_maxMap_click():
	minUI.visible=false;
	maxMapUI.visible=false;
	minMapUI.visible=true;
	PNode.position.y-=42
	setSizeByNode(minMapUI)
	pass
func loadMinmap():
	PNode=Node2D.new()
	var img=TextureRect.new();
	var rect=ColorRect.new();
	rect.color=Color(0,0,0,0.8)
	img.texture=miniMapNode.canvas._image.texture;
	PNode.add_child(rect)
	rect.size=Vector2(miniMapNode.canvas._image.width,miniMapNode.canvas._image.height)
	PNode.add_child(img)

	PNode.position=offset;
	PNode.z_index=-1;
	add_child(PNode)
	
	var result=MapleWz.get_by_path("Map/MapHelper.img/minimap");
	var mImg:Dictionary=result.data;
	userImg=mImg.user._image.texture;
	
	
func _draw():
	if minUI==null:return;
	if minUI.visible==true:return;
	if miniMapNode==null:return;
	var cx;
	if !miniMapNode.has("centerX"):
		cx=400;
	else:
		cx=miniMapNode.centerX;
	var cy;
	if !miniMapNode.has("centerY"):
		cy=300;
	else:
		cy=miniMapNode.centerY;
	var lx;
	var ly;
	lx=map.info.VRLeft;
	ly=map.info.VRTop;
	if map.playerList:
		var playerList:Array=map.playerList;
		var mainPlayer:Charactor;
		var players=playerList.filter(isMainPlayer);
		if players.size()>0:
			mainPlayer=players[0];
			if mainPlayer:
				if userImg:
					draw_texture(userImg,Vector2((mainPlayer.getPos().x-lx)*(miniMapN.width/mapinfo.width)-25,(mainPlayer.getPos().y-ly)*(miniMapN.height/mapinfo.height)))
	
func process(delta):
	queue_redraw();
			
		
func isMainPlayer(player:Charactor):
	if player.isMainPlayer:
		return player;
		

