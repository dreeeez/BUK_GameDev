extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -700.0
var JUMP = false
var timer = Timer.new()

func _on_timer_timeout_funcname():
	print(timer.get_time_left())
	velocity.y = JUMP_VELOCITY * (1-timer.get_time_left())
	var direction = Input.get_axis("ui_left", "ui_right")
	velocity.x = direction * SPEED
	JUMP = false
	timer.stop()

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _init():
	timer.one_shot = true # don't loop, run once
	timer.autostart = false # start timer when added to a scene
	timer.connect("timeout", _on_timer_timeout_funcname)
	add_child(timer)
	

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		JUMP = true
		timer.start(1.0)
	elif Input.is_action_just_released("ui_accept") && JUMP:
		_on_timer_timeout_funcname() 
		#timer.stop()
		#timer.emit_signal("timeout")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction && is_on_floor() && not JUMP:
		velocity.x = direction * SPEED
	elif is_on_floor():
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
