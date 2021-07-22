Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

[array]$script:BfMemory = $null

[int]$script:BfPointer = 0

function Initialize-BfRuntime {
    param (
        [int]$MemorySize = 5000
    )
    $script:BfMemory = @(1..$MemorySize) | ForEach-Object { 0 }
    $script:BfPointer = 0
}

# Op: >
function IncrementPointer {
    $script:BfPointer++
}

# Op: <
function DecrementPointer {
    $script:BfPointer--
}

# Op: +
function IncrementValueAtPointer {
    $script:BfMemory[$script:BfPointer]++
}

# Op: -
function DecrementValueAtPointer {
    $script:BfMemory[$script:BfPointer]--
}
