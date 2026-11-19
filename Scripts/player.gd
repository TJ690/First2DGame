extends CharacterBody2D

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var LadderDetection: RayCast2D = $LadderDetection
const SPEED = 130.0
const JUMP_VELOCITY = -300.0

const FLOAT_GRAVITY_MULTIPLIER = 0.2
const MAX_FLOAT_FALL_SPEED = 40.0

var _on_ladder : bool = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):

	var grounded = is_on_floor()
	# Add the gravity.
	if not is_on_floor():
		var current_gravity = gravity
		
		# Float: holding jump while falling
		if Input.is_action_pressed("ui_accept") and velocity.y > 0:
			current_gravity = gravity * FLOAT_GRAVITY_MULTIPLIER
			velocity.y = min(velocity.y, MAX_FLOAT_FALL_SPEED)
		
		velocity.y += current_gravity * delta
		
	# This will get the input direction -1, 0, 1
	var direction = Input.get_axis("Move_Left", "Move_RIght")
	
	# Handle jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	
	#Flip the Sprite
	if direction > 0:
		animated_sprite_2d.flip_h = false
	elif  direction < 0:
		animated_sprite_2d.flip_h = true
		
	#Play Animations
	if is_on_floor():
		if direction == 0:
			animated_sprite_2d.play("Idle")
		else:
			animated_sprite_2d.play("run")
	
	else:
		animated_sprite_2d.play("Jump")

	
	#This applies movement to character
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	

