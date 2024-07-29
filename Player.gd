extends KinematicBody2D

enum states {
	normal,jumping,dive,rolling,cooking,dead
}
var state = states.normal setget ChageState

export(Curve) var acceleration_curve = Curve.new()


export var Stress : int = int(90) setget StressSetGet

# warning-ignore:unused_signal
signal dove
# warning-ignore:unused_signal
signal death

var speed := 450

var acceleration : float = 1.0

var velocity : Vector2 = Vector2.ZERO

var move_velocity : Vector2 = Vector2.ZERO
var push_velocity : Vector2 = Vector2.ZERO

export var jump_height : float
export var jump_time_to_peak : float
export var jump_time_to_descent : float

onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
onready var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0

onready var AccelerationTimer = $AccelerationTimer

onready var JumpGraceTimer = $JumpGraceTimer

var YAxis = 0

var input_m : Vector2 = Vector2.ZERO
var move_input : Vector2 = Vector2(0.0,0.01).normalized()
func _process(delta):
	if !is_on_floor():
		YAxis += get_gravity() * delta
		
		if state == states.jumping:
			ChageState(states.normal)
	else:
		YAxis = min(YAxis,1)
	match state:
		states.normal:
			movement()
		states.jumping:
			accelerate()
			move_input = move()
			movement()
		states.dive:
			movement()
			if is_on_floor():
				ChageState(states.rolling)
		states.rolling:
			movement()
		states.cooking:
			pass
	on_process(delta)
	
	move_velocity = move_and_slide(lerp(move_velocity,Vector2((velocity+(push_velocity*30)).x , YAxis),0.7) , Vector2.UP )

var flipPos = Vector2.ZERO
func on_process(delta):
	if state == states.dead:return
	
	if YAxis > 0 and !is_on_floor():
		$AnimationPlayer/AnimationTree["parameters/playback"].travel("fall")
	
	if Vector2(velocity.x,0).length() > 30 and (state == states.normal):
		$AnimationPlayer/AnimationTree["parameters/playback"].travel("Run")
	elif is_on_floor()  and (state == states.normal):
		$AnimationPlayer/AnimationTree["parameters/playback"].travel("idel")
	
	if YAxis < 0 and state == states.jumping:
		$AnimationPlayer/AnimationTree["parameters/playback"].travel("jump")
	
	if state == states.dive:
		$AnimationPlayer/AnimationTree["parameters/playback"].travel("roll")
	
	if state == states.rolling:
		$AnimationPlayer/AnimationTree["parameters/playback"].travel("dive")
	
	push_velocity = lerp(push_velocity,Vector2.ZERO,0.8)
	
	if Vector2(velocity.x,0).length() > 30:
		flipPos = global_position - velocity
	if flipPos.x >= global_position.x:
		$CollisionShape2D.scale.x = 1
		$SpriteParent.scale.x = lerp($SpriteParent.scale.x,1,0.5)
	else:
		$CollisionShape2D.scale.x = -1
		$SpriteParent.scale.x = lerp($SpriteParent.scale.x,-1,0.5)
	
	
	
	if !$JumpGraceTimer.is_stopped():
		if_can_jump()
	
	if !(is_on_floor() or is_on_wall()):
		last_on_foor_wall += delta
	else:
		last_on_foor_wall = 0.0
		jumpcount = 0
	if !(is_on_wall()):
		last_on_wall += delta
	else:
		last_on_wall = 0.0

func _ready():
	Global.player = self
	var _x = Global.connect("players_ingredients_set",self,"on_players_ingredients_set")
	_x = Global.connect("order_set",self,"on_order_set") 
func get_gravity() -> float:
	return jump_gravity if velocity.y < 0.0 else fall_gravity

func jump(jump_scale := 1.0):
	jumpcount += 1
	ChageState(states.jumping)
	YAxis = jump_velocity * jump_scale

func ChageState(set):
	if set == states.dive:
		if_can_jump(true)
		move_velocity.x *= 1.25
	if set == states.cooking:
		velocity = Vector2.ZERO
		$AnimationPlayer/AnimationTree["parameters/playback"].travel("idel")
		pause_mode = Node.PAUSE_MODE_STOP
	state = set 

