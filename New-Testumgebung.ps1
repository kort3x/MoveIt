<#
.SYNOPSIS
    Legt eine Spielwiese zum Ausprobieren von MoveItRealGood.ps1 an.

.DESCRIPTION
    Erstellt im Ordner "Testumgebung" einen Projektordner mit Beispielverzeichnissen,
    einen leeren Archivordner und eine Beispiel-Liste mit Projektnummern.
    Eine vorhandene Testumgebung wird vorher geloescht.

.EXAMPLE
    .\New-Testumgebung.ps1
    .\extra\MoveItRealGood.ps1 -ListenDatei .\Testumgebung\Projektnummern.txt -ProjektOrdner .\Testumgebung\Projekte -ArchivOrdner .\Testumgebung\Archiv -WhatIf
#>

# $PSScriptRoot ist der Ordner, in dem dieses Skript liegt.
$basis = Join-Path -Path $PSScriptRoot -ChildPath 'Testumgebung'

if (Test-Path -Path $basis) {
    Remove-Item -Path $basis -Recurse -Force
}

$projekte = Join-Path -Path $basis -ChildPath 'Projekte'
$archiv = Join-Path -Path $basis -ChildPath 'Archiv'

$beispielOrdner = @(
    '042_Neubau Rathaus'
    '042_Neubau Rathaus Nachtrag'
    '107 Sanierung Schule'
    '215-Kita Sonnenschein'
    '330_Brueckenpruefung'
    '512_Radweg'
    'Vorlagen'
)

foreach ($name in $beispielOrdner) {
    $ordner = New-Item -Path (Join-Path $projekte $name) -ItemType Directory -Force
    # Eine Datei hineinlegen, damit man sieht, dass der Inhalt mitwandert.
    Set-Content -Path (Join-Path $ordner.FullName 'Notiz.txt') -Value "Inhalt von $name"
}

New-Item -Path $archiv -ItemType Directory -Force | Out-Null

# Die Liste "vom Kunden" - absichtlich mit ein paar Stolperfallen.
@(
    '# Projektnummern vom Kunden, Stand Oktober'
    '042'
    '215'
    '  330  '
    ''
    '042'
    '999'
    '12a'
) | Set-Content -Path (Join-Path $basis 'Projektnummern.txt')

Write-Host "Testumgebung angelegt in: $basis"
