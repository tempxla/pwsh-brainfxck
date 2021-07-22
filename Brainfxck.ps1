Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function New-BfMachine {
    param (
        [string]$Stdin = ''
    )
    @{
        Memory  = @(1..3000) | ForEach-Object { 0 }
        Pointer = 0
        Stdin   = $Stdin
    }
}

# Op: >
function IncrementPointer($State) {
    $State.Pointer++
}

# Op: <
function DecrementPointer($State) {
    $State.Pointer--
}

# Op: +
function IncrementValueAtPointer($State) {
    $State.Memory[$State.Pointer]++
}

# Op: -
function DecrementValueAtPointer($State) {
    $State.Memory[$State.Pointer]--
}

# Op: .
function OutputValueAtPointer($State) {
    Write-Host -NoNewline -Object $State.Memory[$State.Pointer]
}

# Op: ,
function StoreValueAtPointer($State) {
    $State.Memory[$State.Pointer] = $State.Stdin[0]
    $State.Stdin = $State.Stdin.Substring(1, $State.Stdin.Length - 1)
}
