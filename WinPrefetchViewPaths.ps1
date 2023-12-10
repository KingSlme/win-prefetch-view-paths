function Main {
    $errorActionPreference = 'SilentlyContinue'
    Clear-Host
    Display-Logo
    Get-Input
}

function Display-Logo {
    Write-Host "-------------------------------------------------------" -f Blue
    Write-Host "`|                 WinPrefetchViewPaths                `|" -f Blue
    Write-Host "`| https://github.com/KingSlme/win-prefetch-view-paths `|" -f Blue
    Write-Host "-------------------------------------------------------" -f Blue
}

function Get-Input {
    $paths = @()
    Write-Host "`nEnter the WinPrefetchView items to scan." -f Blue
    while ($true) {
        Write-Host "-> " -f Yellow -NoNewline
        $inputPath = Read-Host
        if ($inputPath -eq ".parse") {
            break
        }
        $paths += $inputPath
    }
    if ($paths.Count -eq 0) {
        Write-Host "You must enter at least one item to scan." -f Red
        while ($true) {
            Write-Host "-> " -f Yellow -NoNewline
            $inputPath = Read-Host
            if ($inputPath -eq ".parse") {
                break
            }
            $paths += $inputPath
        }
    }
    $paths = $paths | Where-Object { $_.Trim().Length -gt 0 } | Select-Object -Unique
    Handle-Input -paths $paths
}

function Handle-Input {
    param (
        [Parameter(Mandatory=$true)]
        [string[]]$paths
    ) 
    $foundPrefetchPaths = @()
    $notFoundPrefetchPaths = @()
    foreach($string in $paths) {
        $match = [regex]::Match($string, "[a-zA-Z]:\\")
        if ($match.Success) {
            $index = $match.Index
            # Extract the substring from the letter followed by :\ up until a /
            $substring = $string.Substring($index, $string.IndexOf("/", $index) - $index)
            # Remove anything after the last letter character of the substring
            $substring = [regex]::Replace($substring, "[^a-zA-Z]*$", "")
            $foundPrefetchPaths += $substring
        } else {
            $notFoundPrefetchPaths += $string
        }
    }
    Write-Host "Not Found Paths:" -f Blue 
    foreach($notFoundPath in $notFoundPrefetchPaths) {
        # Gets substring ending in .pf (simplifies result)
        $notFoundPathSubstring = $notFoundPath.Substring(0, $notFoundPath.IndexOf(".pf") + 3)
        Write-host $notFoundPathSubstring -f Green
    }
    Write-Host "Fond Paths:" -f Blue
    foreach($foundPath in $foundPrefetchPaths) {
        Write-Host $foundPath -f Green
    }
}

Main