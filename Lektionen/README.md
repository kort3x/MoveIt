# MoveIt in Lektionen

In sieben Schritten entsteht das Skript `MoveIt-MVP.ps1`. Jede Lektion ist ein eigenes, lauffähiges Skript und baut auf der vorherigen auf.

Vorher einmal die Testumgebung anlegen (im Hauptordner):

```powershell
.\New-Testumgebung.ps1
```

| Lektion | Thema | Neu |
|---|---|---|
| [01-Variablen.ps1](01-Variablen.ps1) | Pfade speichern und anzeigen | `$variable`, `Write-Host -ForegroundColor`, `$PSScriptRoot` |
| [02-Datei-lesen.ps1](02-Datei-lesen.ps1) | Projektnummern lesen | `Get-Content`, `foreach` |
| [03-Ordner-auflisten.ps1](03-Ordner-auflisten.ps1) | Projektordner auflisten | `Get-ChildItem -Directory`, `.Name`, `$( )` |
| [04-Ordner-finden.ps1](04-Ordner-finden.ps1) | Passende Ordner finden, nur anschauen | Schleife in Schleife, `-Filter`, `*` |
| [05-Liste-bereinigen.ps1](05-Liste-bereinigen.ps1) | Leerzeichen und leere Zeilen | `.Trim()`, `if`, `-eq`, `continue` |
| [06-Verschieben.ps1](06-Verschieben.ps1) | Wirklich verschieben | `Move-Item` |
| [07-Parameter.ps1](07-Parameter.ps1) | Pfade beim Aufruf übergeben, vor dem Verschieben nachfragen | `param()`, `-Confirm` |

Jede Lektion endet mit einer kleinen Aufgabe.

Lektion 4 ist absichtlich noch fehlerhaft: Eine leere Zeile in der Liste findet **alle** Ordner. Daran sieht man, warum man erst schaut und dann verschiebt.

Nach Lektion 6 sind die Ordner verschoben. Mit `.\New-Testumgebung.ps1` setzt du alles wieder zurück.

Danach geht es weiter mit `..\extra\MoveIt.ps1`, der vollständigen Version mit Probelauf (`-WhatIf`), Prüfungen und Zusammenfassung.
