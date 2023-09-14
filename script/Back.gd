extends ParallaxLayer
class_name Back;
var origin;
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
var camera;
var info;
var Norigin
var img;
var cx;
var cy;
var rx;
var ry;
var vspeed;
var hspeed;
var hmove=0;
var vmove=0;
var animKey;
var layerNode:CanvasLayer;
var PrentNode;
func add_back(PrentNode,node,info,img,z):
	self.PrentNode=PrentNode;
	if has_node("Blayer_"+str(info.no)):
		layerNode=get_node("Blayer_"+str(info.no));
	else:
		layerNode=CanvasLayer.new()
		layerNode.follow_viewport_enabled=true
		layerNode.name="Blayer_"+str(info.no)
		layerNode.add_to_group("load");
		
		pass;
	
	self.Norigin={"x":node["origin"]["X"],"y":node["origin"]["Y"]};
	self.add_to_group("load");
	textureRect=TextureRect.new()
	textureRect.stretch_mode=TextureRect.STRETCH_TILE
	textureRect.texture=img["img"]
	#layerNode.add_child(textureRect)
	self.add_child(textureRect)
	
	PrentNode.add_child(self);
	PrentNode.layer=(int(z)+1)-100
	#print(info.bS+"_"+str(info.no)+"_"+str(z))
	#self.z_index=int(z)+1;
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
	camera=self.get_viewport().get_camera_2d();
	print(info.bS+"_"+str(info.no)+"_"+str(z),"z:"+str(z))
	if info["f"]!=0:
		textureRect.flip_h=true
	self.info=info;
	setType();
	#逻辑处理
	
	pass
	
func setType():
	var width=self.img["width"]
	var height=self.img["height"];
	var scrollX = - rx / 100
	var scrollY = - ry / 100

	type=info["type"]	
	self.set_meta("type",type)
	
	if self.cx==0:
		self.cx=max(width,1);
	if self.cy==0:
		self.cy=max(height,1);
	if type==Background.HTILED||type==Background.VMOVEB:
		vspeed=ry;
	if type==Background.VTILED||type==Background.HMOVEA:
		hspeed=rx;
	#if type==Background.VTILED or type==Background.VMOVEA:
	#	self.vtile=height/self.cy+6;
	#if type==Background.TILED or type==Background.HMOVEB or type==Background.HMOVEB:
	#	self.htile=width/self.cx+6;
	#	self.vtile=height/self.cy+6;
	#if type==Background.HMOVEA or type==Background.HMOVEB:
	#	self.hspeed=self.rx;
	#if type==Background.VMOVEA or type==Background.VMOVEB:
	#	self.vspeed=self.ry;
	textureRect.position.x=info.x-Norigin.x;
	textureRect.position.y=info.y-Norigin.y;
	textureRect.texture_filter=CanvasItem.TEXTURE_FILTER_NEAREST
	
	if type==0:
		self.motion_scale=Vector2(scrollX,scrollY)
		self.motion_offset=Vector2(viewPortWidth/2,viewPortHeight/2)
		textureRect.stretch_mode=TextureRect.STRETCH_TILE 
		
		#paraNode.motion_scale=Vector2(scrollX,scrollY)
	if type==1:
		textureRect.stretch_mode=TextureRect.STRETCH_TILE
		textureRect.position=Vector2(viewPortWidth-width,self.position.y)
		textureRect.size.x=viewPortWidth;
		textureRect.position.x-=viewPortWidth-width;
		self.motion_offset=Vector2(viewPortWidth-width,viewPortHeight-height)
		#self.motion_offset=Vector2(viewPort.size.x/2,viewPort.size.y/2)
		self.motion_scale=Vector2(scrollX,scrollY)
		
		self.motion_mirroring=Vector2(width,0)
	if type==2:
		#textureRect.size.y=viewPortHeight
		
		#textureRect.stretch_mode=TextureRect.STRETCH_SCALE
		textureRect.position=Vector2(info.x+width,info.y)
		
	
		textureRect.size.y=height*3;
		PrentNode.offset.y=-100
		#textureRect.position.y-=viewPortHeight-height;
		#self.motion_offset=Vector2(info.x+width,info.y)
		self.motion_scale=Vector2(scrollX,scrollY)
		
		self.motion_mirroring=Vector2(0,height)
		
	if type==3:
		textureRect.position=Vector2(info.x,info.y)
		self.motion_scale=Vector2(scrollX,scrollY)
		#textureRect.size=Vector2(2784,5022)
		textureRect.size=Vector2(viewPortWidth+width,viewPortHeight+height)
		textureRect.stretch_mode=TextureRect.STRETCH_TILE 
		
		#self.motion_scale=Vector2(scrollX,scrollY)
		
		#t.stretch_mode=TextureRect.STRETCH_TILE 
		
		self.motion_mirroring=Vector2(viewPortWidth+width,viewPortHeight+height)
		pass
		
	
		
	if type==4||type==6:
		textureRect.stretch_mode=TextureRect.STRETCH_TILE 
		textureRect.position=Vector2(viewPortWidth-width,textureRect.position.y-100)
		self.motion_scale=Vector2(scrollX,scrollY)
		self.motion_offset=Vector2(viewPortWidth-width,textureRect.position.y)
		if width<=viewPortWidth/2:
			self.motion_mirroring=Vector2(800,viewPortHeight/2)
		else:
			self.motion_mirroring=Vector2(width,0)
		
		
	if type==5:
		self.motion_offset=Vector2(scrollX,scrollY)
	#if type==3:
	#	textureRect.visible=true;
	#else:
	#	textureRect.visible=false;
# Called when the node enters the scene tree for the first time.
func _ready():
	spriteFrames=SpriteFrames.new();
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if info and type and info.ani!=1:
		if type==Background.HMOVEA or type==Background.HMOVEB:
			self.motion_offset=Vector2(hmove,viewPortWidth/2)
			if hspeed:
				hmove=hmove+hspeed/16
