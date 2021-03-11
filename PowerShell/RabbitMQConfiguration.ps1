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

Write-Host "Generating passwords."
Add-Type -AssemblyName System.Web
$admin_password = [System.Web.Security.Membership]::GeneratePassword(15,2)
$dev_admin = [System.Web.Security.Membership]::GeneratePassword(15,2)
$qa_password = [System.Web.Security.Membership]::GeneratePassword(15,2)
$uat_password = [System.Web.Security.Membership]::GeneratePassword(15,2)

# Enable RabbitMQ Management Plugins.
Write-Host "Enabling RabbitMQ management plugins."
Set-Location -Path "$rabbitHome\sbin\"
./rabbitmq-plugins enable rabbitmq_top

# Setup the Admin user.
Write-Host "Creating the admin user."
./rabbitmqctl add_user $admin_user "$admin_password"
./rabbitmqctl set_user_tags $admin_user "administrator"
./rabbitmqctl set_permissions -p "/" "admin" ".*" ".*" ".*"

# Create the vHosts.
Write-Host "Setting up dev vHost."
./rabbitmqctl add_vhost "dev"
./rabbitmqctl add_user $dev_user "$dev_admin"
./rabbitmqctl set_user_tags $dev_user "administrator"
./rabbitmqctl set_permissions -p "dev" $dev_user ".*" ".*" ".*"

# Setup qa.
Write-Host "Setting up qa vHost."
./rabbitmqctl add_vhost "qa"
./rabbitmqctl add_user $qa_user "$qa_password"
./rabbitmqctl set_user_tags $qa_user "administrator"
./rabbitmqctl set_permissions -p "qa" $qa_admin ".*" ".*" ".*"

# Setup uat.
Write-Host "Setting up uat vHost."
./rabbitmqctl add_vhost "uat"
./rabbitmqctl add_user $uat_user "$uat_password"
./rabbitmqctl set_user_tags $uat_user "administrator"
./rabbitmqctl set_permissions -p "uat" $uat_admin ".*" ".*" ".*"

Write-Host "admin password = $admin_password"
Write-Host "dev_admin password = $dev_admin"
Write-Host "qa_admin password = $qa_password"
Write-Host "uat_admin password = $uat_password"
Write-Host "http://localhost:15672" 
