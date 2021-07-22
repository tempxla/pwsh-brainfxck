Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Initialize-BfRuntime {
    param (
        [int]$MemorySize = 5000,
        [string]$UserInput = ''
    )
    $script:BfMemory = @(1..$MemorySize) | ForEach-Object { 0 }
    $script:BfPointer = 0
    $script:BfStdin = $UserInput
}

function New-BfMachine {
    param (
        [string]$UserInput = ''
    )
    @{
        Memory  = @(1..3000) | ForEach-Object { 0 }
        Pointer = 0
        Stdin   = $UserInput
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
