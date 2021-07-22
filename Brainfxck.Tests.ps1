BeforeAll {
    . $PSScriptRoot/Brainfxck.ps1
}

Describe 'Initialize-BfRuntime' {
    It '要素数5000の配列を0で初期化し、ポインターを最初の位置にセットする' {
        Initialize-BfRuntime
        $BfMemory.Length | Should -Be 5000
        $BfMemory | Where-Object {-not $_ -eq 0} | Should -Be @()
        $BfPointer | Should -Be 0
    }
    It '要素数を指定して配列を生成する場合' {
        Initialize-BfRuntime -MemorySize 12000
        $BfMemory.Length | Should -Be 12000
    }
    It 'ユーザー入力を初期化する' {
        $BfStdin | Should -Be ''
    }
}

Describe 'IncrementPointer' {
    It 'ポインターをインクリメントする' {
        Initialize-BfRuntime
        IncrementPointer
        $BfPointer | Should -Be 1
        IncrementPointer
        $BfPointer | Should -Be 2
    }
}

Describe 'DecrementPointer' {
    It 'ポインターをデクリメントする' {
        Initialize-BfRuntime
        DecrementPointer
        $BfPointer | Should -Be -1
        DecrementPointer
        $BfPointer | Should -Be -2
    }
}

Describe 'IncrementValueAtPointer' {
    It 'ポインターが指す値をインクリメントする' {
        Initialize-BfRuntime
        IncrementValueAtPointer
        $BfMemory[0] | Should -Be 1
        IncrementValueAtPointer
        $BfMemory[0] | Should -Be 2
    }
}

Describe 'DecrementValueAtPointer' {
    It 'ポインターが指す値をデクリメントする' {
        Initialize-BfRuntime
        DecrementValueAtPointer
        $BfMemory[0] | Should -Be -1
        DecrementValueAtPointer
        $BfMemory[0] | Should -Be -2
    }
}

Describe 'OutputValueAtPointer' {
    It 'ポインターが指す値を出力に書き出す' {
        Initialize-BfRuntime
        Mock Write-Host {}
        OutputValueAtPointer
        Assert-MockCalled Write-Host -Exactly 1 -Scope It -ParameterFilter { $Object -eq '0' }
    }
}

Describe 'StoreValueAtPointer' {
    It '入力から1バイト読み込み、ポインターが指す先に代入する。' {
        Initialize-BfRuntime -UserInput 'abc'
        StoreValueAtPointer
        $BfMemory[0] | Should -Be 'a'
        $BfStdin | Should -Be 'bc'
    }
}
