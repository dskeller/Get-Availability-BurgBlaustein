<#
  Get-Availability-BurgBlaustein.ps1

  (c) dskeller 12/2022
  Version 1.1

  Query german bluebrixx websites for Availabilty of Blaustein Castle by searching for labels marking set out of stock or announced or comingsoon
#>
[CmdletBinding()]
param (
    [Parameter()]
    [string]
    $PartsFile = ".\BurgBlaustein.xml"
)

function Import-XML($fileName){
	$returnValue = $false
	try{
		$returnValue = [xml](Get-Content $fileName -ErrorAction Stop)
	}catch{
		Write-Host -BackgroundColor Black -ForegroundColor Red "Error while reading XML file '$fileName', Fehler war '$_'"
	}
	return $returnValue
}

if ($($PartsFile.Substring(0,2)) -eq '.\'){
    $PartsFile = $PSScriptRoot+'\'+$($PartsFile.Substring(2))
}
$XMLFile = Import-XML -fileName $PartsFile

foreach ($element in $XMLFile.List.Parts.Part){
  $name = $element.Name
  $url  = $element.Link
  
  # Get web page content
  $webres = Invoke-RestMethod $url

  if ($webres.ToString() -split "[`r`n]" | select-string -SimpleMatch "mainPicContainer" | Select-String -SimpleMatch 'div class="label_unavailable"'){Write-Host "$name  " -NoNewline ; Write-Host "ZURZEIT VERGRIFFEN" -ForegroundColor Red}
  elseif ($webres.ToString() -split "[`r`n]" | select-string -SimpleMatch "mainPicContainer" | Select-String -SimpleMatch 'div class="label_announcement"'){Write-Host "$name  " -NoNewline ; Write-Host "ANKÜNDIGUNG" -ForegroundColor Yellow}
  elseif ($webres.ToString() -split "[`r`n]" | select-string -SimpleMatch "mainPicContainer" | Select-String -SimpleMatch 'div class="label_comingsoon"'){Write-Host "$name  " -NoNewline ; Write-Host "BALD ERHÄLTLICH" -ForegroundColor Yellow}
  else{Write-Host "$name  " -NoNewline; Write-Host "VERFÜGBAR" -ForegroundColor Green}
}