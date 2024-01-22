extends Area2D

@export var speed = 400 # How fast the player will move (pixels/sec).
@export var health = 100
var screen_size # Size of the game window.

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$AnimatedSprite2D.play()
	if health <= 0:
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
	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
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
	

func _on_body_entered(body):
	take_damage(10)
