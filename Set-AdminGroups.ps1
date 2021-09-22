function Set-AdminGroups {
       <#
    .SYNOPSIS
        Adds necessary administrative groups to clients

    .DESCRIPTION
         Adds the necessary admininstrative groups to clients

    .PARAMETER Computers
       Text file containing list of computers to have admin group added to them 

    .Notes
        Alter line 33 to correspond with the name of the admin group that you would
        like to add to the clients

        Change the file path on line 41 to prefered location to save the .csv list
        of clients that were offline.

    #>
    [CmdletBinding()]

    #path to file containting computerlists
    $Computers = Read-Host "file path of computer list"

    #variable storing list of computer names
    $ComputerList = Get-Content $Computers

    #uncomment to hardcode list into script
    #$ComputerList = Get-Content "<change file path here>"

    
    ForEach ($ComputerName in $ComputerList) {
        if (Test-Connection $ComputerName -Quiet) {
            Invoke-Command -computerName $ComputerName {
                Add-LocalGroupMember -Group "Administrators" -Member "na\<Name of Admin Group Here>" 
                write-output "Adding Admin group to $($env:computername)"
            }

        } else { 
           # $datestring = (Get-Date).ToString(“s”).Replace(“:”,”-”)
            
            #appends name of offline computers to csv file. Change file path as needed
            $ComputerName | format-table name | Out-File -Append "<changeFilePath.csv>"
    }
  }
}

Set-AdminGroups
