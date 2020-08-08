Import-Module posh-git
Import-Module Go

. "$PSScriptRoot\Scripts\Invoke-ElevatedCommand.ps1"

Set-Alias iec Invoke-ElevatedCommand

function Reset-Git {
	$target = ''
	if ($args){
		$target = "origin/$args"
	}
	else {
		$current = (&git rev-parse --abbrev-ref HEAD)
		$target = "origin/$current"
	}

	Write-Host "Performing fetch and hard reset to $target..."
	$headBefore = (&git rev-parse HEAD)
	& git fetch -p;git reset --hard $target
	$headAfter = (&git rev-parse HEAD)
	Write-Host "...done."
	Write-Host
	Write-Host "HEAD before: $headBefore"
	Write-Host "HEAD after: $headAfter"
}

function Find-GitLocalMerged {
	Write-Host "git branch --merged | %{$_.trim()} | ?{$_ -notmatch 'develop' -and $_ -notmatch 'master'}}"
	& git branch --merged | %{$_.trim()} | ?{$_ -notmatch 'develop' -and $_ -notmatch 'master'}
}

function Clean-GitLocalMerged {
	Write-Host "git branch --merged | %{$_.trim()} | ?{$_ -notmatch 'develop' -and $_ -notmatch 'master'} | %{git branch -d $_}"
	& git branch --merged | %{$_.trim()} | ?{$_ -notmatch 'develop' -and $_ -notmatch 'master'} | %{git branch -d $_}
}

function Help-Me {
	Write-Host "My Custom Functions"
	Write-Host "==================="
	Write-Host "   Invoke-ElevatedCommand (iec)"
	Write-Host "   Reset-Git"
	Write-Host "   Find-GitLocalMerged"
	Write-Host "   Clean-GitLocalMerged"
	Write-Host
}
