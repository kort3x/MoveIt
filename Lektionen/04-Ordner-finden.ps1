# Lektion 4: Passende Ordner zu jeder Nummer finden
#
# Ziel:  Zu jeder Nummer aus der Liste die Ordner finden, die damit beginnen.
#        Noch wird NICHTS verschoben - wir schauen nur.
#
# Neu:   - Zwei Schleifen ineinander: fuer jede Nummer alle passenden Ordner
#        - -Filter "042*" findet alles, was mit 042 beginnt
#          Das * ist ein Platzhalter fuer "beliebig viele Zeichen"

$ListenDatei   = "$PSScriptRoot\..\Testumgebung\Projektnummern.txt"
$ProjektOrdner = "$PSScriptRoot\..\Testumgebung\Projekte"
$ArchivOrdner  = "$PSScriptRoot\..\Testumgebung\Archiv"

foreach ($nummer in Get-Content $ListenDatei) {
    Write-Host "Nummer [$nummer]:" -ForegroundColor Cyan

    foreach ($ordner in Get-ChildItem $ProjektOrdner -Directory -Filter "$nummer*") {
        Write-Host "   gefunden: $($ordner.Name)" -ForegroundColor Magenta
    }
}

# Schau dir die Ausgabe genau an. Zwei Dinge stimmen noch nicht:
#   1. Die Nummer "  330  " findet nichts. Warum?
#   2. Bei der leeren Zeile werden ALLE Ordner gefunden. Warum?
#      (Tipp: Was wird aus "$nummer*", wenn $nummer leer ist?)
# Haetten wir hier schon verschoben, waere jetzt der ganze Projektordner im Archiv!
