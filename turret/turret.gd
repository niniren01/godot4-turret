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
@export var min_elevation_deg := -10.0
@export var max_elevation_deg := 30.0

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


func rotate_and_elevate(delta: float, target_pos: Vector3) -> void:

	# 投影到水平面
	var rotation_target :Vector3 = Plane(body.global_basis.y).project(target_pos - body.global_position)
	rotation_target = rotation_target + body.global_position
	# 更新指示器
	rotation_projection.global_position = rotation_target
	
	# 计算面朝方向和目标方向的夹角（弧度）
	var body_forward_dir := -body.global_basis.z.normalized()
	var rotate_dir := (rotation_target - body.global_position).normalized()
	var rotate_axis := body.global_basis.y.normalized()
	var rotate_angle_diff := body_forward_dir.signed_angle_to(rotate_dir, rotate_axis)
	
	# 水平旋转
	var rotate_amount = clamp(rotate_angle_diff, -rotation_speed * delta, rotation_speed * delta)
	body.rotate_y(rotate_amount)
	
	#------------------------------------------------------------------------------------------------------
	# 投影到垂直面
	var elevation_target :Vector3 = Plane(head.global_basis.x).project(target_pos - head.global_position)
	elevation_target = elevation_target + head.global_position
	# 更新指示器
	elevation_projection.global_position = elevation_target
	
	# 计算夹角
	var head_forward_dir := -head.global_basis.z.normalized()
	var elevate_dir := (elevation_target - head.global_position).normalized()
	var elevate_axis := head.global_basis.x.normalized()
	var elevate_angle_diff := head_forward_dir.signed_angle_to(elevate_dir, elevate_axis)
	
	# 垂直旋转
	var elevate_amount = clamp(elevate_angle_diff, -elevation_speed * delta, elevation_speed * delta)
	head.rotate_x(elevate_amount)
	head.rotation.x = clamp(head.rotation.x, min_elevation, max_elevation)
