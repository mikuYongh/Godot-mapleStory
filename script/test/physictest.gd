extends CharacterBody2D

var isJump=false;
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if !isJump:
		self.velocity.y+=delta*980*10;
	move_and_slide()
func _process(delta):
	if Input.is_action_pressed("ui_alt"):
		self.velocity.y-=delta*980
		isJump=true;
	else :
		isJump=false;
	pass
