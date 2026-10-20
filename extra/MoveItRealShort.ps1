# MoveIt in kuerzester Schreibweise - macht dasselbe wie ..\MoveIt.ps1
#   gc = Get-Content   ?{ } = Where-Object    %{ } = ForEach-Object
#   gci = Get-ChildItem (2. Wert = -Filter, -ad = -Directory)
#   mi = Move-Item     -cf = -Confirm
param($l,$p,$a)
(gc $l).Trim()|?{$_}|%{gci $p "$_*" -ad}|%{mi $_.FullName $a -cf;"Verschoben: $($_.Name)"}
