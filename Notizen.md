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
