# Battle Pong

Battle Pong baut auf dem klassischen Zwei-Spieler Pong auf.\
Allerdings soll es möglich sein die menschlichen Spieler durch Reinforcement Algorithmen zu ersetzen.
Zudem sollen die Algorithmen von den menschlichen Spielern lernen können.
Die Datenübertragung wird per Websockets realisiert und die Daten sind in JSON kodiert.
Die Schnittstelle in Python ist an der [Gym API](https://gym.openai.com/) orientiert, um den Einstieg und die Nutzung möglichst einfach zu gestalten. 


## Lernvarianten


- **learn with position**\
    Es werden die aktuelle Position von Spielern und Ball ausgegeben, sowie der Bewegungsvektor des Balls.

- **learn with images**\
    Nach jedem Spielschritt wird das angezeigt Bild aufgenommen, verkleinert und entweder in RGB8 oder S/W umgewandelt, bevor es ausgegeben wird.

- **Training**\
    In diesem Modus wird einer der Spieler (es können auch beide gleichzeitig trainiert werden) über die Tastatur gesteuert und die Eingabe während der Spielschritte zuzüglich Bild / Positionsangaben übertragen


# Installationsanleitung

## Godot

1. Repository als zip Downloaden 
    * Master Branch für den aktuellsten Stand
    * Release, für stabile und getestete Version
2. Archiv entpacken und in das gewünschte Projektverzeichnis kopieren
3. Download der aktuellen [Godot Engine](https://godotengine.org/) (Windows - Standard version, 64-Bit)
4. Entpacken des zip-Archivs
5. Ausführen der Anwendung 
6. Im Projekt Manager auf **Import** klicken 
    * "Project Path:" =>  "Entpacktes battle-pong Projektverzeichnis/Battle Pong/project.godot" auswählen
7. **Import & Edit** klicken

## Python

1. Ordner BattlePongAI in beliebiger IDE öffnen
2. imports installieren

## Test

1. Battle-Pong in Godot starten
2. Haken bei **Enable rendering** setzen
3. **2 RE with Position** klicken
4. BattlePongAI main.py starten
5. BattlePongAI main_player_two.py starten\
=> Das Spiel wird gestartet und die beiden RoboCats (Default-Agents in Python) spielen gegeneinander.\
    Dadurch, dass das Rendern eingeschaltet wurde, kann das Spiel beobachtet werden.



# Nutzungsanleitung

## Godot

### **Spiel Starten**
Sobald das Projekt im Godot Projektmanager imortiert und gestartet wurde, kann das Spiel mit einem Klick auf den  **Play Button** oder Drücken der **F5 Taste** gestartet werden. Zu Beginn wird das Hauptmenü angezeigt, in welchem der Spielmodus ausgewählt wird und das **Settings Window** aufgerufen werden kann, wo verschiedene Einstellungen für das Spiel hinterlegt sind. 

### Spielmodi

* **Local 2 Player**\
Spieler 1 und Spieler 2 werden über die Tastatur gesteuert. Der Websocket-Server wird nicht gestartet.
    * Spieler 1:\
    Hoch => **W Taste**\
    Runter => **S Taste**
    * Spieler 2:\
    Hoch => **Pfeiltaste Hoch**\
    Runter => **Pfeiltaste Runter**
* **2 RE with Images**\
Nach jedem Spielschritt wird ein "Screenshot" des Spiels erstellt, verkleinert, konvertiert (RGB8/SW8) und mit an die Agenten übertragen.
* **2 RE with Position**\
Es werden die Positionen der Spieler, des Balls, sowie der Bewegungsvektor des Balls an die Agenten übertragen
    * Enable rendering\
    Ist standartmäßig ausgeschaltet, da das Rendern für diesen Modus nicht erforderlich ist und das Spiel ohne Rendern **erheblich schneller** läuft!
* **RE Trainer**\
Wenn ein Agent im Trainingsmodus ist wird der ensprechende Spieler über die Tastatur gesteuert und dem Agenten wird diese Eingabe anschließend geschickt. Dadurch kann der aktuellen Situation eine "sinnvolle" Reaktion/Step zugeordnet werden, woraus der Agent dann lernen kann.

* **Game Modifier**\
Optionen mit denen das Spiel verändert werden kann, um neue Herausvorderungen zu schaffen.
    * Obstacles:\
    ON => Ein vertikaler Block bewegt sich in der Mitte von Oben nach Unten. Sobald Er den den unteren Bildschrimrand verlassen hat beginnt Er wieder oben. 

### **Spieleinstellungen**
In dem **Settings Window** können allgemeine Einstellungen, Geschwindigkeit und Bildausgabe angepasst werden
* Game:
    * Playtime/Step (Seconds):\
    Dauer eines Spielschrittes.\
    Sinnvoll sind Werte zwischen 0,1 - 0,001 Sekunden.
    * Wins till end:\
    Siege die benötigt werden, bis das Spiel zurückgesetzt wird.
    * Port:\
    Portangabe, über den der Websocket-Server angesprochen werden kann
* Image: (Spielmodus **Learn with Images**)
    * Output RGB8:\
    Off =>  Bild wird in SW8 konvertiert (farbig)\
    On =>   Bild wird in RGB8 konvertiert (Graustufen)\
    Details unter [Godot Image Convert Funktion](https://docs.godotengine.org/en/stable/classes/class_image.html?highlight=rgb8#class-image-method-convert) und deren [Formate](https://docs.godotengine.org/en/stable/classes/class_image.html?highlight=rgb8#enum-image-format)
    * Height:\
    Höhe des übertragenen Bildes in Pixel
    * Width:\
    Breite des übertragenen Bildes in Pixel
* Trainer: (Spielmodus **Trainer**)
    * Use realtime:\
    ON => Es wird bei jedem Spielschritt die Anzahl an Sekunden gewartet, welche unter **Playtime/Step** eingestellt ist. Die tatsächliche Spielzeit entspricht der realen Zeit.\
    OFF => Sobald beide beide Spieler per Websocket ihre Befehle erhalten haben wird der Spielschritt ausgeführt und das Ergebnis zurückgesendet.\
    **Achtung:** Es kann je nach eingestellter Schrittzeit zu einer enormen Geschwindigkeitserhöhung führen, wenn realtime ausgeschaltet ist, da die Spielzeit von der ingame Zeit entkoppelt ist und die tatsächliche Dauer eines Spielschritts nur noch von der Kommunikation und internen Berechnungen abhängt.
* Ball:
    * Speed Min:\
    Geschwindigkeitsfaktor, mit dem der Ball zu Rundenbeginn beschleunigt wird
    * Speed Max:\
    Maximaler Geschwindigkeitsfactor
    * Speed Increment:\
    Konstante um die der aktuelle Geschwindigkeitsfaktor des Balls erhöht wird, sobald Dieser einen Spieler berührt. 
* Player 1:
    * Speed:\
    Geschwindigkeitsfaktor von Spieler 1 (links)
* Player 2:
    * Speed:\
    Geschwindigkeitsfaktor von Spieler 2 (rechts)
* **Save**\
Speichert die Einstellungen in data.json und wechselt zum Hauptmenü
* **Cancel**\
Verwirft nicht gespeicherte Änderungen und geht zurück zum Hauptmenü
* **Reset**\
Lädt die im Code hinterlegten Standartwerte, speichert Sie jedoch nicht
        


## Python
Der Pythoncode enthält die Client-Seite der API (gym.py) welche die Kommunikation mit Godot regelt. Dabei steht ein Enum mit den möglichen Schritten bereit und es werden die übertragenen Daten interpretiert.

### Klassen main / main_player_two
In beiden Klassen sind default Agenten implementiert (RoboCat) welche versuchen die aktuelle Höhe des Balls zu halten.\
"main.py" steuert den Spieler 1 und "main_player_two.py" steuert Spieler 2. \
"main.py" initialisiert das Spiel und beide Spieler laden sich zu beginn die "Start"-Observation. Anschließend versuchen beide Spieler die Höhe des Balls zu halten.\
In "main.py" ist zudem beispielhaft implementiert wie das übertragene Bild geladen wird. Um es direkt anzeigen zulassen muss in der Funktion show_image() die Zeile *image.show()* einkommentiert werden.

### Klasse Gym
Die gesamte Kommunikation ist in der Klassse "Gym" abgebildet und gekapselt. Bei jeder Kommunikation wird die aktuelle Observation zurückgegeben.\
Die für die Nutzung interessanten Funktionen sind:
* *gym.connect_player()*\
Meldet den Agenten in Godot an und erhält die initiale Oberservation.
* *gym.reset()* \
Startet das Spiel.
* *gym.step()*\
Sendet die Aktion, welche im nächsten Step ausgeführt werden soll. Diese muss vom Typ *ActionSpace* sein.

### show_images()
In der Datei "show_image.py" ist die Funktion *show_image()* implementiert, welche das übertragene Bild zuerst von Base64 zurückkonvertiert, anschließend ein Bild aus dem Bytearray erstellt und dieses zurück gibt.

## Datenübertragung
In Godot läuft ein Websocket-Server und in Python sind die Websocket-Clients realisiert.\
Die Python Agenten senden Steuerungsbefehle an das Spiel und erhalten Informationen zurück.

### Befehl
In dem Befehl steht die Spielerposition (player_one / player_two) und der nächste Step.
Mit Hilfe der Spielerposition kann die (Websocket) Client ID dem entsprechenden Spieler zugeordnet werden, um die auf den jeweiligen Spieler zugeschittene Antwort richtig zu versenden. 
Die Stepanweisung gibt an wie sich der Spieler im kommenden Step verhalten möchte. Damit die Befehle in Godot dem einzelnen Spieler zugeordent werden können haben die Stepanweisungen das Prefix "player_one_" oder "player_two_".

### Antwort
Die Antwort wird im JSON Format geschickt, was einen einfachen Zusammenbau und Interpretation ermöglicht. Zudem kann die Antwort dynamisch erweitert werden.

* Observation:\
Enhält informationen zu den einzelnen Spielern (Position) und dem Ball (Position, Bewegungsvektor)
* Reward:\
Aktuelle Rewards beider Spieler
* Informationen:\
Punktezahl (Score) beider Spieler und im Modus **Train with Images** den Screenshot 
* Spielstatus:\
Boolscher Wert => Läuft das Spiel noch? 