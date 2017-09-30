extends Camera

export var flyspeed= 50


func _ready():
	self.set_process(true)


func _process(delta):
	if(Input.is_key_pressed(KEY_W)):
		self.set_translation(self.get_translation() - get_global_transform().basis*Vector3(0,0,1) * flyspeed * .01)
	if(Input.is_key_pressed(KEY_S)):
		self.set_translation(self.get_translation() - get_global_transform().basis*Vector3(0,0,1) * flyspeed * -.01)
	if(Input.is_key_pressed(KEY_A)):
		self.set_translation(self.get_translation() - get_global_transform().basis*Vector3(1,0,0) * flyspeed * .01)
	if(Input.is_key_pressed(KEY_D)):
		self.set_translation(self.get_translation() - get_global_transform().basis*Vector3(1,0,0) * flyspeed * -.01)
