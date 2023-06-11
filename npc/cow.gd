extends CharacterBody2D

enum COW_STATE { IDLE, WALK}
@export var move_speed : float = 20
@export var idle_time : float = 5
@export var walking_time : float = 2

@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")
@onready var timer = $Timer
@onready var sprite = $Sprite2D


var move_direction : Vector2 = Vector2.ZERO
var current_state : COW_STATE  = COW_STATE.IDLE

func _ready():
	timer.start(idle_time)
	
func _physics_process(_delta):
	if(current_state == COW_STATE.WALK):
		velocity = move_direction * move_speed
		move_and_slide()
	
	
func select_new_direction():
	move_direction = Vector2(
		randi_range(-1,1),
		randi_range(-1,1)
	)
	
	if (move_direction.x < 0):
		sprite.scale.x = -1
	elif (move_direction.x > 0):
		sprite.scale.x = 1
	else:
		pass
	
func pick_new_state():
	if(current_state == COW_STATE.IDLE):
		state_machine.travel("walk_right")
		current_state = COW_STATE.WALK
		timer.start(walking_time)
		select_new_direction()
	elif(current_state == COW_STATE.WALK):
		state_machine.travel("idle_right")
		current_state = COW_STATE.IDLE
		timer.start(idle_time)


func _on_timer_timeout():
	pick_new_state()
