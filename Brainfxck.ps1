Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

[array]$script:BfMemory = $null

function Initialize-BfRuntime ([int]$MemorySize = 5000) {
    $script:BfMemory = @(1..$MemorySize) | ForEach-Object {0}
}
