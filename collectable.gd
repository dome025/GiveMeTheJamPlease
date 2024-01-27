extends Area2D

var speed = 200
var screen_size
var wait = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if wait >= 5:
		wait -= 1
		return
	if self.name == "Honey" && $AnimatedSprite2D.animation != "idle":
		var scene = load("res://honey_blob.tscn")
		var new_honey_blob = scene.instantiate()
		new_honey_blob.position = self.position
		get_parent().add_child(new_honey_blob)
		new_honey_blob.set_name("HoneyBlob")
	if self.name == "Butters" && $AnimatedSprite2D.animation != "idle":
		var scene = load("res://butter_blob.tscn")
		var new_honey_blob = scene.instantiate()
		new_honey_blob.position = self.position
		get_parent().add_child(new_honey_blob)
		new_honey_blob.set_name("ButterBlob")
	if self.name == "Raspby" && $AnimatedSprite2D.animation != "idle":
		var scene = load("res://raspberry_blob.tscn")
		var new_honey_blob = scene.instantiate()
		new_honey_blob.position = self.position
		get_parent().add_child(new_honey_blob)
		new_honey_blob.set_name("RaspberryBlob")
	wait = 60
	pass

func _on_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	#print("Hello")
	#print(area.name)
	if area.name == "Player":
		queue_free()

func escape(player_position: Vector2, delta):
	$AnimatedSprite2D.play()
	var velocity = Vector2.ZERO
	
	var x_distance = self.position.x - player_position.x
	var y_distance = self.position.y - player_position.y
	var abs_x_distance = abs(x_distance)
	var abs_y_distance = abs(y_distance)
	if abs_x_distance > 200 || abs_y_distance > 200:
		$AnimatedSprite2D.animation = "idle"
		return
	if abs_x_distance < abs_y_distance:
		if y_distance > 0:
			velocity.y += 1
		else:
			velocity.y -= 1
	else:
		if x_distance > 0:
			velocity.x += 1
		else:
			velocity.x -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	else:
		$AnimatedSprite2D.animation = "idle"
		
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "running_sideway"
		$AnimatedSprite2D.flip_v = false
		# See the note below about boolean assignment.
		$AnimatedSprite2D.flip_h = velocity.x > 0
	if velocity.y > 0:
		$AnimatedSprite2D.animation = "running_downway"
	elif velocity.y < 0:
		$AnimatedSprite2D.animation = "running_upway"
	
	position += velocity * delta
	#position = position.clamp(Vector2.ZERO, screen_size)
