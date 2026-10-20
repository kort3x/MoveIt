# Lektion 7: Parameter
#
# Ziel:  Die Pfade nicht mehr fest ins Skript schreiben, sondern beim Aufruf
#        uebergeben. Dann funktioniert das Skript fuer jeden Kunden und jeden Ordner.
#        Damit ist das Skript fertig - es ist genau ..\MoveIt.ps1.
#
# Neu:   - param( ) muss ganz oben im Skript stehen
#        - Beim Aufruf werden die Werte der Reihe nach zugeordnet
#        - -Confirm fragt vor jedem Verschieben nach: [J] Ja, [N] Nein, ...
#          Jetzt, wo das Skript fuer echte Kundenordner taugt, ist das ein gutes Sicherheitsnetz
#
# Aufruf:
#   .\07-Parameter.ps1 ..\Testumgebung\Projektnummern.txt ..\Testumgebung\Projekte ..\Testumgebung\Archiv
#
# oder mit Namen (dann ist die Reihenfolge egal):
#   .\07-Parameter.ps1 -ProjektOrdner ..\Testumgebung\Projekte -ArchivOrdner ..\Testumgebung\Archiv -ListenDatei ..\Testumgebung\Projektnummern.txt

param($ListenDatei, $ProjektOrdner, $ArchivOrdner)

foreach ($nummer in Get-Content $ListenDatei) {
    $nummer = $nummer.Trim()
    # Leere Zeilen ueberspringen - sonst wuerde der Filter "*" ALLE Ordner verschieben!
    if ($nummer -eq '') { continue }

    foreach ($ordner in Get-ChildItem $ProjektOrdner -Directory -Filter "$nummer*") {
        Move-Item $ordner.FullName $ArchivOrdner -Confirm
        Write-Host "Verschoben: $($ordner.Name)" -ForegroundColor Green
    }
}

# Wie geht es weiter? Schau dir ..\extra\MoveItRealGood.ps1 an. Dort ist dasselbe Skript
# "erwachsen" geworden: Probelauf mit -WhatIf, Pruefung der Eingaben,
# nichts wird ueberschrieben, und am Ende gibt es eine Zusammenfassung.
