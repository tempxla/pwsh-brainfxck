Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function New-BfMachine {
    param (
        [string]$Source = '',
        [string]$Stdin = ''
    )
    # Parse Parentheses
    $parenMap = @{}
    $openParens = New-Object Collections.Stack
    try {
        for ($i = 0; $i -lt $Source.Length; $i++) {
            switch ($Source[$i]) {
                '[' {
                    $openParens.Push($i)
                    break
                }
                ']' {
                    $parenMap[$openParens.Pop().ToString()] = $i
                    break
                }
            }
        }
    }
    catch {
        Write-Output $_.ToString()
        throw '★Error at Parse Parenthesis: Too Many "]"'
    }
    if ($openParens.Count > 0) {
        throw '★Error at Parse Parenthesis: Too Many "["'
    }
    # Returns
    @{
        Memory         = @(1..3000) | ForEach-Object { 0 }
        Pointer        = 0
        ProgramCounter = 0
        Source         = $Source
        Stdin          = $Stdin
        ParenthesesMap = $parenMap
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

# Op: [
function JumpIfZeroAtPointer($State) {
    if ($State.Memory[$State.Pointer] -eq 0) {
        $State.ProgramCounter = $State.ParenthesesMap[$State.ProgramCounter.ToString()] + 1
    }
}
