<#
.SYNOPSIS
Configures RabbitMQ.

=======================================================================================
AUTHOR:  Steve Mitchell
DATE:    3/9/2021
Version: 1.0
=======================================================================================

#>
Add-Type -AssemblyName System.Web

# Configurable settings.
$rabbitVersion = "3.8.14"
$rabbitHome = "C:\Program Files\RabbitMQ Server\rabbitmq_server-$rabbitVersion"
$admin_user = "admin"
$test_user = "test_admin"
$qa_user = ”qa_admin"
$uat_user = "uat_admin"

Write-Host "Generating passwords." -ForegroundColor Yellow
$admin_password = [System.Web.Security.Membership]::GeneratePassword(15,0)
$test_password = [System.Web.Security.Membership]::GeneratePassword(15,0)
$qa_password = [System.Web.Security.Membership]::GeneratePassword(15,0)
$uat_password = [System.Web.Security.Membership]::GeneratePassword(15,0)

# Enable RabbitMQ Management Plugins
Write-Host "Enabling RabbitMQ management plugins." -ForegroundColor Yellow
Set-Location -Path "$rabbitHome\sbin\"
./rabbitmq-plugins enable rabbitmq_top

# Setup the Admin user
Write-Host "Creating the admin user." -ForegroundColor Yellow
./rabbitmqctl add_user $admin_user "$admin_password"
./rabbitmqctl set_user_tags $admin_user "administrator"
./rabbitmqctl set_permissions -p "/" "admin" ".*" ".*" ".*"

# Create the vHosts
Write-Host "Setting up test vHost." -ForegroundColor Yellow
./rabbitmqctl add_vhost "test"
./rabbitmqctl add_user $test_user "$test_password"
./rabbitmqctl set_user_tags $test_user "administrator"
./rabbitmqctl set_permissions -p "test" $test_user ".*" ".*" ".*"

## Setup qa
Write-Host "Setting up qa vHost." -ForegroundColor Yellow
./rabbitmqctl add_vhost "qa"
./rabbitmqctl add_user $qa_user "$qa_password"
./rabbitmqctl set_user_tags $qa_user "administrator"
./rabbitmqctl set_permissions -p "qa" "qa_admin" ".*" ".*" ".*"

## Setup uat
Write-Host "Setting up uat vHost." -ForegroundColor Yellow
./rabbitmqctl add_vhost "uat"
./rabbitmqctl add_user $uat_user "$uat_password"
./rabbitmqctl set_user_tags $uat_user "administrator"
./rabbitmqctl set_permissions -p "uat" "uat_admin" ".*" ".*" ".*"

Write-Host "admin password = $admin_password" -ForegroundColor Yellow
Write-Host "test_admin password = $test_password" -ForegroundColor Yellow
Write-Host "qa_admin password = $qa_password" -ForegroundColor Yellow
Write-Host "uat_admin password = $uat_password" -ForegroundColor Yellow
Write-Host "http://localhost:15672" -ForegroundColor Yellow
