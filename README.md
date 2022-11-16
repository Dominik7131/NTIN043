# Intensive care unit
## Zadání

topic: algebraic specifications in Maude

deadline: 23.11.2022


===================
* task 1: create algebraic specification of a control system at intensive care unit (ICU)
	- what you should capture in your model (specification, prototype):
		many dynamic characteristics (properties) of a human body (physiology) are continuously monitored (heart rate, blood pressure, temperature, breathing frequency, neural/brain signals, etc)
		in case of a problem observed by some of the sensors and monitors, the control system quickly decides that some machine will respond by some action (for example, the dropper will immediately start to deliver more fluid of some kind)
	- general principle: the control system of ICU receives inputs from various sensors, produces some outputs (reports), and performs certain actions

* task 2: document your solution
	- explain key decisions and high-level design

* task 3: prepare some test cases (scenarios, inputs)
	- common scenarios that may occur in a real hospital




===================

## Řešení

### Vysvětlení klíčových rozhodnutí
Pracoval jsem s následujícími podmínkami:
- každá nemocnice může mít libovolný počet ICU
- každá ICU má právě jeden kontrolní systém (control system) pro každého pacienta, u kterého má uložené údaje a parametry relevantní pro nastavování hranic měřených parametrů, ve kterých se má zdravý pacient pohybovat
- každý kontrolní systém se skládá z libovolného počtu monitorů
- monitor = jednotka zajišťující právě jednu životní funkci (Př.: jeden monitor pro tep srdce, jeden monitor pro tlak krve atd.), a proto se s ostatními monitory nedělí o své podpůrné stroje (supply machines)
- monitor se skládá z libovolného počtu senzorů a podpůrných strojů (díky tomu lze flexibilně vytvořit kontrolní systém přesně na míru pro každého pacienta)
- každý senzor snímá právě jednu veličinu (při snímání více veličin by se výstup rozdělil na jednotlivé veličiny)
- každý senzor poskytuje naměřenou informaci právě jednomu monitoru (jinak by zbytečně dva monitory ukazovaly to samé)


### High-level design
- základní třídy: ICU, Control system, Monitor, Sensor, Supply machine a Pacient
- proto řešení je rozděleno do 7 souborů: [icu.maude](icu.maude), [control-system.maude](control-system.maude), [monitor.maude](monitor.maude), [sensor.maude](sensor.maude), [supply-machine.maude](supply-machine.maude), [patient.maude](patient.maude), [test.maude](test.maude)

### ICU
* `IcuID` - identifikátor jednotky intenzivní péče
* `IcuName` - název jednotky intenzivní péče
* `List{ControlSystem}` - seznam spravovaných kontrolních systémů danou jednotkou intenzivní péče

### Control system
* `CSystemID` - identifikátor kontrolního systému
* `CSystemName` - název kontrolního systému
* `Patient` - pacient, o kterého se daný kontrolní systém stará
* `LIST{Monitor}` - seznam monitorů reprezentující seznam hlídaných životných funkcí

### Monitor
* `MonitorID` - identifikátor monitoru
* `MonitorName` - název monitoru (Př.: "Oxygen level monitor")
* `List{Sensor}` - seznam senzorů měřících nějakou veličinu dané životní funkce
* `List{SupplyMachine}` - seznam podpůrných strojů dodávajících látky k zachování dané životní funkce
* (`Status` - aktuální stav dané životní funkce pacienta (`safe`, nebo `critical`))

### Supply machine
* `SMachineID` - identifikátor podpůrného stroje
* `SMachineName` - název podpůrného stroje (Př.: "Oxygen supply machine")
* `SuppliedUnitsSafe` - počet jednotek dodávaných při bezpečném (`safe`) stavu pacienta
* `SuppliedUnitsCritical` - počet jednotek dodávaných při kritickém (`critical`) stavu pacienta
* `SuppliedUnits` - aktuální počet dodávaných jednotek pacientovi


### Sensor
* `SensorID` - identifikátor senzoru
* `SensorName` - název senzoru (Př.: "Oxygen level sensor")
* `MinBound` - minimální hranice, která nesmí být pro bezpečný stav pacienta překročena
* `MaxBound` - maximální hranice, která nesmí být pro bezpečný stav pacienta překročena
* `MeasuredValue` - aktuální naměřená hodnota


### Patient
* `PatientID` - rodné číslo pacienta
* `PatientName` - jméno pacienta
* `PatientAge` - věk pacienta



### Obecný princip
Obecný princip, který je vyžadován v zadání funguje následovně:
- každý senzor obsahuje hranice, ve kterých by se měla naměřená hodnota pohybovat
- operace `checkMonitors` zkontroluje senzory a podle naměřených hodnot nastaví stav každého monitoru (`safe` / `critical`)
- kontrolní systém zkontroluje stav každého monitoru a reaguje provedením určité akce na každém podpůrném stroji, který je spojen s daným monitorem


### Používaná konvence při psaní kódu
- operátory (`ops`): camelCase začínající malým písmenem
- typy (`sorts`): CamelCase začínající velkým písmenem
- funkční moduly (`fmods`) a proměnné (`vars`): obsahují pouze velká písmena (proměnné končící jedničkou = zdroj (source), proměnná končící dvojkou = cíl (target))


### Test
- testový soubor se načítá příkazem `maude test.maude`
- jednotlivé operace jsou spouštěny příkazy ve tvaru `rew "operace" .`, tedy například (`rew testICU1 .`)
- v souboru je podrobně popsáno, jakým způsobem lze postupovat, když nemocnice obdrží nového pacienta ve vážném stavu
- potom následuje přehled užitečných operací a krátký přehled kontroly chyb
