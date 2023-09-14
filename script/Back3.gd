extends Node2D
class_name Back3
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
var layerNode:CanvasLayer;
var viewPortWidth;
var viewPortHeight;
var camera:Camera2D;
var tileX=false;
var tileY=false
var velocityX=0;
var velocityY=0;
var Norigin;
var info;
var img;
var cx;
var cy;
var tdelta=0;
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
func add_back(PrentNode,node,info,img):
	if has_node("Blayer_"+str(info.no)):
		layerNode=get_node("Blayer_"+str(info.no));
	else:
		layerNode=CanvasLayer.new()
		layerNode.follow_viewport_enabled=false
		layerNode.name="Blayer_"+str(info.no)
		layerNode.add_to_group("load");
		#layerNode.layer=info.no;
		pass;
	self.add_to_group("load");
	self.Norigin={"x":node["origin"]["X"],"y":node["origin"]["Y"]};
	self.add_to_group("load");
	
	textureRect=TextureRect.new()
	#textureRect.stretch_mode=TextureRect.STRETCH_TILE
	textureRect.texture=img["img"]
	layerNode.add_child(textureRect)
	
	self.add_child(layerNode)
	PrentNode.add_child(self)
	self.info=info;
	self.img=img;
	#self.centered=false;
	self.cx=info.get("cx",null);
	if self.cx==0:
		self.cx=maxi(self.cx,img["width"])
	self.cy=info.get("cy",null);
	if self.cy==0:
		self.cy=maxi(self.cy,img["height"])
	viewPortWidth=800
	viewPortHeight=600;
	camera=PrentNode.get_viewport().get_camera_2d();
	if info["f"]!=0:
		textureRect.flip_h=true
	self.info=info;
	setType();

func setType():
	tileX=false;
	tileY=false;
	if info.type==4:
		tileX=true;
	if info.type==5:
		tileY=true;
	if info.type==7:
		tileX=true;
		tileY=true;
	velocityX=0;
	velocityY=0;
	if info.type==6:
		velocityX=info.rx;
	if info.type==7:
		velocityY=info.ry;
	pass
