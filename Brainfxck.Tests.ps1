BeforeAll {
    . $PSScriptRoot/Brainfxck.ps1
}

Describe 'helloWorld' {
    It 'Returns "Hello World"' {
        helloWorld | Should -Be 'Hello World'
    }
}
