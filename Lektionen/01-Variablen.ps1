# Lektion 1: Variablen und Ausgabe
#
# Ziel:  Die drei Pfade, die MoveIt braucht, in Variablen speichern und anzeigen.
#
# Neu:   - Variablen beginnen mit $
#        - Texte stehen in Anfuehrungszeichen
#        - Write-Host schreibt etwas in die Konsole
#        - In "doppelten" Anfuehrungszeichen wird $variable durch ihren Wert ersetzt
#        - $PSScriptRoot ist der Ordner, in dem dieses Skript liegt
#
# Vorher einmal ausfuehren:  ..\New-Testumgebung.ps1

$ListenDatei   = "$PSScriptRoot\..\Testumgebung\Projektnummern.txt"
$ProjektOrdner = "$PSScriptRoot\..\Testumgebung\Projekte"
$ArchivOrdner  = "$PSScriptRoot\..\Testumgebung\Archiv"

Write-Host "Liste:     $ListenDatei"
Write-Host "Projekte:  $ProjektOrdner"
Write-Host "Archiv:    $ArchivOrdner"

# Aufgabe: Gib zusaetzlich deinen Namen aus. Lege dafuer eine Variable $Name an.
