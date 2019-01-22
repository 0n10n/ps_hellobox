############################################################################## 
## 
## Based on https://gallery.technet.microsoft.com/scriptcenter/Powershell-Script-for-13a551b3
## 
############################################################################## 

Function PlaySound 
{
	$Path = "C:\alipay2\ALARM9.WAV"
	$soundplayer = New-Object Media.SoundPlayer $Path
	$soundplayer.PlaySync()
}

 
## The URI list to test 
$URLListFile = ".\URLList.txt"  
$URLList = Get-Content $URLListFile -ErrorAction SilentlyContinue 
$Result = @() 
   

Foreach($Uri in $URLList) { 
  $time = try{ 
  $request = $null 
   ## Request the URI, and measure how long the response took. 
  write-host $Uri
  $result1 = Measure-Command { $request = Invoke-WebRequest -Uri $uri } 
  $result1.TotalMilliseconds 
  }  
  catch 
  { 
   $request = $_.Exception.Response 
   PlaySound
   $time = -1 
  }   
  $result += [PSCustomObject] @{ 
  Time = Get-Date; 
  Uri = $uri; 
  StatusCode = [int] $request.StatusCode; 
  StatusDescription = $request.StatusDescription; 
  ResponseLength = $request.RawContentLength; 
  TimeTaken =  $time;  
  } 
  
  if ($request.StatusCode -ne 200 ) {
	PlaySound;
  } else {
	write-host $request.StatusCode
  }
  
} 
