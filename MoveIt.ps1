# MoveIt
# Verschiebt alle Ordner, deren Name mit einer Projektnummer aus der Liste beginnt, ins Archiv.

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