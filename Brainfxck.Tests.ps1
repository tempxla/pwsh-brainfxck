BeforeAll {
    . $PSScriptRoot/Brainfxck.ps1
}

Describe 'New-BfMachine' {
    It 'デフォルト値で仮想マシンの初期状態を作成する' {
        $vm = New-BfMachine
        $vm.Memory.Length | Should -Be 3000
        $vm.Memory | Where-Object { -not $_ -eq 0 } | Should -Be @()
        $vm.Pointer | Should -Be 0
        $vm.Stdin | Should -Be ''
    }
    It 'Stdinパラメータを指定して仮想マシンの初期状態を作成する' {
        $vm = New-BfMachine -Stdin 'abc'
        $vm.Stdin | Should -Be 'abc'
    }
}

Describe 'IncrementPointer' {
    It 'ポインターをインクリメントする' {
        $vm = New-BfMachine
        IncrementPointer -State $vm
        $vm.Pointer | Should -Be 1
        IncrementPointer -State $vm
        $vm.Pointer | Should -Be 2
    }
}

Describe 'DecrementPointer' {
    It 'ポインターをデクリメントする' {
        $vm = New-BfMachine
        DecrementPointer -State $vm
        $vm.Pointer | Should -Be -1
        DecrementPointer -State $vm
        $vm.Pointer | Should -Be -2
    }
}

Describe 'IncrementValueAtPointer' {
    It 'ポインターが指す値をインクリメントする' {
        $vm = New-BfMachine
        IncrementValueAtPointer -State $vm
        $vm.Memory[0] | Should -Be 1
        IncrementValueAtPointer -State $vm
        $vm.Memory[0] | Should -Be 2
    }
}

Describe 'DecrementValueAtPointer' {
    It 'ポインターが指す値をデクリメントする' {
        $vm = New-BfMachine
        DecrementValueAtPointer -State $vm
        $vm.Memory[0] | Should -Be -1
        DecrementValueAtPointer -State $vm
        $vm.Memory[0] | Should -Be -2
    }
}

Describe 'OutputValueAtPointer' {
    It 'ポインターが指す値を出力に書き出す' {
        $vm = New-BfMachine
        Mock Write-Host {}
        OutputValueAtPointer -State $vm
        Assert-MockCalled Write-Host -Exactly 1 -Scope It -ParameterFilter { $Object -eq '0' }
    }
}

Describe 'StoreValueAtPointer' {
    It '入力から1バイト読み込み、ポインターが指す先に代入する。' {
        $vm = New-BfMachine -Stdin 'abc'
        StoreValueAtPointer -State $vm
        $vm.Memory[0] | Should -Be 'a'
        $vm.Stdin | Should -Be 'bc'
    }
}
