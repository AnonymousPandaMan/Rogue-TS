extends State

class_name UnitState 

const IDLE = "Idle"
const MOVING = "Moving"
const ATTACKING = "Attacking"
const FROZEN = "Frozen"
const PRODUCING = "Producing"
const MOVETOATTACK = "MoveToAttack"
const ATTACKMOVE = "AttackMove"
const CONSTRUCTING = "Constructing"
const BUILDING = "Building"
const HARVESTING = "Harvesting"
const MOVETOHARVEST = "MoveToHarvest"
const MOVETOBUILD = "MoveToBuild"
const STARTCONSTRUCTION = "StartConstruction"

var unit: Unit

func _ready() -> void:
	await owner.ready
	unit = owner as Unit
	assert(unit != null, "The UnitState state type must be used only in the unit scene. It needs the owner to be a Unit node.")
