<#
.SYNOPSIS
    Verschiebt Projektverzeichnisse anhand einer Liste von Projektnummern ins Archiv.

.DESCRIPTION
    Der Kunde liefert eine Textdatei mit dreistelligen Projektnummern (eine pro Zeile).
    Alle Verzeichnisse im Projektordner, deren Name mit einer dieser Nummern beginnt,
    werden in den Archivordner verschoben.

    Beispiel: Steht "042" in der Liste, wird "042_Neubau Rathaus" verschoben,
    "0421_Sonstiges" aber NICHT (das ist eine andere, vierstellige Nummer).

    Tipp: Immer zuerst mit -WhatIf testen! Dann zeigt das Skript nur an, was es tun
    wuerde, ohne wirklich etwas zu verschieben.

.PARAMETER ListenDatei
    Textdatei mit den Projektnummern. Leere Zeilen und Zeilen, die mit # beginnen,
    werden ignoriert.

.PARAMETER ProjektOrdner
    Ordner, in dem die Projektverzeichnisse liegen.

.PARAMETER ArchivOrdner
    Zielordner. Wird angelegt, falls er noch nicht existiert.

.EXAMPLE
    .\MoveItRealGood.ps1 -ListenDatei .\Projektnummern.txt -ProjektOrdner D:\Projekte -ArchivOrdner D:\Archiv -WhatIf

    Zeigt nur an, welche Verzeichnisse verschoben wuerden (Probelauf).

.EXAMPLE
    .\MoveItRealGood.ps1 -ListenDatei .\Projektnummern.txt -ProjektOrdner D:\Projekte -ArchivOrdner D:\Archiv

    Verschiebt die Verzeichnisse wirklich.
#>

# [CmdletBinding] macht aus dem Skript ein "fortgeschrittenes" Skript.
# SupportsShouldProcess schaltet die Schalter -WhatIf und -Confirm frei - geschenkt!
[CmdletBinding(SupportsShouldProcess)]
param(
    # Mandatory = Pflichtparameter: Fehlt er, fragt PowerShell danach.
    # ValidateScript prueft den Wert, bevor das Skript ueberhaupt startet.
    [Parameter(Mandatory)]
    [ValidateScript({ Test-Path -Path $_ -PathType Leaf })]
    [string]$ListenDatei,

    [Parameter(Mandatory)]
    [ValidateScript({ Test-Path -Path $_ -PathType Container })]
    [string]$ProjektOrdner,

    [Parameter(Mandatory)]
    [string]$ArchivOrdner
)

# Bei jedem Fehler sofort abbrechen, statt still weiterzumachen.
$ErrorActionPreference = 'Stop'


# --- Schritt 1: Projektnummern aus der Datei lesen ---------------------------------

# Get-Content liefert die Datei Zeile fuer Zeile. Die Pipeline (|) reicht jede
# Zeile an den naechsten Befehl weiter. $_ ist dabei immer "die aktuelle Zeile".
$zeilen = Get-Content -Path $ListenDatei |
    ForEach-Object { $_.Trim() } |
    Where-Object { $_ -ne '' -and -not $_.StartsWith('#') }

$projektNummern = @()
foreach ($zeile in $zeilen) {
    # -match prueft gegen einen regulaeren Ausdruck:
    #   ^      = Anfang der Zeile
    #   \d{3}  = genau drei Ziffern
    #   $      = Ende der Zeile
    if ($zeile -match '^\d{3}$') {
        $projektNummern += $zeile
    }
    else {
        Write-Warning "Ungueltige Projektnummer in der Liste uebersprungen: '$zeile'"
    }
}

# Doppelte Eintraege entfernen.
$projektNummern = $projektNummern | Sort-Object -Unique

if (-not $projektNummern) {
    Write-Warning 'Die Liste enthaelt keine gueltigen Projektnummern. Es gibt nichts zu tun.'
    return
}

Write-Host "Projektnummern aus der Liste: $($projektNummern -join ', ')" -ForegroundColor Cyan


# --- Schritt 2: Passende Verzeichnisse im Projektordner finden ---------------------

# -Directory liefert nur Ordner, keine Dateien.
$verzeichnisse = Get-ChildItem -Path $ProjektOrdner -Directory

$treffer = foreach ($verzeichnis in $verzeichnisse) {
    # Die ersten drei Zeichen des Namens muessen Ziffern sein, und danach darf
    # KEINE weitere Ziffer folgen:  (?!\d) heisst "hier folgt keine Ziffer".
    # Die runden Klammern um \d{3} merken sich die Nummer in $Matches[1].
    if ($verzeichnis.Name -match '^(\d{3})(?!\d)') {
        $nummer = $Matches[1]
        if ($projektNummern -contains $nummer) {
            # Was hier "uebrig bleibt", landet automatisch in $treffer.
            $verzeichnis
        }
    }
}

if (-not $treffer) {
    Write-Host 'Kein Verzeichnis im Projektordner passt zu den Nummern auf der Liste.' -ForegroundColor Yellow
    return
}


# --- Schritt 3: Verzeichnisse ins Archiv verschieben -------------------------------

if (-not (Test-Path -Path $ArchivOrdner)) {
    # Out-Null verschluckt die Ausgabe von New-Item, damit die Konsole sauber bleibt.
    New-Item -Path $ArchivOrdner -ItemType Directory | Out-Null
}

$verschoben = 0
$uebersprungen = 0

foreach ($verzeichnis in $treffer) {
    $ziel = Join-Path -Path $ArchivOrdner -ChildPath $verzeichnis.Name

    # Nichts ueberschreiben! Liegt im Archiv schon ein gleichnamiger Ordner,
    # muss das ein Mensch klaeren.
    if (Test-Path -Path $ziel) {
        Write-Warning "Uebersprungen, existiert bereits im Archiv: $($verzeichnis.Name)"
        $uebersprungen++
        continue
    }

    # ShouldProcess ist der Schluessel zu -WhatIf: Bei einem Probelauf gibt es
    # nur eine Meldung aus und liefert $false - dann wird nichts verschoben.
    if ($PSCmdlet.ShouldProcess($verzeichnis.FullName, "Verschieben nach $ArchivOrdner")) {
        Move-Item -Path $verzeichnis.FullName -Destination $ziel
        Write-Host "Verschoben: $($verzeichnis.Name)" -ForegroundColor Green
        $verschoben++
    }
}


# --- Schritt 4: Zusammenfassung ----------------------------------------------------

# Welche Nummern standen auf der Liste, haben aber keinen Ordner gefunden?
# Das ist wichtig fuer die Rueckmeldung an den Kunden.
$gefundeneNummern = $treffer | ForEach-Object { $_.Name.Substring(0, 3) }
$ohneTreffer = $projektNummern | Where-Object { $gefundeneNummern -notcontains $_ }

Write-Host ''
Write-Host "Passende Verzeichnisse: $(@($treffer).Count)"
Write-Host "Verschoben:             $verschoben" -ForegroundColor Green
Write-Host "Uebersprungen:          $uebersprungen" -ForegroundColor Yellow
if ($ohneTreffer) {
    Write-Warning "Kein Verzeichnis gefunden fuer: $($ohneTreffer -join ', ')"
}
