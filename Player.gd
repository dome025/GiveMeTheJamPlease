extends Area2D

@export var speed = 400 # How fast the player will move (pixels/sec).
@export var health = 100
var screen_size # Size of the game window.
var last_velocity = Vector2.ZERO
var slippery = false
var stuck = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$AnimatedSprite2D.play()
	if stuck > 0:
		stuck -= 1
		$AnimatedSprite2D.stop()
		return
	var velocity = Vector2.ZERO # The player's movement vector.
	
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	else:
		$AnimatedSprite2D.animation = "idle"
	
	if slippery:
		velocity = last_velocity
		$AnimatedSprite2D.stop()
	position += velocity * delta
	last_velocity = velocity
	#position = position.clamp(Vector2.ZERO, screen_size)
	
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "running_sideway"
		$AnimatedSprite2D.flip_v = false
		# See the note below about boolean assignment.
		$AnimatedSprite2D.flip_h = velocity.x > 0
	if velocity.y > 0:
		$AnimatedSprite2D.animation = "running_downway"
	elif velocity.y < 0:
		$AnimatedSprite2D.animation = "running_upway"

func take_damage(damage: float):
	if health > 0:
		health -= damage;
	if health <= 0:
		$AnimatedSprite2D.stop()
	

func _on_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	if "HoneyBlob" in area.name:
		stuck = 30
	if "ButterBlob" in area.name:
		slippery = true
		speed = 500
	if "RaspberryBlob" in area.name:
		speed = 200
	#print(area)
	#print(area_rid)
	#print(area_shape_index)
	#print(local_shape_index)
	take_damage(10)
	pass # Replace with function body.


func _on_area_shape_exited(area_rid, area, area_shape_index, local_shape_index):
	if area == null:
		return
	if "HoneyBlob" in area.name:
		speed = 400
	if "ButterBlob" in area.name:
		slippery = false
		speed = 400
	if "RaspberryBlob" in area.name:
		speed = 400
	pass # Replace with function body.
