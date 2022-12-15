<#
  Get-Availability-BurgBlaustein.ps1

  (c) dskeller 12/2022
  Version 1.0

  Query german bluebrixx websites for Availabilty of Blaustein Castle by searching for labels marking set out of stock or announced or comingsoon
#>

$List = @("Burg Blaustein|https://www.bluebrixx.com/de/knights/102818/Burg-Blaustein-BlueBrixx-Special","Bergfried Erweiterung|https://www.bluebrixx.com/de/neuheiten/103406/Bergfried-Erweiterung-fuer-Burg-Blaustein-BlueBrixx-Special","Vorburg Erweiterung|https://www.bluebrixx.com/de/knights/104185/Vorburg-Erweiterung-fuer-Burg-Blaustein-BlueBrixx-Special","Saalbau Erweiterung|https://www.bluebrixx.com/de/knights/104953/Saalbau-Erweiterung-fuer-Burg-Blaustein-BlueBrixx-Special","Hurde Erweiterung|https://www.bluebrixx.com/de/knights/105236/Hurde-Erweiterung-fuer-Burg-Blaustein-BlueBrixx-Special")

foreach ($element in $List){
  $name = ($element.split('|'))[0]
  $url  = ($element.split('|'))[1]
  
  $webres = Invoke-RestMethod $url

  if ($webres.ToString() -split "[`r`n]" | select-string -SimpleMatch "mainPicContainer" | Select-String -SimpleMatch 'div class="label_unavailable"'){Write-Host "$name  " -NoNewline ; Write-Host "ZURZEIT VERGRIFFEN" -ForegroundColor Red}
  elseif ($webres.ToString() -split "[`r`n]" | select-string -SimpleMatch "mainPicContainer" | Select-String -SimpleMatch 'div class="label_announcement"'){Write-Host "$name  " -NoNewline ; Write-Host "ANKÜNDIGUNG" -ForegroundColor Yellow}
  elseif ($webres.ToString() -split "[`r`n]" | select-string -SimpleMatch "mainPicContainer" | Select-String -SimpleMatch 'div class="label_comingsoon"'){Write-Host "$name  " -NoNewline ; Write-Host "BALD ERHÄLTLICH" -ForegroundColor Yellow}
  else{Write-Host "$name  " -NoNewline; Write-Host "VERFÜGBAR" -ForegroundColor Green}

}