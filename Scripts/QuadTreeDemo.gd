extends Node

var _rootQuadTree = null
var _mat = FixedMaterial.new()
var _bodies = []


func _ready():
	set_process(true)
	set_fixed_process(true)
	set_process_input(true)
	
	# create a QuadTree
	var sampleBounds = Rect2(Vector2(0, 0), Vector2(64, 64))
	_rootQuadTree = get_node("QuadTree").create_quadtree(sampleBounds, 5, 8)
	
	# add bodies and draw the quadtree/bodies
	_add_random_bodies(1000)
	_draw_root()


func _fixed_process(delta):
	#demonstrate querying the QuadTree.  We call get_bodies_in_radius to
	#retrieve a list of bodies who belong to quadrants that overlap a circle
	#at hitPoint with radius of 2
	if(Input.is_mouse_button_pressed(1)):
		var hitPoint = _get_hit_point(get_viewport().get_mouse_pos())
		var result = _rootQuadTree.get_bodies_in_radius(hitPoint, 2)
		#erase them for visual feedback
		for body in result: 
			_bodies.erase(body)
		#redraw
		_draw_root()
		
	#press R to generate and add a new set of bodies
	if(Input.is_key_pressed(KEY_R)):
		_rootQuadTree.clear()
		_bodies.clear()
		_add_random_bodies(1000)
		_draw_root()


func _process(delta):
	#It's slow if there's thousands of _bodies, but you 
	#can update your QuadTree each frame in this manner:
	#_rootQuadTree.clear()
	#for body in _bodies:
	#	_rootQuadTree.add_body(body)
	#_draw_root()
	pass


func _add_random_bodies(count):
	""" Add random bodies to the QuadTree and store them locally for drawing purposes """
	var i = 0
	while(i < count):
		var body = Spatial.new()
		var location = Vector3(randi() % 65, randi() % 65, 0) #generate a random location vector
		body.set_translation(location)
		_bodies.append(body) #store locally to draw easily
		_rootQuadTree.add_body(body) #add to our root QuadTree 
		i+=1


func _draw_root():
	""" Draws the QuadTree, it's children, and all bodies for visual feedback """
	var drawer = get_node("drawer")
	drawer.set_material_override(_mat)
	drawer.clear()
	drawer.begin(Mesh.PRIMITIVE_LINES, null)
	
	var points = _rootQuadTree.get_rect_lines()
	
	for point in points:
		drawer.add_vertex(point)

	for body in _bodies:
		_add_body_rect(drawer, body.get_translation())

	drawer.end()


func _add_body_rect(drawer, center):
	""" Adds a sample rect to the ImmediateGeometry node """
	var p1 = Vector3(center.x - 0.25, center.y - 0.25, center.z)
	var p2 = Vector3(center.x + 0.25, center.y - 0.25, center.z)
	var p3 = Vector3(center.x + 0.25, center.y + 0.25, center.z)
	var p4 = Vector3(center.x - 0.25, center.y + 0.25, center.z)
	drawer.add_vertex(p1)
	drawer.add_vertex(p2)
	drawer.add_vertex(p2)
	drawer.add_vertex(p3)
	drawer.add_vertex(p3)
	drawer.add_vertex(p4)
	drawer.add_vertex(p4)
	drawer.add_vertex(p1)


func _get_hit_point(mpos):
	""" Convert screen space coordinate to world space and raycast
	to find a world space hit point.
	"""
	# source: https://godotengine.org/qa/12665/resolved-move-a-3d-object-with-the-mouse-pos
	# Get the camera (just an example)
	var camera = get_node("Camera")

    # Project mouse into a 3D ray
	var ray_origin = camera.project_ray_origin(mpos)
	var ray_direction = camera.project_ray_normal(mpos)

	# Cast a ray
	var from = ray_origin
	var to = ray_origin + ray_direction * 1000.0
	var space_state = get_world().get_direct_space_state()
	var hit = space_state.intersect_ray(from, to)
	if hit.size() != 0:
		return hit.position
	return Vector2()

