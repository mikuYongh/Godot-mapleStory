extends CharacterBody2D
#角色碰撞逻辑
@onready var player=self.get_parent() as Charactor;
@onready var map=self.get_node("../../../map") as Map;
var input_vector=Vector2.ZERO
var bottomPos=Vector2.ZERO;
var lastRope=null;
var inputAble=true;
var isStartLoad=true;
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
func _process(delta):
	if map:
		inputAble=!map.loading;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if player.state!=Charactor.STATE.CLIMP and player.state!=Charactor.STATE.CLIMPING :
		if self.velocity.x<0:
			player.flip=false;
		if self.velocity.x>0:
			player.flip=true;
	#平滑处理移动衰减
	
	self.velocity.x=0;
	if player.state!=Charactor.STATE.CLIMP and player.state!=Charactor.STATE.CLIMPING :
		self.velocity.y+=delta*player.fallSpeed*2*800;
		#player.setPos(player.getPos()+Vector2(0,100*player.fallSpeed*delta))
	
	get_input(delta);
	collisionRope();
	collision(delta)
	collisionPortal();
	update_stance();
	pass;
func collision(delta):
	var count=get_slide_collision_count();
	var is_CollisionCeil=false;
	var rem=Vector2.ZERO;
	for i in range(count):
		var col=get_slide_collision(i);
		if col:
			var nor=col.get_normal();
			if nor.x==0 and nor.y==1:
				is_CollisionCeil=true;
				rem=col.get_travel()
				
	#if  is_CollisionCeil==false:
	if player.state!=Charactor.STATE.CLIMP and player.state!=Charactor.STATE.CLIMPING:
		move_and_slide()
	else:
		pass
		
	#else:
		#velocity-=rem;
		
		
func jump(delta):
	if is_on_floor()&&self.velocity.y>=0:
		self.velocity.y-=player.jumpSpeed*3*delta*98;
		AduioBGM.playBGM("Game/Jump")	
	
	player.state=Charactor.STATE.JUMP;
func walk(x,delta):
	if !is_on_wall():
		self.velocity.x+=player.moveSpeed*1.5*x;
		if is_on_floor():
			player.state=Charactor.STATE.WALK;
		pass
func update_stance():
	if player.state==Charactor.STATE.WALK:
		player.setStance(Charactor.STANCE.walk1)
	if player.state==Charactor.STATE.JUMP:
		player.setStance(Charactor.STANCE.jump)
	if player.state==Charactor.STATE.JUMP_DOWN:
		player.setStance(Charactor.STANCE.jump)
	if player.state==Charactor.STATE.STAND:
		player.setStance(Charactor.STANCE.stand1)
	if player.state==Charactor.STATE.CLIMP:
		player.setStance(Charactor.STANCE.rope)
	if player.state==Charactor.STATE.CLIMPING:
		player.setStance(Charactor.STANCE.rope)
func climpRope():
	if lastRope:
		player.state=Charactor.STATE.CLIMP;
		player.setPos(lastRope.position-Vector2(5,0))
func collisionPortal():
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(player.getPos()+Vector2(0,-7),player.getPos()+Vector2(0,7));
	query.collision_mask=pow(2, 15-1);
	var result = space_state.intersect_ray(query)
	if result.size()>0:
		var body=result.collider;
		if body.get_class()=="CharacterBody2D":return;
		
		if body.get_parent().name.begins_with("portal"):
				var info=body.get_meta("info");
				if info:
					if (info.type==3 and !isStartLoad) or Input.is_action_just_pressed("ui_up"):
						#if info.tomap!=999999999:return;
						isStartLoad=true;
						if map.mapId==null:return;
						if str(map.mapId)==str(info.tomap):
							if info.toname!="":
								AduioBGM.playBGM("Game/Portal2")
								var portal=map.portal;
								if portal==null:return;
								var pos=portal.getPlayerPn(info.toname)
								if pos:
									player.setPos(pos)				
						else:
							if str(info.tomap)=="999999999":return;
							map.tomap(str(info.tomap),info.toname);
						isStartLoad=false;
							
						
	
	pass;					
func enter_map():
	pass		
func collisionRope():
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(player.getPos()+Vector2(0,-5),player.getPos()+Vector2(10,-5));
	query.collision_mask=pow(2, 14-1);
	var result = space_state.intersect_ray(query)
	if result.size()>0:
		var body=result.collider;
		if !body:return;
		if body.get_class()=="CharacterBody2D":return;
		if body.get_parent().name.begins_with("rope"):
				print("于绳子接触与",result.position)
				lastRope=result
		else:
			lastRope=null;
	else:
		lastRope=null;
	pass;		
