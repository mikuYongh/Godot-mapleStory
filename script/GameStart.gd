extends Control
class_name StartGame
var progressBar:ProgressBar;
var thread:Thread;
var file_num=0;
var hash_json:Dictionary;
# Called when the node enters the scene tree for the first time.
func _ready():
	progressBar=$ProgressBar;
	thread=Thread.new();
	thread.start(Callable(self,"start"),Thread.PRIORITY_HIGH)
	
	pass # Replace with function body.
func start():
	var files = {}
	init();
	traverse_directory("res://wz_client/", files)
	progressBar.max_value=file_num;
	check(files)
	get_tree().change_scene_to_file("res://scene/MapleMap.tscn")
	
func init():
	var json="res://hashCheck.json";
	var file = FileAccess.open(json,FileAccess.READ)

# 确认文件是否存在
	if file.file_exists(json)==true:
		var j=JSON.new();
		var json_data = j.parse(file.get_as_text(),true)
		var result=j.get_data()
	# 关闭文件
		file.close()
		hash_json=result;
		if hash_json:
			progressBar.max_value=hash_json.size();
		
	# 输出读取到的JSON数据
		
	else:
		print("文件不存在")
	pass;
	
	
func check(files:Dictionary):
		if !hash_json.is_empty()&&!files.is_empty():		
			var keys=files.keys();
			for key in keys:
				var newKey:String=key;
				var th:String="res://wz_client/";
				var hash1=files[key];
				
				var newName="assert/wz/"+newKey.substr(th.length(),newKey.length())
				
				if hash_json.has(newName):
					var hash2=hash_json[newName];
					#print(hash1+" "+hash2)
				
			pass;
	# 输出读取到的JSON数据
		

	
func traverse_directory(path: String, files: Dictionary) -> void:
	var dir = DirAccess.open(path)
	if  dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			var file_path = path.path_join(file_name)
			if dir.current_is_dir():
				self.traverse_directory(file_path, files)
			else:
				var file = FileAccess.open(file_path, FileAccess.READ)
				if file:
					progressBar.value=progressBar.value+1;
					var hash_context = HashingContext.new()
					hash_context.start(HashingContext.HASH_MD5)
					var buffer_size = 4096
					var file_size = file.get_length()
					var bytes_read = 0
					while bytes_read < file_size:
						var bytes_to_read = min(buffer_size, file_size - bytes_read)
						hash_context.update(file.get_buffer(buffer_size))
						bytes_read += bytes_to_read
					var file_md5 = hash_context.finish()
					var md5= file_md5.hex_encode();
					file_num=file_num+1;
					files[file_path] =md5
					file.close()
			file_name = dir.get_next()
		

# Example usage


	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
