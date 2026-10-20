# Lektion 6: Verschieben
#
# Ziel:  Jetzt wirklich verschieben. Erst jetzt, weil wir sicher sind,
#        dass die richtigen Ordner gefunden werden!
#
# Neu:   - Move-Item verschiebt eine Datei oder einen Ordner
#          Move-Item <Quelle> <Ziel>
#
# Achtung: Danach sind die Ordner wirklich weg aus dem Projektordner.
# Zuruecksetzen mit:  ..\New-Testumgebung.ps1

$ListenDatei   = "$PSScriptRoot\..\Testumgebung\Projektnummern.txt"
$ProjektOrdner = "$PSScriptRoot\..\Testumgebung\Projekte"
$ArchivOrdner  = "$PSScriptRoot\..\Testumgebung\Archiv"

foreach ($nummer in Get-Content $ListenDatei) {
    $nummer = $nummer.Trim()
    # Leere Zeilen ueberspringen - sonst wuerde der Filter "*" ALLE Ordner verschieben!
    if ($nummer -eq '') { continue }

    foreach ($ordner in Get-ChildItem $ProjektOrdner -Directory -Filter "$nummer*") {
        Move-Item $ordner.FullName $ArchivOrdner
        Write-Host "Verschoben: $($ordner.Name)" -ForegroundColor Green
    }
}

# Aufgabe: Fuehre das Skript ein zweites Mal aus. Was passiert und warum?
# Aufgabe: Schau im Explorer nach, ob die Notiz.txt mitgewandert ist.