func draw(delta):
	var dx=info.x;
	var dy=info.y;
	var cameraPos=camera.get_screen_center_position()
	if velocityX!=0:
		dx+=(delta*info.rx)/200-cameraPos.x;
	else:
		var wOffset=viewPortWidth/2
		var shiftX=(info.rx*(cameraPos.x+wOffset))/100+wOffset;
		dx+=shiftX;
	
	if velocityY!=0:
		dy+=(delta*info.ry)/200-cameraPos.y;
	else:
		var hOffset=viewPortHeight/2;
		var shiftY=(info.ry*(cameraPos.y+hOffset))/100+hOffset;
		dy+=shiftY;
	var width=floori(img["width"]);
	var height=floori(img["height"])
	var cx=self.cx;
	var cy=self.cy;
	if !cx:
		cx=width;
	if !cy:
		cy=height;
	var originX=Norigin.x;
	var originY=Norigin.y
	
	
	dx=floor(dx);
	dy=floor(dy);
	if !textureRect.flip_h:
		dx-=originX;
	else:
		dx-=width-originX;
	var moveType=info.get("moveType",0);
	var moveW=info.get("moveW",0);
	var moveH=info.get("moveH",0);
	var moveP=info.get("moveP",PI*2*1000);
	
	if moveType==1:
		dx+=moveW*sin((PI*2*delta)/moveP)
	if moveType==2:
		dy+=moveH*sin((PI*2*delta)/moveP)
	if moveType==3:
		dx+=moveW*cos((PI*2*delta)/moveP)
		dy+=moveH*sin((PI*2*delta)/moveP)
	
	var moveR=info.get("moveR",0);
	var angle=0;
	if moveR==0:
		angle=0;
	else:
		angle=((delta*360)/moveR)%360
		
	var xBegin=floori(dx);
	var xEnd=floori(dx);
	var yBegin=floori(dy);
	var yEnd=floori(dy);
	
	if !!tileX:
		xBegin+=width;
		xBegin%=floori(cx);
		if xBegin<=0:
			xBegin+=cx;
		xBegin-=width;
		
		xEnd-=viewPortWidth;
		xEnd%=cx;
		if xEnd>=0:
			xEnd-=cx;
		xEnd+=viewPortWidth;
	
	if !!tileY:
		yBegin+=height;
		yBegin%=cy;
		if yBegin<=0:
			yBegin+=cy;
		yBegin-=height;
		
		yEnd-=viewPortHeight;
		yEnd %=cy;
		if yEnd>=0:
			yEnd-=cy;
		yEnd+=viewPortHeight
		
	for dx2 in range(floor(xBegin),xEnd+cx,cx):
		for dy2 in range(floor(yBegin),yEnd+cy,cy):
			textureRect.position=Vector2(dx2,dy2)
			
	
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func edraw():
	var dx=info.x;
	var dy=info.y;
	var cameraPos=camera.position
	if velocityX!=0:
		dx+=(tdelta*info.rx)/200-cameraPos.x;
	else:
		var wOffset=viewPortWidth/2
		var shiftX=(info.rx*(cameraPos.x+wOffset))/100+wOffset;
		dx+=shiftX;
	
	if velocityY!=0:
		dy+=(tdelta*info.ry)/200-cameraPos.y;
	else:
		var hOffset=viewPortHeight/2;
		var shiftY=(info.ry*(cameraPos.y+hOffset))/100+hOffset;
		dy+=shiftY;
	var width=floori(img["width"]);
	var height=floori(img["height"])
	var cx=self.cx;
	var cy=self.cy;
	if !cx:
		cx=width;
	if !cy:
		cy=height;
	var originX=Norigin.x;
	var originY=Norigin.y
	
	
	dx=floor(dx);
	dy=floor(dy);
	if !textureRect.flip_h:
		dx-=originX;
	else:
		dx-=width-originX;
	
	var moveType=info.get("moveType",0);
	var moveW=info.get("moveW",0);
	var moveH=info.get("moveH",0);
	var moveP=info.get("moveP",PI*2*1000);
	
	if moveType==1:
		dx+=moveW*sin((PI*2*tdelta)/moveP)
	if moveType==2:
		dy+=moveH*sin((PI*2*tdelta)/moveP)
	if moveType==3:
		dx+=moveW*cos((PI*2*tdelta)/moveP)
		dy+=moveH*sin((PI*2*tdelta)/moveP)
	
	var moveR=info.get("moveR",0);
	var angle=0;
	if moveR==0:
		angle=0;
	else:
		angle=((tdelta*360)/moveR)%360
		
	var xBegin=floori(dx);
	var xEnd=floori(dx);
	var yBegin=floori(dy);
	var yEnd=floori(dy);
	
	if !tileX:
		xBegin+=width;
		xBegin%=floori(cx);
		if xBegin<=0:
			xBegin+=cx;
		xBegin-=width;
		
		xEnd-=viewPortWidth;
		xEnd%=cx;
		if xEnd>=0:
			xEnd-=cx;
		xEnd+=viewPortWidth;
	
	if !tileY:
		yBegin+=height;
		yBegin%=cy;
		if yBegin<=0:
			yBegin+=cy;
		yBegin-=height;
		
		yEnd-=viewPortHeight;
		yEnd %=cy;
		if yEnd>=0:
			yEnd-=cy;
		yEnd+=viewPortHeight
	
	for dx2 in range(floor(xBegin),xEnd+cx,cx):
		for dy2 in range(floor(yBegin),yEnd+cy,cy):
			print(dx2," ",dy2)
	
	pass;
	
func drawa(camera):
	var halfWidth = 400
	var halfHeight = 300
	var view = camera.get_inverse_projection().get_origin()
	var x = 0
	var y = 0

	if self.moveObject.is_horizontal():
		x = self.moveObject.x + view.x
	else:
		x = self.moveObject.x + self.rx * (halfWidth - view.x) / 500 + view.x

	if self.moveObject.is_vertical():
		y = self.moveObject.y + view.y
	else:
		y = self.moveObject.y - self.ry * (halfHeight - view.y) / 500 + view.y

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
				drawPos.set_origin(Vector2(x + tx * self.cx - 400, y + ty * self.cy - 300))
			elif self.type == Background.VTILED:
				drawPos.set_origin(Vector2(x + tx * self.cx, y + ty * self.cy - 300))
			elif self.type == Background.HTILED:
				drawPos.set_origin(Vector2(x + tx * self.cx - 400, y + ty * self.cy))
			else:
				drawPos.set_origin(Vector2(x + tx * self.cx, y + ty * self.cy))

			if self.animation != null:
				self.animation.draw(camera.get_view_projection() * drawPos)
	

func _process(delta):
	tdelta+=delta;
	drawa(camera)
	
	pass
