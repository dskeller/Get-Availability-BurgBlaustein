<#
  Get-Availability-BurgBlaustein.ps1

  (c) dskeller 12/2022
  Version 1.0

  Query english bluebrixx websites for Availabilty of Blaustein Castle by searching for labels marking set out of stock or announced or comingsoon
#>

$List = @("Blaustein Castle|https://www.bluebrixx.com/en/knights/102818/Blaustein-Castle-BlueBrixx-Special","Extension 'Castle Keep'|https://www.bluebrixx.com/en/knights/103406/Castle-keep-extension-for-Blaustein-Castle-BlueBrixx-Special","Extension 'Outer Bailey'|https://www.bluebrixx.com/en/knights/104185/Outer-bailey-extension-for-Blaustein-Castle-BlueBrixx-Special","Extension 'Hall'|https://www.bluebrixx.com/en/knights/104953/Hall-extension-for-Blaustein-Castle-BlueBrixx-Special","Extension 'Weir Walk'|https://www.bluebrixx.com/en/knights/105236/Weir-walk-extension-for-Blaustein-Castle-BlueBrixx-Special")

foreach ($element in $List){
  $name = ($element.split('|'))[0]
  $url  = ($element.split('|'))[1]
  
  $webres = Invoke-RestMethod $url

  if ($webres.ToString() -split "[`r`n]" | select-string -SimpleMatch "mainPicContainer" | Select-String -SimpleMatch 'div class="label_unavailable"'){Write-Host "$name  " -NoNewline ; Write-Host "CURRENTLY OUT OF STOCK" -ForegroundColor Red}
  elseif ($webres.ToString() -split "[`r`n]" | select-string -SimpleMatch "mainPicContainer" | Select-String -SimpleMatch 'div class="label_announcement"'){Write-Host "$name  " -NoNewline ; Write-Host "ANNOUNCEMENT" -ForegroundColor Yellow}
  elseif ($webres.ToString() -split "[`r`n]" | select-string -SimpleMatch "mainPicContainer" | Select-String -SimpleMatch 'div class="label_comingsoon"'){Write-Host "$name  " -NoNewline ; Write-Host "COMING SOON" -ForegroundColor Yellow}
  else{Write-Host "$name  " -NoNewline; Write-Host "AVAILABLE" -ForegroundColor Green}

}