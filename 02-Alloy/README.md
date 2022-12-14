# Smart home

- řešení je v souboru [SmartHome.als](SmartHome.als)
- použil jsem Alloy ve verzi 6.1.0


## Základní popis řešení
- každý dům (`House`) obsahuje právě jeden kontroler (`Controller`), který řídí všechny chytré doplňky (`Accessory`) v daném domě
- každý dům obsahuje alespoň jednu místnost (`Room`)
- každý dům, pokoj, kontroler a doplněk je jednoznačně určen svým jménem
- podrobnější popis viz komentáře v kódu u definic faktů

## High-level design
- řešení obsahuje tyto základní signatury:

### House
- `name` - identifikační název daného domu
- `rooms` - neprázdná množina pokojů v daném domě
- `controller` - jednotka spravující všechny chytré doplňky v daném domě

### Room
- `name` - identifikační název daného pokoje
- `accessories` - množina chytrých doplňků obsažena v daném pokoji

### Controller
- `name` - identifikační název daného kontrolního zařízení
- `managedAccessories` - množina všech doplňků spravovaných daným kontrolním zařízením

### Accessory
- `name` - identifikační název daného chytrého doplňku
- `state` - aktuální stav daného chytrého doplňku (`StateOn` / `StateOff`)
- `category` - do jaké kategorie doplňků spadá (Př.: tepelný senzor spadá do kategorie `SensorCategory`)

    - seznam všech definovaných kategorií: `LightingCategory`, `SensorCategory`, `CameraCategory`, `AlarmCategory`, `HeaterCategory`
- některé doplňky mohou navíc obsahovat nějakou hodnotu (Př.: tepelný senzor obsahuje teplotu pokoje, ve kterém se nachází)


## Pokročilé použití alloy
- pro částečné ověření základních invariantů našeho modelu používáme několik assertů a odpovídajících checků
- model obsahuje i tři operace pro zachycení jeho dynamického chování
	- `StartHeating` - pokud v pokoji, ve kterém je tepelný senzor a zároveň topení, klesne teplota pod vymezenou hodnotu, automaticky se spustí topení
	- `StopHeating` - jako `StartHeating`, ale naopak, když se teplota dostane nad vymezenou hodnotu, automaticky se vypne topení
	- `TurnOnAlarm` - když libovolná kamera zachytí pohyb, spustí se alarm
