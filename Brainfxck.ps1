Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function helloWorld {
    Write-Output "Hello World"
}

[array]$script:BfMemory = $null

function Initialize-BfRuntime ([int]$MemorySize = 5000) {
    $script:BfMemory = @(1..$MemorySize) | ForEach-Object {0}
}
