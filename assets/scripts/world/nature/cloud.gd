extends Sprite2D

@onready var main:String = str(get_tree().root.get_child(1).name)
@onready var player:CharacterBody2D = get_node("/root/"+main+"/Player")
@onready var clock:Control = get_node("/root/"+main+"/UI/HUD/GameHud/Main/Bars/Clock")
@onready var shadow:Node = get_node("/root/"+main+"/ShadowManager")
@onready var anim:AnimationPlayer = $Animation
@onready var life:Timer = $LifeCycle

const speed:float = 24.256
const max_distance:int = 500

func _ready():
	life.wait_time = randi_range(2*clock.speed,10*clock.speed)
	life.start()

func _process(delta) -> void:
	position.x += speed * delta
	position.y += speed * delta
	var distance = round(global_position.distance_to(player.global_position))
	if distance > max_distance:
		change_animation(false)

func change_animation(state:bool) -> void:
	if state:
		anim.play("create")
	else:
		anim.play("remove")

func _on_life_cycle_timeout() -> void:
	change_animation(false)

func _life_cycle_end() -> void:
	shadow.all_clouds -= 1
	life.stop()
	remove_child(self)
	queue_free()
