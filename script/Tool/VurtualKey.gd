extends Control
#虚拟按键

# Called when the node enters the scene tree for the first time.
func _ready():
	if OS.get_name()!="Android":
		self.visible=false;
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event.is_action_pressed("ui_ctrl"):
		Input.action_release("ui_ctrl")

func _on_button_button_down():
	Input.action_press("ui_ctrl")
	
	pass # Replace with function body.
