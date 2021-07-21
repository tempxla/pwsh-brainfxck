Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function helloWorld {
    Write-Output "Hello World"
}

[array]$script:BfMemory = $null

function Initialize-BfRuntime {
    $script:BfMemory = @(1..5000) | ForEach-Object {0}
}
