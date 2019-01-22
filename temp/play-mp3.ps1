
#Add-Type -AssemblyName presentationCore
$mediaPlayer = New-Object system.windows.media.mediaplayer
$mediaPlayer.open('C:\github\powershell_new\ALARM9.WAV')
$mediaPlayer.Play()