
Add-Type -AssemblyName System.Drawing
$sourcePath = "c:\Users\kjak_\OneDrive\Desktop\Github\openhouse\hero-image.jpg"
$destPath = "c:\Users\kjak_\OneDrive\Desktop\Github\openhouse\hero-image-web.jpg"

if (Test-Path $sourcePath) {
    Write-Host "Resizing $sourcePath..."
    $image = [System.Drawing.Image]::FromFile($sourcePath)
    
    # Calculate new height to maintain aspect ratio
    $newWidth = 1920
    $factor = $newWidth / $image.Width
    $newHeight = [int]($image.Height * $factor)
    
    $resized = new-object System.Drawing.Bitmap($newWidth, $newHeight)
    $graph = [System.Drawing.Graphics]::FromImage($resized)
    $graph.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $graph.DrawImage($image, 0, 0, $newWidth, $newHeight)
    
    # Save as JPEG with 80 quality
    $codec = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq "image/jpeg" }
    $encoderParams = New-Object System.Drawing.Imaging.EncoderParameters(1)
    $encoderParams.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::Quality, 80)
    
    $resized.Save($destPath, $codec, $encoderParams)
    
    $image.Dispose()
    $resized.Dispose()
    Write-Host "Created $destPath"
} else {
    Write-Error "Source file not found: $sourcePath"
}
