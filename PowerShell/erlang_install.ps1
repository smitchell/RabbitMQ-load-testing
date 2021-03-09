# SOURCE = https://gist.github.com/chgeuer/8342314
# VARS
$ERLANG_VERSION = "otp_win64_23.2.exe"
$ERLANG_URL = "http://erlang.org/download/" + $ERLANG_VERSION
$DOWNLOAD_PATH = $HOME + "\" + $ERLANG_VERSION
#
# Check if Erlang is installed
#
$erlangkey = Get-ChildItem HKLM:\SOFTWARE\Wow6432Node\Ericsson\Erlang -ErrorAction SilentlyContinue
if ( $erlangkey -eq $null ) {
	Write-Host "Erlang not found, need to install it"
	$WebClient = New-Object System.Net.WebClient
	$WebClient.DownloadFile($ERLANG_URL, $ERLANG_VERSION)
	Start-Process -Wait $DOWNLOAD_PATH  /S
}

#
# Determine Erlang home path
#
$ERLANG_HOME = ((Get-ChildItem HKLM:\SOFTWARE\Wow6432Node\Ericsson\Erlang)[0] | Get-ItemProperty).'(default)'
[System.Environment]::SetEnvironmentVariable("ERLANG_HOME", $ERLANG_HOME, "Machine")

#
# Add Erlang to the path if needed
#
$system_path_elems = [System.Environment]::GetEnvironmentVariable("PATH", "Machine").Split(";")
if (!$system_path_elems.Contains("%ERLANG_HOME%\bin") -and !$system_path_elems.Contains("$ERLANG_HOME\bin"))
{
	Write-Host "Adding erlang to path"
    $newpath = [System.String]::Join(";", $system_path_elems + "$ERLANG_HOME\bin")
    [System.Environment]::SetEnvironmentVariable("PATH", $newpath, "Machine")
}

# We should test if Erlang exists.
$GetRule =  Get-NetFirewallRule -DisplayName "Erlang"
New-NetFirewallRule  -program $ERLANG_HOME + "\bin\erl.exe" -Profile @('Domain', 'Private', 'Public') -Action Allow -Name "Erlang" -DisplayName "Erlang"
