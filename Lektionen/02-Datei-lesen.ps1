# Lektion 2: Eine Datei Zeile fuer Zeile lesen
#
# Ziel:  Die Projektnummern aus der Liste des Kunden lesen.
#
# Neu:   - Get-Content liest eine Textdatei, jede Zeile ist ein Eintrag
#        - foreach (... in ...) { } wiederholt den Block fuer jeden Eintrag
#        - In der Schleifenvariable $nummer steht die aktuelle Zeile

$ListenDatei   = "$PSScriptRoot\..\Testumgebung\Projektnummern.txt"
$ProjektOrdner = "$PSScriptRoot\..\Testumgebung\Projekte"
$ArchivOrdner  = "$PSScriptRoot\..\Testumgebung\Archiv"

foreach ($nummer in Get-Content $ListenDatei) {
    Write-Host "Nummer aus der Liste: [$nummer]" -ForegroundColor Cyan
}

# Die eckigen Klammern [ ] sind nur zur Anzeige da. So sieht man Leerzeichen
# und leere Zeilen. Schau dir die Ausgabe genau an: Was faellt dir auf?
#
# Aufgabe: Oeffne Projektnummern.txt im Editor und vergleiche.
