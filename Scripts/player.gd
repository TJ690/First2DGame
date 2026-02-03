extends CharacterBody2D

@onready var animated_sprite_2d = $AnimatedSprite2D

const SPEED = 130.0
const JUMP_VELOCITY = -300.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# This will get the input direction -1, 0, 1
	var direction = Input.get_axis("Move_Left", "Move_RIght")
	
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
