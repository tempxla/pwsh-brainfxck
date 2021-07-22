BeforeAll {
    . $PSScriptRoot/Brainfxck.ps1

    function MapToJson($Map) {
        $Map.GetEnumerator() | Sort-Object -Property Key | ConvertTo-Json
    }
}

Describe 'New-BfMachine' {
    It 'デフォルト値で仮想マシンの初期状態を作成する' {
        $vm = New-BfMachine
        $vm.Memory.Length | Should -Be 3000
        $vm.Memory | Where-Object { -not $_ -eq 0 } | Should -Be @()
        $vm.Pointer | Should -Be 0
        $vm.Stdin | Should -Be ''
        $vm.Source | Should -Be ''
        $vm.ProgramCounter | Should -Be 0
    }
    It 'Stdinパラメータを指定して仮想マシンの初期状態を作成する' {
        $vm = New-BfMachine -Stdin 'abc'
        $vm.Stdin | Should -Be 'abc'
    }
    It 'Sourceパラメータを指定して仮想マシンの初期状態を作成する' {
        $vm = New-BfMachine -Source '[[++]++]'
        $vm.Source | Should -Be '[[++]++]'
    }
    It '仮想マシンの初期状態を生成時、カッコの対応付を行う' {
        $vm = New-BfMachine -Source '[[++]++]'
        MapToJson($vm.ParenthesesMap) | Should -Be (MapToJson(@{'0' = 7; '1' = 4 }))
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

Describe 'JumpIfZeroAtPointer' {
    It 'ポインタが指す値が0の場合、対応する]の直後にジャンプする' {
        $vm = New-BfMachine -Source "[[++]++]"
        $vm.ProgramCounter = 0
        JumpIfZeroAtPointer -State $vm
        $vm.ProgramCounter | Should -Be 8
        $vm.ProgramCounter = 1
        JumpIfZeroAtPointer -State $vm
        $vm.ProgramCounter | Should -Be 5
    }
    It 'ポインタが指す値が0でない場合、対応する]の直後にジャンプしない' {
        $vm = New-BfMachine -Source "[[++]++]"
        $vm.Memory[0] = 1
        JumpIfZeroAtPointer -State $vm
        $vm.ProgramCounter | Should -Be 0
    }
}
