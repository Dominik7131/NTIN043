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
	category: one AccessoryCategory
}

abstract sig AccessoryCategory {}

abstract sig AccessoryValue {}

one sig LightingCategory extends AccessoryCategory {}
one sig SensorCategory extends AccessoryCategory {}
one sig CameraCategory extends AccessoryCategory {}
one sig AlarmCategory extends AccessoryCategory {}
one sig HeaterCategory extends AccessoryCategory {}

sig LightValue extends AccessoryValue {}
sig HeatValue extends AccessoryValue {}

sig Lightbulb extends Accessory {
	lightIntensity : one LightValue
}
sig Heater extends Accessory {
	heatingIntensity : one HeatValue 
}
sig TemperatureSensor extends Accessory {}
sig SmokeSensor extends Accessory {}
sig Camera extends Accessory {}
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
fact {all r1 : Room, r2 : Room | (all a : r1.accessories | a in r2.accessories => r1 = r2) }

// All rooms belong to some house
fact {all r : Room | some h : House | r in h.rooms}

// Every controller belongs to some house
fact {all c : Controller | some h : House | c = h.controller }

// Every accessory is managed by some controller
fact { all a : Accessory | some c : Controller | a in c.managedAccessories }

// Every accessory category belongs to some accessory
fact { all c : AccessoryCategory | some a : Accessory | a.category = c }

// Every light intensity belongs to some lightbulb
fact {all lv : LightValue | some l : Lightbulb | l.lightIntensity = lv}

// Every light intensity belongs to a different lightbulb
fact { all l1 : Lightbulb, l2 : Lightbulb | l1.lightIntensity = l2.lightIntensity =>  l1 = l2 }

// Every heat intensity belongs to some lightbulb
fact {all hv : HeatValue | some h : Heater | h.heatingIntensity = hv}

// Every heat intensity belongs to a different heater
fact { all h1 : Heater, h2 : Heater | h1.heatingIntensity = h2.heatingIntensity =>  h1 = h2 }

// Every lightbulb is in the lighting accessory category
fact { all l : Lightbulb | l.category = LightingCategory }

// Every temperature sensor is in the sensor accessory category
fact { all ts : TemperatureSensor | ts.category = SensorCategory }

// Every smoke sensor is in the sensor accessory category
fact { all ss : SmokeSensor | ss.category = SensorCategory }

// Every camera is in the camera accessory category
fact { all c : Camera | c.category = CameraCategory }

// Every alarm is in the alarm accessory category
fact { all a : Alarm | a.category = AlarmCategory }

// Every heater is in the heater accessory category
fact { all h : Heater| h.category = HeaterCategory }

// Every house has at least one smoke sensor
fact { all h : House | (some a : h.controller.managedAccessories | a in SmokeSensor)  }

// Every house has exactly one alarm
fact { all h : House | (one a : h.controller.managedAccessories | a in Alarm)  }


// ----------------Asserts---------------- //

assert UniqueHouseNames {
	all h1: House, h2: House | h1.name = h2.name => h1 = h2
}

assert UniqueRoomNames {
	all r1: Room, r2: Room | r1.name  = r2.name => r1 = r2
}

assert UniqueControllerNames {
	all c1: Controller, c2: Controller | c1.name = c2.name => c1 = c2
}

assert UniqueAccessoryNames {
	all a1: Accessory, a2: Accessory | a1.name = a2.name => a1 = a2
}

assert OneControllerPerHouse {
	all h: House | #h.controller = 1
}

assert EveryAccessoryInSomeRoom {
	all a : Accessory | some r : Room | a in r.accessories
}

assert HouseHasAtLeastOneRoom {
	all h: House | #h.rooms > 0
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

assert HouseContainsAtLeastOneSmokeSensor {
	all h : House | (some a : h.controller.managedAccessories | a in SmokeSensor)
}

assert HouseContainsExactlyOneAlarm {
	all h : House | (one a : h.controller.managedAccessories | a in Alarm)
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
//check HouseContainsAtLeastOneSmokeSensor for 10
//check HouseContainsExactlyOneAlarm for 10
//check HeaterIsInHeaterCategory for 10


// ----------------Predicates---------------- //

pred addRoom [h: House,  r: Room]  {
	h.rooms = h.rooms + r
}

pred addAccessory [h: House, r: Room, a: Accessory] {
	r.accessories = r.accessories + a
	h.controller.managedAccessories = h.controller.managedAccessories + a 
}


// ----------------Run---------------- //

run addAccessory for 14  but exactly 1 House,  exactly 4 Room, exactly 8 Accessory
