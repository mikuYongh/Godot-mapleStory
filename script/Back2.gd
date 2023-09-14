extends Node
class_name Back2
var spriteFrames:SpriteFrames;
var textureRect:TextureRect;
enum Background{
	NORMAL = 0,
	HTILED = 1,
	VTILED = 2,
	TILED = 3,
	HMOVEA = 4,
	VMOVEA = 5,
	HMOVEB = 6,
	VMOVEB = 7,

}
var type:Background;
var viewPortWidth;
var viewPortHeight;
var camera:Camera2D;
var info;
var Norigin
var img;
var cx;
var cy;
var rx;
var ry;
var vspeed=0;
var hspeed=0;
var hmove=0;
var vmove=0;
var animKey;

var velocityX = 0
var velocityY = 0
var moveV=false;
var moveH=false;
var tileX=false;
var tileY=false;
var layerNode:CanvasLayer;
func add_back(PrentNode,node,info,img):
	if has_node("Blayer_"+str(info.no)):
		layerNode=get_node("Blayer_"+str(info.no));
	else:
		layerNode=CanvasLayer.new()
		layerNode.follow_viewport_enabled=true
		layerNode.name="Blayer_"+str(info.no)
		layerNode.add_to_group("load");
		layerNode.layer=info.no;
		pass;
	self.add_to_group("load");
	
	self.Norigin={"x":node["origin"]["X"],"y":node["origin"]["Y"]};
	self.add_to_group("load");
	textureRect=TextureRect.new()
	textureRect.stretch_mode=TextureRect.STRETCH_TILE
	textureRect.texture=img["img"]
	add_child(textureRect)
	PrentNode.add_child(self);
	
	#self.centered=false;
	self.info=info;
	self.img=img;
	#self.centered=false;
	self.cx=info.cx;
	self.cy=info.cy;
	self.rx=info.rx;
	self.ry=info.ry;
	viewPortWidth=800
	viewPortHeight=600;
	camera=PrentNode.get_viewport().get_camera_2d();
	if info["f"]!=0:
		textureRect.flip_h=true
	self.info=info;
	setType();
	#逻辑处理
	
	pass
func setType():
	var width=self.img["width"]
	var height=self.img["height"];
	self.moveV =false;
	self.moveH=false;
	if cx==0:
		cx=maxi(width,1)
	if cy==0:
		cy =maxi(height,1)
	tileX=false
	tileY=false;
	

	type=info["type"]	
	self.set_meta("type",type)
	if type==Background.HTILED or type==Background.HMOVEA :
		self.htile=width/cx+6;
	if type==Background.VTILED or type==Background.VMOVEA:
		self.vtile=height/cy+6;
	if type==Background.TILED or type==Background.HMOVEB or type==Background.VMOVEB:
		self.htile=width/self.cx+6;
		self.vtile=height/self.cy+6;
	if type==Background.HMOVEA or type==Background.HMOVEB:
		self.hspeed=self.rx;
	if type==Background.VMOVEA or type==Background.VMOVEB:
		self.vspeed=self.ry;

	
	
	
# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func draw(delta):
	pass;
	
func _move(delta):
	if textureRect:
		textureRect.position.x = textureRect.position.x + self.hspeed * delta * 2
		textureRect.position.y = textureRect.position.y + self.vspeed * delta * 2
func _process(delta):
	draw(delta);
	_move(delta)
	
	
