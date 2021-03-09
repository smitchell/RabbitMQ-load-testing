# SOURCE = https://gist.github.com/chgeuer/8342314
#
# Check if Erlang is installed
#
$erlangkey = Get-ChildItem HKLM:\SOFTWARE\Wow6432Node\Ericsson\Erlang -ErrorAction SilentlyContinue
if ( $erlangkey -eq $null ) {
	Write-Host "Erlang not found, need to install it"
	$WebClient = New-Object System.Net.WebClient
	$WebClient.DownloadFile("http://erlang.org/download/otp_win64_23.2.exe", "C:\Users\smitchell\otp_win64_23.2.exe")
	Start-Process -Wait otp_win64_23.2.exe /S
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
New-NetFirewallRule  -program "%ProgramFiles%\erl-23.2.7\bin\erl.exe" -Profile @('Domain', 'Private', 'Public') -Action Allow -Name "Erlang" -DisplayName "Erlang"
