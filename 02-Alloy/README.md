# Smart home

- řešení je v souboru [SmartHome.als](SmartHome.als)


## Základní popis řešení
- každý dům (`House`) obsahuje právě jeden kontroler (`Controller`), který řídí všechny chytré doplňky (`Accessory`) v daném domě
- každý dům obsahuje alespoň jednu místnost (`Room`)
- každý dům, pokoj, kontroler a doplněk je jednoznačně určen svým jménem
- podrobnější popis viz komentáře v kódu u definic faktů

## High-level design
řešení obsahuje tyto základní signatury:

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
- `category` - do jaké kategorie doplňků spadá (Př.: kouřový detektor spadá do kategorie SensorCategory)

    - seznam všech definovaných kategorií: `LightingCategory`, `SensorCategory`, `CameraCategory`, `AlarmCategory`, `HeaterCategory`
- některé doplňky mohou navíc obsahovat nějakou hodnotu (Př.: tepelné těleso obsahuje teplotu, na kterou daný pokoj vytápí)


## Pokročilé použití alloy
- pro částečné ověření základních invariantů našeho modelu používáme několik assertů a odpovídajících checků
- model obsahuje i dvě operace, které mění jeho stav: přidání nového pokoje (predikát `addRoom`) a přidání nového chytrého doplňku (predikát `addAccessory`)

