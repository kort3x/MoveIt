# Lektion 5: Die Liste bereinigen
#
# Ziel:  Die beiden Fehler aus Lektion 4 beheben.
#
# Neu:   - .Trim() entfernt Leerzeichen am Anfang und am Ende
#        - if (...) { } fuehrt einen Block nur aus, wenn die Bedingung stimmt
#        - -eq vergleicht auf Gleichheit ('' ist ein leerer Text)
#        - continue springt sofort zur naechsten Runde der Schleife

$ListenDatei   = "$PSScriptRoot\..\Testumgebung\Projektnummern.txt"
$ProjektOrdner = "$PSScriptRoot\..\Testumgebung\Projekte"
$ArchivOrdner  = "$PSScriptRoot\..\Testumgebung\Archiv"

foreach ($nummer in Get-Content $ListenDatei) {
    $nummer = $nummer.Trim()
    # Leere Zeilen ueberspringen - sonst wuerde der Filter "*" ALLE Ordner finden!
    if ($nummer -eq '') { continue }

    Write-Host "Nummer [$nummer]:" -ForegroundColor Cyan

    foreach ($ordner in Get-ChildItem $ProjektOrdner -Directory -Filter "$nummer*") {
        Write-Host "   gefunden: $($ordner.Name)" -ForegroundColor Yellow
    }
}

# Vergleiche die Ausgabe mit Lektion 4.
# Aufgabe: Fuer die Nummer 999 gibt es keinen Ordner. Ist das ein Problem?
