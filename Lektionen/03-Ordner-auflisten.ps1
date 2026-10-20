# Lektion 3: Ordner auflisten
#
# Ziel:  Sehen, welche Projektordner es gibt.
#
# Neu:   - Get-ChildItem listet den Inhalt eines Ordners auf (wie "dir")
#        - -Directory liefert nur Ordner, keine Dateien
#        - Jeder Ordner ist ein Objekt mit Eigenschaften, z. B. .Name und .FullName
#        - $( ) rechnet innerhalb eines Textes etwas aus

$ListenDatei   = "$PSScriptRoot\..\Testumgebung\Projektnummern.txt"
$ProjektOrdner = "$PSScriptRoot\..\Testumgebung\Projekte"
$ArchivOrdner  = "$PSScriptRoot\..\Testumgebung\Archiv"

foreach ($ordner in Get-ChildItem $ProjektOrdner -Directory) {
    Write-Host "Ordner: $($ordner.Name)" -ForegroundColor Cyan
}

# Aufgabe: Gib statt .Name einmal .FullName aus. Was ist der Unterschied?
# Aufgabe: Was passiert, wenn du -Directory weglaesst?
