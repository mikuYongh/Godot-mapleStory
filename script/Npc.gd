extends Node2D
var thread;
var wzTool:MapleResource;
var info=null;
var npcStyleBox:StyleBoxFlat
var npcChatStyleBox:StyleBoxFlat
var npcChatSetting:LabelSettings;
var height=0;
var width=0;
var ViewPortWidth=0;
var ViewPortHeight=0;
var list=[];
# Called when the node enters the scene tree for the first time.
	
		

# Called when the node enters the scene tree for the first time.
func _StartLoad(map,wzNode,Map_Id):
	var before=map.get_node("before");
	var npcNode=Node2D.new();
	
	npcNode.name="npc";
	ViewPortWidth=get_viewport_rect().size.x;
	ViewPortHeight=get_viewport_rect().size.y;
	#npcNode.position.x=get_viewport_rect().size.x/2;
	#npcNode.position.y=get_viewport_rect().size.y/2;
	before.add_child(npcNode)
	var lifes=wzNode["life"];
	var keys=lifes["_keys"];
	for i in range(0,keys.size()):
		var life=lifes[str(i)];
		var type=life["type"]
		if type!="n":continue;
		var x=life["x"];
		var y=life["y"];
		var id=life["id"];
		var f=life.get("f",0);
		var hide=null;
		if life.has("hide"):
			hide=life["hide"]
		var cy=life["cy"]
		var rx0=life["rx0"];
		var rx1=life["rx1"];
		list.append(life)
		var data=wzTool.get_by_path("Npc/"+str(id)+".img/");
		var result
		if data:
			result=data.data;
		else:
			continue;
	
		var info=result["info"]
		if info.has("link"):
			#需要link
			data=wzTool.get_by_path("Npc/"+str(info["link"])+".img/");
			if data:
				result=data.data;
			pass;
		#var dcLeft=info["dcLeft"];
		#var dcTop=info["dcTop"];
		#var dcBottom=info["dcBottom"]
		#var dcRight=info["dcRight"]
		#var storebank=info["storebank"]
		#写入info
		var nid=int(id);
		
		var rr=wzTool.get_by_path("String/Npc.img/"+str(nid))
		if !rr:continue;
		if rr is int:continue;
		info=rr.data;
		info["id"]=str(id);
		var animKey="Npc/"+str(id)+".img/";
		var as2D=AnimatedSprite2D.new();
		var sF=SpriteFrames.new();
		as2D.sprite_frames=sF;
		sF.add_animation(animKey);
		var origin={"x":0,"y":0};#这里可能还得改
		if result.has("stand"):
			var spriteNode=result["stand"]
			var spLen=spriteNode["_keys"].size();
			for b in range(0,spLen):
				if !spriteNode.has(str(b)):continue;
				var dd=spriteNode[str(b)];
				if(dd.type=="uol"):
					dd=spriteNode[str(dd.path)];
				#if dd["type"]=="uol":
					#uol处理
				#	continue;
				var img;
				if dd.has("_inlink"):
					var node=wzTool.get_by_path("Npc/"+str(id)+".img/"+dd["_inlink"]).data
					img=Game.Wz_getImage(node,spriteNode);
				else :
					img=Game.Wz_getImage(dd,spriteNode);
				if img:
					as2D.sprite_frames.add_frame(animKey,img["img"],1+img["delay"]/1000)
					if b==0:
						origin=img["origin"]
						width=img["width"]
						height=img["height"]
		if result.has("eye"):
			var spriteNode=result["eye"]
			var spLen=spriteNode["_keys"].size();
			for b in range(0,spLen):
				if !spriteNode.has(str(b)):continue;
				var dd=spriteNode[str(b)];
				if(dd.type=="uol"):
					dd=spriteNode[str(dd.path)];
				#if dd["type"]=="uol":
					#uol处理
				#	continue;
				var img;
				if dd.has("_inlink"):
					var node=wzTool.get_by_path("Npc/"+str(id)+".img/"+dd["_inlink"]).data
					img=Game.Wz_getImage(node,spriteNode);
				else :
					img=Game.Wz_getImage(dd,spriteNode);
				if img:
					as2D.sprite_frames.add_frame(animKey,img["img"],1+img["delay"]/1000,b)
		
		if result.has("say0"):
			var spriteNode=result["say0"]
			var spLen=spriteNode["_keys"].size();
			for b in range(0,spLen):
				if !spriteNode.has(str(b)):continue;
				var dd=spriteNode[str(b)];
				if(dd.type=="uol"):
					dd=spriteNode[str(dd.path)];
				#if dd["type"]=="uol":
					#uol处理
				#	continue;
				var img;
				if dd.has("_inlink"):
					var node=wzTool.get_by_path("Npc/"+str(id)+".img/"+dd["_inlink"]).data
					img=Game.Wz_getImage(node,spriteNode);
				else :
					img=Game.Wz_getImage(dd,spriteNode);
				if img:
					as2D.sprite_frames.add_frame(animKey,img["img"],1+img["delay"]/1000,b)
		if result.has("say"):
			var spriteNode=result["say"]
			var spLen=spriteNode["_keys"].size();
			for b in range(0,spLen):
				if !spriteNode.has(str(b)):continue;
				var dd=spriteNode[str(b)];
				if(dd.type=="uol"):
					dd=spriteNode[str(dd.path)];
				#if dd["type"]=="uol":
					#uol处理
				#	continue;
				var img;
				if dd.has("_inlink"):
					var node=wzTool.get_by_path("Npc/"+str(id)+".img/"+dd["_inlink"]).data
					img=Game.Wz_getImage(node,spriteNode);
				else :
					img=Game.Wz_getImage(dd,spriteNode);
				if img:
					as2D.sprite_frames.add_frame(animKey,img["img"],1+img["delay"]/1000,b)
		
		as2D.position.x=x-origin.x+map.get_viewport_rect().size.x/2
		as2D.position.y=cy-origin.y+map.get_viewport_rect().size.y/2;
		as2D.name=animKey;
		as2D.centered=false;
		#npcNode.add_child(as2D)
		var Clayer=CanvasLayer.new();
		if f==1:
			Clayer.layer=2;
		else:
			Clayer.layer=8;
		Clayer.add_to_group("load")
		Clayer.follow_viewport_enabled=true;
		Clayer.add_child(as2D)
		as2D.add_to_group("load")
		#as2D.set_meta("node",spriteNode)
		as2D.visibility_layer=10;
		#as2D.z_index=3000+i;
		as2D.play(animKey)
		var fontsize=12;
		var top=0;
		var left=0
		if info.has("func"): 
			var label2=Label.new()
			label2.text=info["func"]
			label2.add_theme_stylebox_override("normal",npcStyleBox)
			label2.add_theme_font_size_override("font_size",fontsize)
			label2.add_theme_color_override("font_color", Color(255,255,0,1))
			var font2=label2.get_theme_default_font();
			#font2.set("font_weight",2)
			label2.vertical_alignment=1;
			label2.horizontal_alignment=1;
			label2.position.y+=height-font2.get_height(fontsize)/2+5
			label2.z_index=30+i;
			label2.position.x+=width/2-label2.size.x/2
			as2D.add_child(label2,false)
			top=font2.get_height(fontsize);
			left=font2.get_font_weight();
		
		
		var label=Label.new()
		label.text=info.name;
		label.add_theme_stylebox_override("normal",npcStyleBox)
		
		label.add_theme_font_size_override("font_size",fontsize)
		
		npcChatStyleBox.set_content_margin_all(5)
			
		label.add_theme_color_override("font_color", Color(255,255,0,1))
		var font=label.get_theme_default_font();
		#font.set("font_weight",600)
		label.vertical_alignment=1;
		label.horizontal_alignment=1;
		label.position.y+=height+label.size.y/2+top/2+5
		label.z_index=30+i;
		label.position.x+=width/2-label.size.x/2
		#lbael2
		
	
		#label.set("panel", npcStyleBox)
		#label.set("font_color", Color.WHITE)
		as2D.add_child(label,false)
		drawChatBalloon(info,as2D,cy)
		npcNode.add_child(Clayer)
		
	
	pass;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func drawChatBalloon(info,as2D,cy):
	var chatBallon=wzTool.get_by_path('UI/ChatBalloon.img').data
	var npcChatBallon=chatBallon.get("npc",null)
	var arrow:Dictionary=npcChatBallon.get("arrow",null);
	var c:Dictionary=npcChatBallon.get("c",null);
	var s:Dictionary=npcChatBallon.get("s",null);
	var n:Dictionary=npcChatBallon.get("n",null);
	var w:Dictionary=npcChatBallon.get("w",null);
	var e:Dictionary=npcChatBallon.get("e",null);
	var nw:Dictionary=npcChatBallon.get("nw",null);
	var se:Dictionary=npcChatBallon.get("se",null);
	var ne:Dictionary=npcChatBallon.get("ne",null);
	var sw:Dictionary=npcChatBallon.get("sw",null);
	var chatHeight=0;
	var chatWidth=0;
	var fontsize=11;
	var label=Label.new()
	label.size.x=120;
	var s0=info.get("s0","")
	if s0!="":
		pass
	label.text=info.get("s0","")
	if label.text=="":
		return;
	
	label.add_theme_stylebox_override("normal",npcChatStyleBox)

	#label.add_theme_font_size_override("font_size",fontsize)
		
	#label.add_theme_color_override("font_color", Color("#7d0000"))
	
	label.label_settings=npcChatSetting;
	var font=label.get_theme_default_font();
	font.set("font_weight",500)
	label.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART
	var multilineSize=font.get_multiline_string_size(label.text,HORIZONTAL_ALIGNMENT_LEFT,label.size.x,fontsize,-1,TextServer.BREAK_GRAPHEME_BOUND,0)
	chatHeight=multilineSize.y
	chatWidth=multilineSize.x
	label.vertical_alignment=VERTICAL_ALIGNMENT_CENTER;
	label.horizontal_alignment=HORIZONTAL_ALIGNMENT_LEFT;
	label.position.y=-height/2-chatHeight+height/4
	
	label.position.x=chatWidth/2-chatWidth/2
	label.z_index=101;
	var chatBallonNode=Node2D.new();
	chatBallonNode.name="chatBallon"
	as2D.add_child(chatBallonNode)
	chatBallonNode.add_child(label);
	chatBallonNode.z_index=100;
	chatBallonNode.add_to_group("load")
	

	if c:
		var cImg=Game.Wz_getImage(c,npcChatBallon);
		var cSp=TextureRect.new();
		cSp.texture=cImg["img"];
		cSp.size.y=chatHeight
		cSp.size.x=chatWidth+1;
		cSp.position.x+=cImg["width"]/4+2
		cSp.position.y+=-height/2+cImg["height"]/4-chatHeight+height/4
		chatBallonNode.add_child(cSp)
		pass;
	if s:
		var sImg=Game.Wz_getImage(s,npcChatBallon);
		var sSp=TextureRect.new();
		sSp.texture=sImg["img"];
		sSp.size.x=chatWidth-2
		sSp.position.x+=sImg["width"]/2
		sSp.position.y+=-height/2+chatHeight+sImg["height"]/2-chatHeight+height/4
		chatBallonNode.add_child(sSp)
		pass;
	if n:
		var nImg=Game.Wz_getImage(n,npcChatBallon);
		var nSp=TextureRect.new();
		nSp.texture=nImg["img"];
		nSp.size.x=chatWidth-2;
		nSp.position.x+=nImg["width"]/2
		nSp.position.y+=-height/2-chatHeight+nImg["height"]/4+height/4;
		chatBallonNode.add_child(nSp)
		pass;
	if w:
		var wImg=Game.Wz_getImage(w,npcChatBallon);
		var wSp=TextureRect.new();
		wSp.texture=wImg["img"];
		wSp.size.y=chatHeight-2;
		wSp.position.y+=-height/2-chatHeight+wImg["height"]/2+height/4
		wSp.position.x+=wImg["width"]/4
		chatBallonNode.add_child(wSp)
		pass;
	if e:
		var eImg=Game.Wz_getImage(e,npcChatBallon);
		var eSp=TextureRect.new();
		eSp.texture=eImg["img"];
		eSp.size.y=chatHeight-2
		eSp.position.y+=-height/2-chatHeight+eImg["height"]/2+height/4
		eSp.position.x+=chatWidth+eImg["width"]/4
		chatBallonNode.add_child(eSp)
		pass;
	if nw:
		var nwImg=Game.Wz_getImage(nw,npcChatBallon);
		var nwSp=TextureRect.new();
		nwSp.texture=nwImg["img"];
		#nwSp.size.y=chatHeight;
		nwSp.position.y+=-height/2-chatHeight+nwImg["height"]/4+height/4
		nwSp.position.x+=nwImg["width"]/4
		chatBallonNode.add_child(nwSp)
		pass;
	if se:
		var seImg=Game.Wz_getImage(se,npcChatBallon);
		var seSp=TextureRect.new();
		seSp.texture=seImg["img"];
		seSp.position.y+=-height/2+chatHeight+seImg["height"]/2-chatHeight+height/4
		seSp.position.x+=chatWidth+seImg["width"]/4
		chatBallonNode.add_child(seSp)
		pass;
	if ne:
		var neImg=Game.Wz_getImage(ne,npcChatBallon);
		var neSp=TextureRect.new();
		neSp.texture=neImg["img"];
		neSp.position.y+=-height/2-chatHeight+neImg["height"]/4+height/4
		neSp.position.x+=chatWidth+neImg["width"]/4
		chatBallonNode.add_child(neSp)
		pass;
	if sw:
		var swImg=Game.Wz_getImage(sw,npcChatBallon);
		var swSp=TextureRect.new();
		swSp.texture=swImg["img"];
		swSp.position.y+=-height/2+chatHeight+swImg["height"]/2-chatHeight+height/4
		swSp.position.x+=swImg["width"]/4
		chatBallonNode.add_child(swSp)
		pass;
	if arrow:
		var arrowImg=Game.Wz_getImage(arrow,npcChatBallon);
		var arrowSp=TextureRect.new();
		arrowSp.texture=arrowImg["img"];
		arrowSp.position.y+=-height/2+chatHeight+arrowImg["height"]/2-chatHeight+height/4-2
		arrowSp.position.x+=chatWidth/2-arrowImg["width"]/4
		chatBallonNode.add_child(arrowSp)
		pass;
	
	


func load(map,wzNode, Map_Id):
	wzTool=map.get_node("/root").get_node("main/WzTool")
	npcStyleBox=StyleBoxFlat.new();
	npcStyleBox.border_width_bottom=5;
	npcStyleBox.border_color=Color("ffffff00")
	npcStyleBox.bg_color=Color(0, 0, 0, 0.7);
	
	npcChatStyleBox=StyleBoxFlat.new();
	npcChatStyleBox.border_width_bottom=5;
	npcChatStyleBox.border_color=Color("ffffff00")
	npcChatStyleBox.bg_color=Color(0, 0, 0, 0);
	
	npcChatSetting=LabelSettings.new();
	npcChatSetting.line_spacing=1;
	npcChatSetting.font_color=Color("#7d0000");
	npcChatSetting.font_size=11
	#var callback=Callable(self,"_StartLoad");
	#callback.call_deferred(map,wzNode,Map_Id);
	_StartLoad(map,wzNode,Map_Id)
func _exit_tree():
	self.queue_free();
