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
function IncrementPointer {
    param (
        $State
    )
    $State.Pointer++
}

# Op: <
function DecrementPointer {
    param (
        $State
    )
    $State.Pointer--
}

# Op: +
function IncrementValueAtPointer {
    param (
        $State
    )
    $State.Memory[$State.Pointer]++
}

# Op: -
function DecrementValueAtPointer {
    param (
        $State
    )
    $State.Memory[$State.Pointer]--
}

# Op: .
function OutputValueAtPointer {
    param (
        $State
    )
    Write-Host -NoNewline -Object $State.Memory[$State.Pointer]
}

# Op: ,
function StoreValueAtPointer {
    param (
        $State
    )
    $State.Memory[$State.Pointer] = $State.Stdin[0]
    $State.Stdin = $State.Stdin.Substring(1, $State.Stdin.Length - 1)
}
