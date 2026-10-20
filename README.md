# MoveIt

Verschiebt Projektverzeichnisse ins Archiv. Grundlage ist eine Liste mit dreistelligen Projektnummern, die der Kunde liefert.

Gleichzeitig dient MoveIt als Einstieg in PowerShell für Azubis.

## Benutzung

Die Liste ist eine Textdatei mit einer Nummer pro Zeile. Leere Zeilen und Zeilen, die mit `#` anfangen, werden ignoriert.

```powershell
# 1. Immer zuerst ein Probelauf: zeigt nur an, was passieren würde
.\extra\MoveIt.ps1 -ListenDatei .\Projektnummern.txt -ProjektOrdner D:\Projekte -ArchivOrdner D:\Archiv -WhatIf

# 2. Wenn alles stimmt: wirklich verschieben
.\extra\MoveIt.ps1 -ListenDatei .\Projektnummern.txt -ProjektOrdner D:\Projekte -ArchivOrdner D:\Archiv
```

Regeln:

- Verschoben wird jedes Verzeichnis, dessen Name mit einer Nummer der Liste beginnt, zum Beispiel `042_Neubau`, `042 Nachtrag` oder `042-Alt`.
- `0421_Irgendwas` wird **nicht** verschoben, denn das ist eine andere Nummer.
- Liegt im Archiv schon ein Ordner mit demselben Namen, wird nichts überschrieben. Das Skript gibt dann eine Warnung aus.
- Am Ende sagt das Skript, für welche Nummern es kein Verzeichnis gefunden hat. Das ist wichtig für die Rückmeldung an den Kunden.

Hilfe zum Skript gibt es mit `Get-Help .\extra\MoveIt.ps1 -Full`.

## Für Azubis: zum Ausprobieren

Zum Einstieg: Im Ordner [Lektionen](Lektionen/) entsteht das Skript Schritt für Schritt in sieben Lektionen.

```powershell
.\New-Testumgebung.ps1      # legt den Ordner .\Testumgebung mit Beispieldaten an
.\extra\MoveIt.ps1 -ListenDatei .\Testumgebung\Projektnummern.txt `
             -ProjektOrdner .\Testumgebung\Projekte `
             -ArchivOrdner .\Testumgebung\Archiv -WhatIf
```

Danach ohne `-WhatIf` ausführen und im Explorer nachsehen. `New-Testumgebung.ps1` setzt alles wieder auf den Anfang zurück.

Was du in [extra/MoveIt.ps1](extra/MoveIt.ps1) lernen kannst (die Kommentare im Skript erklären es):

| Thema | Wo im Skript |
|---|---|
| Kommentarbasierte Hilfe (`Get-Help`) | Block ganz oben |
| Parameter, Pflichtparameter, Validierung | `param(...)` |
| `-WhatIf` mit `SupportsShouldProcess` / `ShouldProcess` | `CmdletBinding`, Schritt 3 |
| Pipeline, `$_`, `ForEach-Object`, `Where-Object` | Schritt 1 |
| Reguläre Ausdrücke mit `-match`, `$Matches` | Schritt 1 und 2 |
| Arrays, `-contains`, `-notcontains`, `Sort-Object -Unique` | Schritt 1, 2 und 4 |
| `Get-ChildItem`, `Test-Path`, `Join-Path`, `New-Item`, `Move-Item` | Schritt 2 und 3 |
| `Write-Host` und `Write-Warning` | überall |

Kleine Übungen:

1. Schreib eine Logdatei mit Datum und Uhrzeit für jedes verschobene Verzeichnis (Tipp: `Add-Content`, `Get-Date`).
2. Lass das Skript eine Liste mit Nummern akzeptieren, die per Komma getrennt sind (Tipp: `-split`).
3. Was passiert, wenn ein Ordner gerade in einem anderen Programm geöffnet ist? Probier es aus.

## Tests

```powershell
Invoke-Pester .\extra\MoveIt.Tests.ps1 -Output Detailed
```

Das Skript läuft unter Windows PowerShell 5.1 und unter PowerShell 7.
