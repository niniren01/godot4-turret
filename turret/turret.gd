extends Node3D

# 2个平面上的投影
@onready var rotation_projection: Node3D = $rotation_projection
@onready var elevation_projection: Node3D = $elevation_projection


@onready var body: MeshInstance3D = $Body
@onready var head: Node3D = $Body/Head

# 目标
@export var target : Node3D

# 转动速度（角度）
@export var elevation_speed_deg := 5.0
@export var rotation_speed_deg := 5.0

# 最大俯仰角（角度）
@export var min_elevation_deg := 0.0
@export var max_elevation_deg := 60.0

# 转动速度（角度）、最大俯仰角（角度）转换为弧度
@onready var elevation_speed := deg_to_rad(elevation_speed_deg)
@onready var rotation_speed := deg_to_rad(rotation_speed_deg)
@onready var min_elevation := deg_to_rad(min_elevation_deg)
@onready var max_elevation := deg_to_rad(max_elevation_deg)

var active := true


func _ready() -> void:
	
	# 头，身体，目标，其中有一个为空，关闭炮台
	if head == null or body == null or target == null:
		active = false


func _physics_process(delta: float) -> void:
	#  如果处于关闭状态，什么都不干
	if not active:
		return
	
	# 指向目标点
	rotate_and_elevate(delta, target.global_position)


func rotate_and_elevate(delta: float, target_g_pos: Vector3) -> void:
	# 投影到XZ平面
	# 目标位置 - 炮身位置，得到一个由炮身指向目标的向量
	var rotation_targ := get_projected(target_g_pos - body.global_position, body.global_basis.y)


func get_projected(pos: Vector3, normal: Vector3) -> Vector3:
	
