extends Character

@export var acceleration: float = 8
@export var deceleration: float = 4
@onready var camera = $CameraController/Camera3D
@onready var skin = $PlayerSkin

func _physics_process(delta: float) -> void:
	move_logic(delta)
	jump_logic(delta)
	move_and_slide()
	
	
func move_logic(delta):
	movement_input = Input.get_vector("left", "right", "forward", "backward").rotated(-camera.global_rotation.y)
	var vel_2d = Vector2(velocity.x, velocity.z)

	if movement_input != Vector2.ZERO:
		vel_2d += movement_input * base_speed * delta * acceleration
		vel_2d = vel_2d.limit_length(base_speed)
		velocity.x = vel_2d.x
		velocity.z = vel_2d.y
		var target_angle = -movement_input.angle() + PI 
		skin.rotation.y = rotate_toward(skin.rotation.y, target_angle, delta * 6)
		set_move_state('Running_A')
		
	else:
		vel_2d = vel_2d.move_toward(Vector2.ZERO, base_speed * delta * deceleration)
		velocity.x = vel_2d.x
		velocity.z = vel_2d.y
		set_move_state('Idle')
		
func jump_logic(delta):
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			velocity.y = -jump_velocity
			set_move_state('Jump_Idle')
		else:
			velocity.y = 0  # Reset velocity.y when on the floor and not jumping
			
	var gravity = jump_gravity if velocity.y > 0.0 else fall_gravity
	apply_gravity(gravity, delta)
