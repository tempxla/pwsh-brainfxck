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
