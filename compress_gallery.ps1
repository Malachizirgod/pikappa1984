Add-Type -AssemblyName System.Drawing

$galleryPath = "$PSScriptRoot\Gallery"
$backupPath  = "$PSScriptRoot\Gallery_originals"
$maxWidth    = 1200
$maxHeight   = 1200
$jpegQuality = 80

if (-not (Test-Path $backupPath)) {
    New-Item -ItemType Directory -Path $backupPath | Out-Null
    Write-Host "Created backup folder: Gallery_originals"
}

$extensions = @("*.jpg","*.jpeg","*.JPG","*.JPEG","*.png","*.PNG")
$files = $extensions | ForEach-Object { Get-ChildItem -Path $galleryPath -Filter $_ -Recurse } | Sort-Object Name

$encoder = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq "image/jpeg" }
$encoderParams = New-Object System.Drawing.Imaging.EncoderParameters(1)
$encoderParams.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::Quality, [long]$jpegQuality)

$total = $files.Count
$i = 0

foreach ($file in $files) {
    $i++
    $relativePath = $file.FullName.Substring($galleryPath.Length + 1)
    $backupDest = Join-Path $backupPath $relativePath
    $backupDir = Split-Path $backupDest -Parent
    if (-not (Test-Path $backupDir)) { New-Item -ItemType Directory -Path $backupDir -Force | Out-Null }

    if (Test-Path $backupDest) {
        Write-Host "[$i/$total] Skipping $($file.Name) - already processed"
        continue
    }

    try {
        $img   = [System.Drawing.Image]::FromFile($file.FullName)
        $origW = $img.Width
        $origH = $img.Height

        $ratio = [Math]::Min($maxWidth / $origW, $maxHeight / $origH)

        if ($ratio -ge 1) {
            $newW = $origW
            $newH = $origH
        } else {
            $newW = [int]($origW * $ratio)
            $newH = [int]($origH * $ratio)
        }

        Copy-Item $file.FullName $backupDest

        $bitmap = New-Object System.Drawing.Bitmap($newW, $newH)
        $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
        $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
        $graphics.DrawImage($img, 0, 0, $newW, $newH)
        $graphics.Dispose()
        $img.Dispose()

        $bitmap.Save($file.FullName, $encoder, $encoderParams)
        $bitmap.Dispose()

        $newSize = [math]::Round((Get-Item $file.FullName).Length / 1KB)
        $oldSize = [math]::Round((Get-Item $backupDest).Length / 1MB, 1)
        Write-Host "[$i/$total] $($file.Name): ${oldSize}MB -> ${newSize}KB"

    } catch {
        Write-Host "[$i/$total] ERROR on $($file.Name): $_"
        if (Test-Path $backupDest) {
            Copy-Item $backupDest $file.FullName -Force
        }
    }
}

$totalAfter = [math]::Round(($files | ForEach-Object { (Get-Item $_.FullName).Length } | Measure-Object -Sum).Sum / 1MB, 1)

Write-Host ""
Write-Host "Done! $total images processed."
Write-Host "Total gallery size after: ${totalAfter}MB"
Write-Host "Originals saved in: Gallery_originals"
