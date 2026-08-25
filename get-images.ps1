# Downloads the charts from your Wix CDN into assets\ with the filenames
# the project pages expect. Run once from the repo root, then delete this file.
#
#   cd C:\Users\danma\dvnzil.github.io
#   powershell -ExecutionPolicy Bypass -File .\get-images.ps1

$base = "https://static.wixstatic.com/media/"

$images = @{
  "stock-01-risk-distribution.png"   = "aededc_0e2356782b7f4659aa9d5b1d6b94b1e2~mv2.png"
  "stock-02-feature-heatmap.png"     = "aededc_38d55760cd9a41288d103add77b6d0f4~mv2.png"
  "stock-03-predicted-vs-actual.png" = "aededc_48f200d0c2d7486191e0e55fce593e5a~mv2.png"
  "stock-04-model-comparison.png"    = "aededc_b112b275053442e18a362eb1d01ca5f2~mv2.png"

  "credit-01-class-imbalance.png"    = "aededc_7e51dace47d24f77b913cc7e97f4201f~mv2.png"
  "credit-02-correlation-heatmap.png"= "aededc_c80c0e8dbe2441e3ae48593ad1a552b9~mv2.png"
  "credit-03-model-comparison.png"   = "aededc_09d7f19cca1b4327a9617ebc238a33c7~mv2.png"
  "credit-04-precision-recall.png"   = "aededc_7d4898ec83c140ea9fba782f7de86c63~mv2.png"

  "russia-01-inflation-full.png"     = "aededc_8645fb7e4fb9461daa31c394fc773d89~mv2.png"
  "russia-02-inflation-zoom.png"     = "aededc_a52f19f3dbda401b9f01120d2b7f416e~mv2.png"
  "russia-03-gdp-growth.png"         = "aededc_30e7ee2e15384826a01a784e2eb43a32~mv2.png"
  "russia-04-world-gdp-share.png"    = "aededc_d7f274e4b26a4de88d36b081413fe0a0~mv2.png"
  "russia-05-current-account.png"    = "aededc_a972f05841a64b4999c1966df974c029~mv2.png"
}

if (-not (Test-Path "assets")) { New-Item -ItemType Directory -Path "assets" | Out-Null }

$failed = @()
foreach ($name in $images.Keys) {
  $url = $base + $images[$name]
  $out = "assets\$name"
  try {
    Invoke-WebRequest -Uri $url -OutFile $out -ErrorAction Stop
    $kb = [math]::Round((Get-Item $out).Length / 1KB, 1)
    Write-Host "OK    $name  ($kb KB)"
  } catch {
    Write-Host "FAIL  $name" -ForegroundColor Red
    $failed += $name
  }
}

Write-Host ""
if ($failed.Count -eq 0) {
  Write-Host "All 13 images downloaded into assets\." -ForegroundColor Green
} else {
  Write-Host "$($failed.Count) failed:" -ForegroundColor Yellow
  $failed | ForEach-Object { Write-Host "  $_" }
  Write-Host "Save those manually from the Wix post (right-click - Save image as) into assets\ using the exact filenames above."
}
