# Created by Justin Henderson
# Last updated on 5/7/2015
#
# Set this to "Security" if being ran locally
# Set this to "Forwarded Events" if being used on a Windows Event Collector (Event Forwarding)
$EventLog = "Security"
# Set this to the reoccuring time frame of how often this script gets ran
# Example: if you run this every 15 minutes set it to 15
$Minutes = 15

$date = (Get-Date).AddMinutes(-($Minutes))
$logs = Get-EventLog $EventLog -After $date | Where-Object {$_.EventId -eq 4625 -and $_.Message -match "SMAPPER" -and $_.Message -match "administrator" -or $_.EventId -eq 4624  -and $_.Message -match "SMAPPER" -and $_.Message -match "administrator"}
$count = $logs.count

if ($count -gt 0){
    Write-Host "Sending email"
    $EmailFrom = "YourGmailAccount@gmail.com"
    $EmailTo = "EmailToAddress@yourdomain.com" 
    $Subject = "HoneyToken Used" 
    $Body = "The MimikatzHoneyToken has been used. Pleased investigate immediately.  See below for more details." 
    $Body += $logs | ForEach-Object { $_.Message }
    $SMTPServer = "smtp.gmail.com" 
    $SMTPClient = New-Object Net.Mail.SmtpClient($SmtpServer, 587) 
    $SMTPClient.EnableSsl = $true 
    $SMTPClient.Credentials = New-Object System.Net.NetworkCredential("GmailUserName", 'GmailPassword'); 
    $SMTPClient.Send($EmailFrom, $EmailTo, $Subject, $Body)
}