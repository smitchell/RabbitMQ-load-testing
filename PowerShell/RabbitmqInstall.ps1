<#
.SYNOPSIS
Installs RabbitMQ.
Start-Process PowerShell -Verb RunAs

=======================================================================================
AUTHOR:  Steve Mitchell
DATE:    3/9/2021
Version: 1.0
=======================================================================================

#>

# Configurable settings.
$erlVersion = "23.2"
$erlangInstallFile = "otp_win64_$erlVersion.exe"
$rabbitVersion = "3.8.14"
$rabbitInstaller = "rabbitmq-server-$rabbitVersion.exe"

# Check if Erlang is installed.
$erlangkey = Get-ChildItem HKLM:\SOFTWARE\Wow6432Node\Ericsson\Erlang -ErrorAction SilentlyContinue
if ($null -eq $erlangkey) {
	$webClient = New-Object System.Net.WebClient
	Write-Host "Downloading and installing Erlang." -ForegroundColor Yellow
	$webClient.DownloadFile("https://erlang.org/download/" + $erlangInstallFile, $env:TEMP + "\" + $erlangInstallFile)
	Start-Process -Wait ($env:TEMP + "\" + $erlangInstallFile) /S
}

# Set the Erlang home path.
$ERLANG_HOME = ((Get-ChildItem HKLM:\SOFTWARE\Wow6432Node\Ericsson\Erlang)[0] | Get-ItemProperty)."(default)"
[System.Environment]::SetEnvironmentVariable("ERLANG_HOME", $ERLANG_HOME , "Machine")

# Add Erlang to the Path if needed.
$systemPath = [System.Environment]::GetEnvironmentVariable("PATH", "Machine")
$systemPathElems = $systemPath.Split(";")
if (!$systemPathElems.Contains("$ERLANG_HOME\bin") -and !$systemPathElems.Contains($ERLANG_HOME + "\bin"))
{
	Write-Host "Adding Erlang to path."
	$newPath = $systemPath.Trim(";") + ";$ERLANG_HOME\bin"
	[System.Environment]::SetEnvironmentVariable("PATH", $newPath, "Machine")
}

# Create a firewall rules if needed.
$firewallRule =  Get-NetFirewallRule -DisplayName "Erlang" -ErrorAction SilentlyContinue
if ($null -eq $firewallRule) {
	Write-Host "Creating firewall rule for Erlang." -ForegroundColor Yellow
	New-NetFirewallRule -Group "Erlang" -Program "$ERLANG_HOME\bin\erl.exe" -Profile @("Domain", "Private", "Public") -Action Allow -Name "Erlang" -DisplayName "Erlang"
}

$firewallRule =  Get-NetFirewallRule -DisplayName "Erlang Run-time System" -ErrorAction SilentlyContinue
if ($firewallRule) {
	Write-Host "Creating firewall rule for Erlang Run-time System." -ForegroundColor Yellow
	New-NetFirewallRule -Group "Erlang" -Program "$ERLANG_HOME\erts-{ertsVersion}\bin\erl.exe" -Profile @("Domain", "Private", "Public") -Action Allow -Name "Erlang Run-time System" -DisplayName "Erlang Run-time System"
}

$firewallRule =  Get-NetFirewallRule -DisplayName "Erlang Port Mapper Daemon" -ErrorAction SilentlyContinue
if ($null -eq $firewallRule) {
	Write-Host "Creating firewall rule for Erlang Run-time System." -ForegroundColor Yellow
	New-NetFirewallRule -Group "Erlang" -Program "$ERLANG_HOME\erts-{ertsVersion}\bin\epmd.exe" -Profile @("Domain", "Private", "Public") -Action Allow -Name "Erlang Port Mapper Daemon" -DisplayName "Erlang Port Mapper Daemon"
}

# Check if RabbitMQ is installed.
$rabbitHome = "C:\Program Files\RabbitMQ Server\rabbitmq_server-$rabbitVersion"

if (!(Test-Path "$rabbitHome\sbin\rabbitmq-server.bat" -PathType Leaf))
{
	$webClient = New-Object System.Net.WebClient
	Write-Host "Downloading and installing RabbitMQ." -ForegroundColor Yellow
	$webClient.DownloadFile("https://github.com/rabbitmq/rabbitmq-server/releases/download/v$rabbitVersion/$rabbitInstaller", $env:TEMP + "\" + $rabbitInstaller)

	$proc = Start-Process ($env:TEMP + "\" + $rabbitInstaller) /S -Wait:$false -Passthru
	Wait-Process -Id $proc.Id
}

# Create a firewall rules if needed.
$firewallRule =  Get-NetFirewallRule -DisplayName "RabbitMQ" -ErrorAction SilentlyContinue
if ($null -eq $firewallRule) {
	Write-Host "Creating firewall rule for RabbitMQ." -ForegroundColor Yellow
	New-NetFirewallRule -Name 'RabbitMQ' -DisplayName 'RabbitMQ' -Profile @('Domain', 'Private', 'Public') -Direction Inbound -Action Allow -Protocol TCP -LocalPort @('5672', '15672')
}