func climpingRope(vector):
	#在绳索上的逻辑处理
	if lastRope:
		if vector.y==1:
			player.setPos(player.getPos()+Vector2(0,-2))
			player.state=Charactor.STATE.CLIMPING;
		if vector.y==-1:
			player.setPos(player.getPos()+Vector2(0,2))
			player.state=Charactor.STATE.CLIMPING;
		
	if lastRope&&(player.state==Charactor.STATE.CLIMP or player.state==Charactor.STATE.CLIMPING):
		self.velocity.y=0;
		var rope:StaticBody2D=lastRope.collider;
		if  !rope:return;
		var start=rope.get_meta("start");
		var end=rope.get_meta("end");
	#判断是否处于攀爬的头或尾
		if floor(player.getPos().y)<=start.y+5:
			print("处于头部")
			lastRope=null;
			#player.setPos(start+Vector2(0,-8))
			move_and_collide(Vector2(0,-5),false)
			player.state=Charactor.STATE.STAND;
		if floor(player.getPos().y)>=end.y-5:
			print("处于尾部")
			lastRope=null;
			player.setPos(end+Vector2(0,-1))
			player.state=Charactor.STATE.STAND;
func getUpFootHold():
	#获取上面的foothold:
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(player.getPos()+Vector2(0,0),player.getPos()+Vector2(10,0));
	query.collision_mask=pow(2, 11-1);
	var result = space_state.intersect_ray(query)
	if result.size()>0:
		var body=result.collider;
		if body.get_class()=="CharacterBody2D":return;
		if body.get_parent().name.get_parent().name.begins_with("foothold"):
			#print(body)
			return body
	return null;
func getDownRope():
	#获取下面的Rope:
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(player.getPos()+Vector2(-10,5),player.getPos()+Vector2(10,5));
	query.collision_mask=pow(2, 14-1);
	var result = space_state.intersect_ray(query)
	if result.size()>0:
		var body=result.collider;
		if !body:return;
		if body.get_class()=="CharacterBody2D":return;
		if body.get_parent().name.begins_with("rope"):
			return body
	return null;			
func _draw():
	#draw_line(player.getPos()+Vector2(0,5), player.getPos()+Vector2(10, 5),Color.RED)
	pass
func down_jump(delta):
	#向下跳
	if player.state==Charactor.STATE.JUMP_DOWN or !is_on_floor():return;
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(player.getPos()+Vector2(0,5), player.getPos()+Vector2(0, 400))
	query.collision_mask=pow(2, 11-1);
	var result = space_state.intersect_ray(query)
	if result.size()>0:
		var body2d:StaticBody2D=result.collider;
		if body2d:
			if body2d.get_class()=="StaticBody2D":
				print("向下")
				player.state=Charactor.STATE.JUMP_DOWN;
				player.setPos(player.getPos()+Vector2(0,10))
				
	pass;
func down_rope(delta):
	#下梯子
	if player.state==Charactor.STATE.JUMP_DOWN or !is_on_floor():return;
	var space_state = get_world_2d().direct_space_state
	# use global coordinates, not local to node
	var query = PhysicsRayQueryParameters2D.create(player.getPos()+Vector2(-10,5), player.getPos()+Vector2(10, 5))
	query.collision_mask=pow(2, 14-1);
	var result = space_state.intersect_ray(query)
	if result.size()>0:
		var body2d:StaticBody2D=result.collider;
		if body2d:
			
			if body2d.get_class()=="StaticBody2D":
				player.state=Charactor.STATE.JUMP_DOWN;
				player.setPos(player.getPos()+Vector2(0,10))
				
	pass;
func get_input(delta):
	if !inputAble:return;
	input_vector = Vector2.ZERO
	if Input.is_action_pressed("ui_right"):
		input_vector.x += 1
	if Input.is_action_pressed("ui_left"):
		input_vector.x -= 1
	if Input.is_action_pressed("ui_up"):
		input_vector.y += 1
	if Input.is_action_pressed("ui_down"):
		input_vector.y -= 1
	if Input.is_action_pressed("ui_alt")&&!Input.is_action_pressed("ui_down"):
		if player.state!=Charactor.STATE.CLIMP and player.state!=Charactor.STATE.CLIMPING:
			jump(delta)
	# 根据用户输入的方向向量更新相机目标位置
	if input_vector.length() > 0:
		#if input_vector != Vector2.ZERO:
		#if input_vector.y!=0:
		#	player.characterBody.velocity.y=0;
		#var new_pos = position + input_vector * delta * 200
		#	position = new_pos	
			
		if input_vector.x!=0:
			walk(input_vector.x,delta)
		if input_vector.y==1:
			if player.state!=Charactor.STATE.CLIMP and player.state!=Charactor.STATE.CLIMPING:
				climpRope();
			#else:
				#climpingRope(delta)
		if input_vector.y==-1&&Input.is_action_pressed("ui_alt"):
			if player.state!=Charactor.STATE.JUMP:
				down_jump(delta);
		else:
			if input_vector.y==-1&&player.state!=Charactor.STATE.CLIMPING:
				var rope = getDownRope();
				if !rope:return;
				#与绳子楼梯对准
				var start=rope.get_meta("start");
				player.setPos(Vector2(start.x-5,player.getPos().y))
				
				down_rope(delta);
				pass;
		climpingRope(input_vector)
	else:
		if is_on_floor()&&player.state!=Charactor.STATE.JUMP_DOWN&&player.state!=Charactor.STATE.CLIMPING:
			player.state=Charactor.STATE.STAND;
		
	

			
			

	
	



func _on_area_2d_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	
	pass # Replace with function body.



