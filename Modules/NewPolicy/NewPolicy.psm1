class Reason
{
    [DscProperty()]
    [string] $Phrase

    [DscProperty()]
    [string] $Code
}


[DscResource()]
class NewPolicy
{
    [DscProperty(Key)]
    [string] $Property

    [DscProperty(NotConfigurable)]
    [string] $Status

    [DscProperty(NotConfigurable)]
    [Reason[]] $Reasons


    ### DSC methods

    [NewPolicy] Get()
    {

        $FunctionResult = Get-Function1 -Property $this.Property
        $currentState = [NewPolicy]$FunctionResult

        return $currentState
    }

    [void] Set()
    {
        throw 'Set functionality is not supported in this version of the DSC resource.'
    }

    [bool] Test()
    {
        $return = $this.Get().status

        return $return
    }
}


<#
    .SYNOPSIS
        Use simple functions to get information
    .DESCRIPTION
        Whenver possible it is easiest to use simple PowerShell functions
        that collect information about the machine and return it in a
        predictable way.

        Functions are easy to test and debug without
        the extra overhead of also troubleshooting solutions such as
        DSC or Guest Config.

        This approach was presented by Don Jones at PowerShell Summit 2015.
        https://www.youtube.com/watch?v=Upgj-IPM2UM

        This example 'Get-Function1' is just for demonstration purposes
        to show how you might layout such a function.
        You probably will need more than 1.
#>
function Get-Function1 {
    [CmdletBinding()]
    [OutputType([Hashtable])]
    param(
        # Give the parameter a name that anyone will understand
        [Parameter(Mandatory = $true)]
        [string]
        $Property
    )

    # it never hurts to include your own logging to make troubleshooting easier
    Write-Verbose -Message "[$((get-date).getdatetimeformats()[45])] Log what the function is doing..."

    # PUT SCRIPT HERE
    # collect some information about the node and save it as a variable
    $information = if ($Property -eq 'Value') { 'good' } else { 'bad' }

    # there could be more than one reason that the node is not compliant
    # reasons is an array of hashtables explaining why
    $reasons = @()

    # since you have the information, determine compliance
    if ('good' -eq $information) {
        $status = $true
        $reasons = $null
    }
    else {
        $status = $false
        $reasons += @{
            Code   = 'Resource:Resource:ShortReasonNameYouCreate'
            Phrase = "an example phrase with data from a function: $information"
        }
    }

    # Guest Configuration is expecting Get to have a property named Reasons
    # that is an array of hashtables containing properties Code and Phrase.
    # It is also nice to have a field named Status to simplify Test.
    # Feel free to add any additional properties that simplify your
    # testing or make this function valueable for other solutions.
    # Note: this is different behavior than Windows DSC.

    $return = @{
        status  = $status
        reasons = $reasons
    }

    return $return
}
