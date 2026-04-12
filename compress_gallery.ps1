Add-Type -AssemblyName System.Drawing

$galleryPath = "$PSScriptRoot\Gallery"
$maxWidth    = 1200
$maxHeight   = 1200
$jpegQuality = 80

$extensions = @("*.jpg","*.jpeg","*.JPG","*.JPEG","*.png","*.PNG")
$files = $extensions | ForEach-Object { Get-ChildItem -Path $galleryPath -Filter $_ -Recurse } | Sort-Object Name

$encoder = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq "image/jpeg" }
$encoderParams = New-Object System.Drawing.Imaging.EncoderParameters(1)
$encoderParams.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::Quality, [long]$jpegQuality)

$total = $files.Count
$i = 0

foreach ($file in $files) {
    $i++
    try {
        $oldSize = [math]::Round($file.Length / 1KB)
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

        $bitmap = New-Object System.Drawing.Bitmap($newW, $newH)
        $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
        $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
        $graphics.DrawImage($img, 0, 0, $newW, $newH)
        $graphics.Dispose()
        $img.Dispose()

        # Save to temp file first, then replace original
        $tmpFile = $file.FullName + ".tmp"
        $bitmap.Save($tmpFile, $encoder, $encoderParams)
        $bitmap.Dispose()

        Remove-Item $file.FullName -Force
        Rename-Item $tmpFile $file.FullName

        $newSize = [math]::Round((Get-Item $file.FullName).Length / 1KB)
        Write-Host "[$i/$total] $($file.Name): ${oldSize}KB -> ${newSize}KB"

    } catch {
        Write-Host "[$i/$total] ERROR on $($file.Name): $_"
        if (Test-Path ($file.FullName + ".tmp")) {
            Remove-Item ($file.FullName + ".tmp") -Force
        }
    }
}

$totalAfter = [math]::Round(($files | ForEach-Object { (Get-Item $_.FullName).Length } | Measure-Object -Sum).Sum / 1MB, 1)

Write-Host ""
Write-Host "Done! $total images processed."
Write-Host "Total gallery size after: ${totalAfter}MB"
