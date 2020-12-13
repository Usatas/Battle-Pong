# Battle Pong

Projekt für Vertiefung Simulation

Battle Pong baut auf dem klassischen Zwei-Spieler Pong auf.\
Allerdings soll es möglich sein die menschlichen Spieler durch Reinforcement Algorithmen zu ersetzen.
Zudem sollen die Algorithmen von den menschlichen Spielern lernen können.
Die Datenübertragung per TCP basiert auf REST.

# Ziele

- Manuelle Steuerung per Tastatur
- Steuerung durch Reinforcement Algorithmen (vgl. Gym Open AI) per TCP
- Headless Server Modus, in dem das Rendering deaktiviert ist
- Ist ein Algorithmus per TCP verbunden und ein Mensch spielt, dann wird dennoch die Obervation gesendet

# Optionale Ziele

- Verschiedene Modi, die über eine Settings-Datei eingestellt werden können
- Speichern der Einstellungen in einer Datei
- Anpassen der Einstellungen durch ein In-Game Menü
    - z.B. : Tastaturbelegung, Ports, ...
