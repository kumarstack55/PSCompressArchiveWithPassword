BeforeAll {
    . $PSCommandPath.Replace('.Tests.ps1', '.ps1')
}

Describe ".\PSCompressArchiveWithPassword" {
    It "Returns expected output" {
        .\PSCompressArchiveWithPassword | Should -Be "YOUR_EXPECTED_VALUE"
    }
}
