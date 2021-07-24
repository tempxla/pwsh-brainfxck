Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function New-BfMachine {
    param (
        [string]$Source = '',
        [string]$Stdin = ''
    )
    @{
        Memory         = @(1..3000) | ForEach-Object { 0 }
        Pointer        = 0
        ProgramCounter = 0
        Source         = $Source
        Stdin          = $Stdin
        Stdout         = ''
        ParenthesesMap = ParseParentheses $Source
    }
}

function ParseParentheses([string]$Source) {
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
                    $v = $openParens.Pop()
                    $parenMap[$v.ToString()] = $i
                    $parenMap[$i.ToString()] = $v
                    break
                }
            }
        }
    }
    catch {
        Write-Output $_.ToString()
        throw '★Error at Parse Parenthesis: Too Many "]"'
    }
    if ($openParens.Count -lt 0) {
        throw '★Error at Parse Parenthesis: Too Many "["'
    }
    $parenMap
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
    Write-Host -NoNewline -Object ([char]($State.Memory[$State.Pointer]))
    $State.Stdout += ([char]($State.Memory[$State.Pointer]))
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
        return $true
    }
    $false
}

# Op: ]
function JumpIfNotZeroAtPointer($State) {
    if (-not $State.Memory[$State.Pointer] -eq 0) {
        $State.ProgramCounter = $State.ParenthesesMap[$State.ProgramCounter.ToString()] + 1
        return $true
    }
    $false
}

function Invoke-BfMachine {
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        $BfMachine,
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName)]
        [string]$Source,
        [string]$Stdin
    )
    $BfMachine.Source = $Source
    $BfMachine.ParenthesesMap = ParseParentheses $Source
    $BfMachine.Stdin = $Stdin
    $BfMachine.Stdout = ''

    while ($BfMachine.ProgramCounter -lt $Source.Length) {
        $mustMoveCounter = $true
        switch ($Source[$BfMachine.ProgramCounter]) {
            '>' { IncrementPointer $BfMachine; break; }
            '<' { DecrementPointer $BfMachine; break; }
            '+' { IncrementValueAtPointer $BfMachine; break; }
            '-' { DecrementValueAtPointer $BfMachine; break; }
            '.' { OutputValueAtPointer $BfMachine; break; }
            ',' { StoreValueAtPointer $BfMachine; break; }
            '[' { $mustMoveCounter = -not (JumpIfZeroAtPointer $BfMachine); break; }
            ']' { $mustMoveCounter = -not (JumpIfNotZeroAtPointer $BfMachine); break; }
        }
        if ($mustMoveCounter) {
            $BfMachine.ProgramCounter++
        }
    }

    $BfMachine
}
