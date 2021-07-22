Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

[array]$script:BfMemory = $null

[int]$script:BfPointer = 0

[string]$script:BfStdin = $null

function Initialize-BfRuntime {
    param (
        [int]$MemorySize = 5000,
        [string]$UserInput = ''
    )
    $script:BfMemory = @(1..$MemorySize) | ForEach-Object { 0 }
    $script:BfPointer = 0
    $script:BfStdin = $UserInput
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

# Op: .
function OutputValueAtPointer {
    Write-Host -NoNewline -Object $script:BfMemory[$script:BfPointer]
}

# Op: ,
function StoreValueAtPointer {
    $script:BfMemory[$script:BfPointer] = $script:BfStdin[0]
    $script:BfStdin = $script:BfStdin.Substring(1, $script:BfStdin.Length - 1)
}
