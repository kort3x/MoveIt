# Automatische Tests fuer MoveIt.ps1 mit Pester.
# Ausfuehren mit:  Invoke-Pester .\MoveIt.Tests.ps1 -Output Detailed

BeforeAll {
    $skript = Join-Path -Path $PSScriptRoot -ChildPath 'MoveIt.ps1'
}

Describe 'MoveIt' {

    # Vor jedem Test eine frische Umgebung im temporaeren Pester-Laufwerk TestDrive: anlegen.
    BeforeEach {
        $projekte = Join-Path 'TestDrive:' 'Projekte'
        $archiv = Join-Path 'TestDrive:' 'Archiv'
        $liste = Join-Path 'TestDrive:' 'Liste.txt'

        Remove-Item -Path 'TestDrive:\*' -Recurse -Force -ErrorAction SilentlyContinue
        foreach ($name in '042_Rathaus', '042 Nachtrag', '0421_Andere Nummer', '107_Schule', 'Vorlagen') {
            New-Item -Path (Join-Path $projekte $name) -ItemType Directory -Force | Out-Null
        }
        Set-Content -Path $liste -Value '042', '# Kommentar', '', '999', 'abc'
    }

    It 'verschiebt alle Verzeichnisse, die mit einer Nummer der Liste beginnen' {
        & $skript -ListenDatei $liste -ProjektOrdner $projekte -ArchivOrdner $archiv 6>$null 3>$null

        (Get-ChildItem $archiv).Name | Sort-Object | Should -Be @('042 Nachtrag', '042_Rathaus')
    }

    It 'laesst andere Verzeichnisse liegen - auch vierstellige Nummern' {
        & $skript -ListenDatei $liste -ProjektOrdner $projekte -ArchivOrdner $archiv 6>$null 3>$null

        (Get-ChildItem $projekte).Name | Sort-Object | Should -Be @('0421_Andere Nummer', '107_Schule', 'Vorlagen')
    }

    It 'verschiebt bei -WhatIf nichts' {
        & $skript -ListenDatei $liste -ProjektOrdner $projekte -ArchivOrdner $archiv -WhatIf 6>$null 3>$null

        Get-ChildItem $projekte | Should -HaveCount 5
    }

    It 'ueberschreibt nichts, was schon im Archiv liegt' {
        New-Item -Path (Join-Path $archiv '042_Rathaus') -ItemType Directory -Force | Out-Null

        & $skript -ListenDatei $liste -ProjektOrdner $projekte -ArchivOrdner $archiv 6>$null 3>$null

        Join-Path $projekte '042_Rathaus' | Should -Exist
        Join-Path $archiv '042 Nachtrag' | Should -Exist
    }

    It 'warnt bei ungueltigen Nummern und bei Nummern ohne Verzeichnis' {
        $warnungen = & $skript -ListenDatei $liste -ProjektOrdner $projekte -ArchivOrdner $archiv 6>$null 3>&1

        $warnungen -join "`n" | Should -Match "'abc'"
        $warnungen -join "`n" | Should -Match '999'
    }
}
