<#
.SYNOPSIS
Configures RabbitMQ.

=======================================================================================
AUTHOR:  Steve Mitchell
DATE:    3/9/2021
Version: 1.0
=======================================================================================
#>

# Configurable settings.
$rabbitVersion = "3.8.14"
$rabbitHome = "C:\Program Files\RabbitMQ Server\rabbitmq_server-$rabbitVersion"
$admin_user = "admin"
$dev_user = "dev_admin"
$qa_user = ”qa_admin"
$uat_user = "uat_admin"
$config_access = ".*"
$write_access = ".*"
$read_access = ".*"
$rabbitmq_url = "http://localhost:15672"

Write-Host "Generating passwords."
Add-Type -AssemblyName System.Web
$admin_password = ([char[]]([char]'a'..[char]'z') + 0..9 | sort {get-random})[0..15] -join ''
$dev_password = ([char[]]([char]'a'..[char]'z') + 0..9 | sort {get-random})[0..15] -join ''
$qa_password = ([char[]]([char]'a'..[char]'z') + 0..9 | sort {get-random})[0..15] -join ''
$uat_password = ([char[]]([char]'a'..[char]'z') + 0..9 | sort {get-random})[0..15] -join ''

# Enable RabbitMQ Management Plugins.
Write-Host "Enabling RabbitMQ management plugins."
Set-Location -Path "$rabbitHome\sbin\"
./rabbitmq-plugins enable rabbitmq_management rabbitmq_auth_backend_ldap rabbitmq_top

# Setup the Admin user.
Write-Host "Creating the admin user."
./rabbitmqctl add_user $admin_user "$admin_password"
./rabbitmqctl set_user_tags $admin_user "administrator"
./rabbitmqctl set_permissions -p "/" "admin" $config_access $write_access $read_access

# Delete the Guest user
Write-Host "Deleting the guest user."
./rabbitmqctl delete_user "guest”

# Create the vHosts.
Write-Host "Setting up dev vHost."
./rabbitmqctl add_vhost "dev"
./rabbitmqctl add_user $dev_user "$dev_password"
./rabbitmqctl set_user_tags $dev_user "administrator"
./rabbitmqctl set_permissions -p "dev" $dev_user $config_access $write_access $read_access

# Setup qa.
Write-Host "Setting up qa vHost."
./rabbitmqctl add_vhost "qa"
./rabbitmqctl add_user $qa_user "$qa_password"
./rabbitmqctl set_user_tags $qa_user "administrator"
./rabbitmqctl set_permissions -p "qa" $qa_user $config_access $write_access $read_access

# Setup uat.
Write-Host "Setting up uat vHost."
./rabbitmqctl add_vhost "uat"
./rabbitmqctl add_user $uat_user "$uat_password"
./rabbitmqctl set_user_tags $uat_user "administrator"
./rabbitmqctl set_permissions -p "uat" $uat_user $config_access $write_access $read_access

Write-Host "$admin_user password = '$admin_password'"
Write-Host "$dev_user password = '$dev_password'"
Write-Host "$qa_user password = '$qa_password'"
Write-Host "$uat_user password = '$uat_password'"
Write-Host "$rabbitmq_url"

Write-Host "***   SAVE THESE USER IDS AND PASSWORDS   ***" -ForegroundColor Yellow
Write-Host "$admin_user password = $admin_password" -ForegroundColor Yellow
Write-Host "$dev_user password = $dev_password" -ForegroundColor Yellow
Write-Host "$qa_user password = $qa_password" -ForegroundColor Yellow
Write-Host "$uat_user password = $uat_password" -ForegroundColor Yellow

