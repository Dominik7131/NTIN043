// ----------------Sigs---------------- //

sig Name {}

sig House {
	name : one Name,
	rooms : some Room,
	controller : one Controller
}

sig Room {
	name : one Name,
	accessories : set Accessory
}

sig Controller {
	name : one Name,
	managedAccessories : set Accessory
}

abstract sig Accessory {
	name : one Name,
	category : one AccessoryCategory,
	state : one State
}

abstract sig AccessoryCategory {}

abstract sig State {}

abstract sig CameraBool {}

one sig LightingCategory extends AccessoryCategory {}
one sig SensorCategory extends AccessoryCategory {}
one sig CameraCategory extends AccessoryCategory {}
one sig AlarmCategory extends AccessoryCategory {}
one sig HeaterCategory extends AccessoryCategory {}

one sig StateOn extends State {}
one sig StateOff extends State {}

one sig True extends CameraBool {}
one sig False extends CameraBool {}

sig Lightbulb extends Accessory {
	lightIntensity : one Int
}
sig TemperatureSensor extends Accessory {
	temperature : one Int
}
sig Camera extends Accessory {
	isMovementDetected : one CameraBool
}
sig Heater extends Accessory {}
sig Alarm extends Accessory {}


// ----------------Facts---------------- //

// All houses have a different name
fact { all h1 : House, h2 : House | h1.name = h2.name =>  h1 = h2 }

// All rooms have a different name
fact { all r1 : Room, r2 : Room | r1.name = r2.name =>  r1 = r2 }

// All cotrollers have a different name
fact { all c1 : Controller, c2 : Controller | c1.name = c2.name =>  c1 = c2 }

// All accessories have a different name
fact { all a1 : Accessory, a2 : Accessory | a1.name = a2.name =>  a1 = a2 }

// All objects have a different name
fact { all h : House | all r : Room | all a : Accessory | all c : Controller |
	h.name != r.name and h.name != a.name and h.name != c.name and
	r.name != a.name and r.name != c.name and a.name != c.name }

// Every accessory belongs to some room
fact { all a : Accessory | some r : Room | a in r.accessories}

// No accessory is in two rooms at the same time
fact { all r1 : Room, r2 : Room | (all a : r1.accessories | a in r2.accessories => r1 = r2)  }

// All rooms belong to some house
fact { all r : Room | some h : House | r in h.rooms }

// Every controller belongs to some house
fact { all c : Controller | some h : House | c = h.controller }

// Every accessory is managed by some controller
fact { all a : Accessory | some c : Controller | a in c.managedAccessories }

// Every State belongs to some accessory
fact { all s : State | some a : Accessory | s in a.state }

// Every CameraBool belongs to some camera
fact { all b : CameraBool | some c : Camera | b in c.isMovementDetected}

// Lightbulb intensity is always a non negative number
fact {all l : Lightbulb | l.lightIntensity > 0}

// Every accessory category belongs to some accessory
fact { all c : AccessoryCategory | some a : Accessory | a.category = c }

// Every lightbulb is in the lighting accessory category
fact { all l : Lightbulb | l.category = LightingCategory }

// Every temperature sensor is in the sensor accessory category
fact { all ts : TemperatureSensor | ts.category = SensorCategory }

// Every camera is in the camera accessory category
fact { all c : Camera | c.category = CameraCategory }

// Every alarm is in the alarm accessory category
fact { all a : Alarm | a.category = AlarmCategory }

// Every heater is in the heater accessory category
fact { all h : Heater| h.category = HeaterCategory }

// Every house has exactly one alarm
fact { all h : House | (one a : h.controller.managedAccessories | a in Alarm)  }

// All cameras are turned on
fact { all c : Camera | c.state = StateOn }

// All temperature sensors are turned on
fact { all ts : TemperatureSensor | ts.state = StateOn }


// ----------------Asserts---------------- //

assert UniqueHouseNames {
	all h1 : House, h2 : House | h1.name = h2.name => h1 = h2
}

assert UniqueRoomNames {
	all r1 : Room, r2 : Room | r1.name  = r2.name => r1 = r2
}

assert UniqueControllerNames {
	all c1 : Controller, c2: Controller | c1.name = c2.name => c1 = c2
}

assert UniqueAccessoryNames {
	all a1 : Accessory, a2: Accessory | a1.name = a2.name => a1 = a2
}

assert OneControllerPerHouse {
	all h : House | #h.controller = 1
}

assert EveryAccessoryInSomeRoom {
	all a : Accessory | some r : Room | a in r.accessories
}

assert HouseHasAtLeastOneRoom {
	all h : House | #h.rooms > 0
}

assert LightbulbIsInLightingCategory {
	all l : Lightbulb | l.category in LightingCategory
}

assert TemperatureSensorIsInSensorCategory {
	all ts : TemperatureSensor | ts.category in SensorCategory
}

assert CameraIsInCameraCategory {
	all c : Camera | c.category in CameraCategory
}

assert HeaterIsInHeaterCategory {
	all h : Heater | h.category in HeaterCategory
}

assert HouseContainsExactlyOneAlarm {
	all h : House | (one a : h.controller.managedAccessories | a in Alarm)
}


// ----------------Predicates---------------- //

// When temperature gets below 1 in a room r, automatically start heating in the room r
// 1 is used as the min threshold here to prevent overflow
pred StartHeating [h1, h2 : Heater, r : Room, ts : TemperatureSensor]  {
	ts.temperature < 1
	h1 in r.accessories and ts in r.accessories
	h2 = h1
	h2.state = StateOn
}

// When temperature in a room r gets above 2, automatically stop heating in the room r
// 2 is used as the max threshold here to prevent overflow
pred StopHeating [h1, h2 : Heater, r : Room, ts : TemperatureSensor]  {
	ts.temperature > 2
	h1 in r.accessories and ts in r.accessories
	h2 = h1
	h2.state = StateOff
}

// If any movements is detected by any camera, turn on alarm
pred TurnOnAlarm [a1, a2 : Alarm, c : Camera]  {
	c.isMovementDetected = True
	a2 = a1
	a1.state = StateOn
}


// ----------------Checks---------------- //

//check UniqueHouseNames for 10
//check UniqueRoomNames for 10
//check UniqueAccessoryNames for 10
//check OneControllerPerHouse for 10
//check EveryAccessoryInSomeRoom for 10
//check HouseHasAtLeastOneRoom for 10
//check LightbulbIsInLightingCategory for 10
//check TemperatureSensorIsInSensorCategory for 10
//check CameraIsInCameraCategory for 10
//check HouseContainsExactlyOneAlarm for 10
//check HeaterIsInHeaterCategory for 10


// ----------------Runs---------------- //

//run StartHeating for 10 but exactly 1 House, 1 Heater, exactly 1 TemperatureSensor
//run StopHeating for 10 but exactly 1 Heater, exactly 1 TemperatureSensor
//run TurnOnAlarm for 10

run {} for 14  but exactly 1 House, exactly 4 Room, exactly 8 Accessory

