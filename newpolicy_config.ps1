configuration NewPolicy {
    Import-DscResource -Module NewPolicy
    node NewPolicy {
        NewPolicy NewPolicy  {
            Property = 'Value'
        }
    }
}

NewPolicy -OutputPath .\MOF