BeforeAll {
    . $PSScriptRoot/Brainfxck.ps1
}

Describe 'helloWorld' {
    It 'Returns "Hello World"' {
        helloWorld | Should -Be 'Hello World'
    }
}

Describe 'Initialize-BfRuntime' {
    It '要素数5000の配列を0で初期化する' {
        Initialize-BfRuntime
        $BfMemory.Length | Should -Be 5000
        $BfMemory | Where-Object {-not $_ -eq 0} | Should -Be @()
    }
    It '要素数を指定して配列を生成する場合' {
        Initialize-BfRuntime -MemorySize 12000
        $BfMemory.Length | Should -Be 12000
    }
}
