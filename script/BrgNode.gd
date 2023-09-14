extends Sprite2D
class_name BrgNode;
var origin;
var spriteFrames:SpriteFrames;
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
var skipCamera;
var moveObject;
var moveV=false;
var moveH=false;
var hspeed=0;
var vspeed=0;
var htile=0;
var vtile=0;
var cx=0;
var cy=0;
var rx=0;
var ry=0;
var moveX=0;
var moveY=0;
var info;
var img;
var tre;
var viewPortWidth;
var viewPortHeight
var camera:Camera2D;
func add_back(layerNode:CanvasLayer,node,info,img):
	var origin={"x":node["origin"]["X"],"y":node["origin"]["Y"]};
	self.add_to_group("load");
	var animKey="Map/Back/"+str(info.bS)+".img/ani/"+str(info.no);
	layerNode.add_child(self);
	#spriteFrames.add_animation(animKey);
	#spriteFrames.add_frame(animKey,img["img"],1);
	#self.sprite_frames=spriteFrames;
	#self.centered=false;
	self.tre=img["img"]
	self.position=Vector2(0,0)
	#self.centered=false;
	#self.play(animKey)
	self.info=info;
	self.img=img;
	self.cx=info.cx;
	self.cy=info.cy;
	self.rx=info.rx;
	self.ry=info.ry;
	viewPortWidth=get_viewport_rect().size.x;
	viewPortHeight=get_viewport_rect().size.y;
	moveX=info.x;
	moveY=info.y;
	camera=get_viewport().get_camera_2d();
	if info["f"]!=0:
		self.flip_h=true
	setType();
	#逻辑处理
	
	pass
func setType():
	var width=viewPortWidth
	var height=viewPortHeight;
	var type=info["type"]
	if self.cx==0:
		self.cx=max(self.img["width"],1);
	if self.cy==0:
		self.cy=max(self.img["height"],1);
	self.htile=1;
	self.vtile=1
	if type==Background.TILED or type==Background.HMOVEA:
		self.htile=width/self.cx+6;
	if type==Background.VTILED or type==Background.VMOVEA:
		self.vtile=height/self.cy+6;
	if type==Background.TILED or type==Background.HMOVEB or type==Background.HMOVEB:
		self.htile=width/self.cx+6;
		self.vtile=height/self.cy+6;
	if type==Background.HMOVEA or type==Background.HMOVEB:
		self.hspeed=self.rx;
	if type==Background.VMOVEA or type==Background.VMOVEB:
		self.vspeed=self.ry;
	
func move(delta):
	self.moveX=self.moveX+self.hspeed*delta*2;
	self.moveY=self.moveY+self.vspeed*delta*2;
func _ready():
	spriteFrames=SpriteFrames.new();
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _drawe():
	var halfWidth=viewPortWidth/2;
	var halfHeight=viewPortHeight/2;
	var view=Vector2(-camera.get_screen_center_position().x+img["width"],camera.get_screen_center_position().y+img["height"]);
	var x=0;
	var y=0;
	
	if self.hspeed!=0:
		x=self.moveX+view.x;
	else:
		x=self.moveX+self.rx*(halfWidth-view.x)/500+view.x;
	
	if self.vspeed!=0:
		y=self.moveY+view.y;
	else:
		y=self.moveY-self.ry*(halfHeight-view.y)/500+view.y;
	
	if self.htile>1:
		while x>view.x:
			x=x-self.cx;
		
		while x<view.x-self.cx:
			x=x+self.cx;
	
	if self.vtile>1:
		while y>view.y:
			y=y-self.cy
		
		while y<view.y-self.cy:
			y=y+self.cy;
	
	x=floorf(x+0.5);
	y=floorf(y+0.5);
	
	for tx in range(0,self.htile):
		for ty in range(0,self.vtile):
			if self.type==Background.TILED:
				self.position=Vector2(x+tx*self.cx-halfWidth,y+ty*self.cy-halfHeight)
			else:
				if self.type==Background.VTILED:
					self.position=Vector2(x+tx*self.cx,y+ty*self.cy-halfHeight)
				else:
					if self.type==Background.HTILED:
						self.position=Vector2(x + tx * self.cx -halfWidth, y + ty * self.cy);
					else:
						self.position=Vector2(x + tx * self.cx,y + ty * self.cy)
func _draw():
	if !self.tre:return;
	var halfWidth = 400
	var halfHeight = 300
	var view = get_viewport().get_screen_transform().get_origin()
	var x = 0
	var y = 0

	if self.hspeed!=0:
		x = self.moveX + view.x
	else:
		x = self.moveX + self.rx * (halfWidth - view.x) / 500 + view.x

	if self.vspeed!=0:
		y = self.moveY + view.y
	else:
		y = self.moveY- self.ry * (halfHeight - view.y) / 500 + view.y

	if self.htile > 1:
		while x > view.x:
			x -= self.cx
		while x < view.x - self.cx:
			x += self.cx

	if self.vtile > 1:
		while y > view.y:
			y -= self.cy
		while y < view.y - self.cy:
			y += self.cy

	x = floor(x + 0.5)
	y = floor(y + 0.5)

	for tx in range(self.htile):
		for ty in range(self.vtile):
			var drawPos = Transform2D()
			if self.type == Background.TILED:
				drawPos.origin=Vector2(x + tx * self.cx - 400, y + ty * self.cy - 300)
			elif self.type == Background.VTILED:
				drawPos.origin=Vector2(x + tx * self.cx, y + ty * self.cy - 300)
			elif self.type == Background.HTILED:
				drawPos.origin=Vector2(x + tx * self.cx - 400, y + ty * self.cy)
			else:
				drawPos.origin=Vector2(x + tx * self.cx, y + ty * self.cy)
			draw_texture(self.tre,drawPos.origin)

func _process(delta):
	move(delta)
	queue_redraw();
				
	pass