var jumpcount
var  last_on_wall := 0.0
var  last_on_foor_wall := 0.0
func _unhandled_input(_event):
	if state == states.dead:return
	if Input.is_action_just_pressed("jump") and state != states.cooking:
		if state != states.jumping and !(YAxis > 0 and !is_on_floor()) and state != states.dive: 
			if_can_jump()
		elif jumpcount <= 1:
			ChageState(states.dive)
	if Input.is_action_just_pressed("ui_down") and state != states.cooking:
		$TaskArea2D.set_deferred("scale",Vector2(1,1))
		$TaskArea2D/CollisionShape2D.set_deferred("disabled",false)
	else:
		$TaskArea2D.set_deferred("scale",Vector2(0,0))
		$TaskArea2D/CollisionShape2D.set_deferred("disabled",true)

func movement(x := 0.65):
	accelerate()
	move_input = move()
	
	if move_input != Vector2.ZERO:
		velocity = lerp(velocity,move_input*(speed*acceleration),0.5)
	else:
		velocity = lerp(velocity,Vector2.ZERO,0.85)
	
	velocity = (lerp(move_velocity,(move_velocity+velocity)/2,x))

var used_move_input = Vector2.ZERO

func move():
	input_m = Vector2(sign(int(Input.get_action_strength("ui_right"))-int(Input.get_action_strength("ui_left"))),0).normalized()
	if input_m != Vector2.ZERO and move_input != Vector2.ZERO:
		return move_input.slerp(input_m,0.6)
	else:
		return input_m

func accelerate(force := false):
	var x = 0
	if acceleration > 1:
		acceleration = lerp(acceleration,1,0.01)
	if acceleration < 1 and (move_input != Vector2.ZERO or force):
		if AccelerationTimer.is_stopped() and acceleration < 1 :AccelerationTimer.start()
		x = ((AccelerationTimer.wait_time-AccelerationTimer.time_left)/AccelerationTimer.wait_time) 
		if acceleration < acceleration_curve.interpolate(x):
			acceleration = acceleration_curve.interpolate(x)
	if move_input == Vector2.ZERO and !force:
		if !AccelerationTimer.is_stopped():AccelerationTimer.stop()
		acceleration = lerp(acceleration,0,0.03)

func if_can_jump(can := false):
	if (last_on_foor_wall < 0.2) or can:
		if last_on_wall < 0.2:
			jump(1.25)
			acceleration = 1.25
			var moveX = (Vector2(velocity.x,0).normalized().x)
			if moveX == 1 or moveX == -1:
				if get_node(str(moveX)).is_colliding():
					move_velocity = Vector2(1500*-moveX,move_velocity.y)
		else:
			jump()
		JumpGraceTimer.stop()
	elif JumpGraceTimer.is_stopped():
		JumpGraceTimer.start()

func StressSetGet(set):
	Stress = set


func _on_Player_dove():
	ChageState(states.normal)


func _on_TaskArea2D_area_entered(area):
	if area.is_in_group("Task"):
		area.get_parent().activate()
		ChageState(states.cooking)

func on_players_ingredients_set():
	for kids in $Control/GridContainer.get_children():
		kids.queue_free()
	for pngs in Global.players_ingredients:
		var sprite = TextureRect.new()
		sprite.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		sprite.size_flags_vertical = Control.SIZE_EXPAND_FILL
		sprite.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT
		sprite.expand = true
		sprite.texture = load(pngs)
		$Control/GridContainer.call_deferred("add_child",sprite)

func on_order_set():
	for kids in $CanvasLayer/Control/GridContainer.get_children():
		kids.queue_free()
	for pngs in Global.order:
		var sprite = TextureRect.new()
		sprite.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		sprite.size_flags_vertical = Control.SIZE_EXPAND_FILL
		sprite.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT
		sprite.expand = true
		sprite.texture = load(pngs)
		$CanvasLayer/Control/GridContainer.call_deferred("add_child",sprite)
