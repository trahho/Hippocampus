#  Neuer Umbau
Ich denke, die Trennung von Query und View sind nicht gut. Ich brauche
- RootItems (Rolle, Eigenschaften, DefaultValues, Representation)
- SubItems (Rolle, Eigenschaften, DefaultValues Verbindung, Rolle, Eigenschaften, DefaultValues Item)

Damit kann der View sich daraus seine Sicht bauen, und kann ein neues RootItem und ein neues SubItem (unter dem Gewählten) einbringen.

# Navigation
Der NavigationStack kriegt ein Struct, welches einem Protokoll entspricht, das einen View anzeigt.


# TODO
- Representation umbauen

# Architektur

## Information
Information speichert bestimmte Werte in Knoten und Verbindungen und nimmt die entsprechende Rolle an. 

## Struktur 
Die Rolle bestimmt, welche Werte benutzt werden sollen.
Die Rolle hat Aspekte, welche den Wert speichern können. Zudem hat sie Ansichten, die die Rolle in der passenden Form darstellt.
Die Rolle hat auch Unterrollen, um die Aspekte mehrfach interpretieren zu können.

## Presentation
Die Presentation bestimmt, was angezeigt wird. Dafür gibt es verschiedene Präsentationen.
Die Präsentation zeigt die Information in bestimmten Formen an:
- Liste: Die gefundenen Informaitionen werden einzeln angezeigt
- Ordner: Die Informationen, die an der Wurzel stehen, werden angezeigt. Sie können geöffnet werden, und die dazugehörigen Informationen anzeigen.
- Gallerie: Die Informationen werden in einem Raster angezeigt. Vielleicht können sie geöffnet werden und mehr Platz einnehmen.
- Map: Automatisch layoutende MindMap. Graph, Center, Stack
- Canvas: Die Informationen können beliebig angeordnet werden.
- Sonstiges, z. B. TimeLine, Project (Gantt), Table
Die Daten (z. B. Position) werden für die Presentation gespeichert, aber die Views können genested werden. Das führt dazu, dass alle Präsentationen ihr Layout selber übernehmen. Auch Listen. Mal sehen, ob das LayoutProtocol dazu passt.

Um die Informationen zu bestimmen, verfügt die Presentation über Predicates, die die RootItems bestimmen, und die SubItems


# Neuer Entwurf

Information bleibt so, wie sie ist.

Die Rollen bestimmen die Struktur, z. B. 
Rezept
 - Zutat { -> Zutat(Menge) -> Nahrungsmittel }
 - Schritt { -> Schritt }
 
 Es entspricht dem Modell, damit kann bestimmt werden, welche Daten angezeigt werden, und welche Elemente man erstellen kann.

# Nächster Schritt

Das Dokument kriegt @DocumentProperty, das wird sofort geladen. Der Rest passiert erst, wenn .open(). Dann kommt das Setup, damit können die statischen Elemente (Groups).hidden werden. In den Settings kann man wählen, was angezeigt werden kann, das kommt in die properties.

Navigation wird standard, man kann die Groups, Queries, Items pinnen. Das ist eine weitere Liste mit einem Objekt, das eine Referenz auf andere hat. 


# Layout
Ich möchte das Strukturmodell wie ein Datenmodell anzeigen.
Rolle: 
- Enthalten (geerbt) - oben (als Baum)
- Eigenschaften
- Verbindungen (to/from, Rolle) to rechts, from links

Das entspricht einem Graphlayout. Daraus wird eine Package :-)
DisplayView - ZStack mit Scroll und Zoom, Nodes und Edges. Die werden z. B. vom QueryView berechnet und gesetzt.
LayoutProtocol - Vielleicht DisplayView als Layout mit $Positions
LayoutEngine - Berechnet die Positions und wenn fertig, dann Published Werte setzen. 


# Idee

Jetzt kommt die Idee:

Rollen bestimmen die Struktur. Die Queries beruhen auf der Struktur der Rollen und können filtern

Beispiel

General: Name
Rezept: General -> Menge (Einheit) -> Nahrungsmittel (General)
Ereignis: General, Beginn, Ende

Zeige alle Rezepte an, zeige alle Ereignisse an, die auch Rezepte waren, zeige alle Generell an, die heute erstellt wurden etc. etc.
