# RabbitMQ Load Testing

The purpose of this project is to set-up, then test a RabbitMQ cluster.

# Setup

This set is for Windows servers running on Azure.

## Install Erlang

[Download Erlang](https://www.erlang.org/downloads) and run the the installation. Accept the default values.

Open the Erland ports, in the case of Windows, add the following firewall rules:

### Erlang

|   Rule Type	|   Program	|
|---	|---	|
|   Program Path	|   %ProgramFiles%\erl-23.2.7\bin\erl.exe	|
|   Action	|   Allow the connection	|
|   Profile	|   Domain, Private, Public	|
|   Name	|   Erlang	|

### Erlang Run-time System Port

|   Rule Type	|   Program	|
|---	|---	|
|   Program Path	|   %ProgramFiles%\erl-23.2.7\erts-11.1.8\bin\erl.exe	|
|   Action	|   Allow the connection	|
|   Profile	|   Domain, Private, Public	|
|   Name	|   Erlang Run-time System	|

### Erlang Port Mapper Daemon

|   Rule Type	|   Program	|
|---	|---	|
|   Program Path	|   %ProgramFiles%\erl-23.2.7\erts-11.1.8\bin\epmd.exe	|
|   Action	|   Allow the connection	|
|   Profile	|   Domain, Private, Public	|
|   Name	|   Erlang Port Mapper Daemon	|

## Install RabbitMQ 

[Download RabbitMQ](https://www.rabbitmq.com/install-windows.html#installer) and run the installer. Accept the default values.

### Open the RabbitMQ Ports

|   Rule Type	|   Program	|
|---	|---	|
|   Protocols and Ports	|   TCP	|
|   Specified local ports	|   5672, 15672	|
|   Action	|   Allow the connection	|
|   Profile	|   Domain, Private, Public	|
|   Name	|   RabbitMQ	|

### Enable the RabbitMQ Plugins

```
cd C:\Program Files\RabbitMQ Server\rabbitmq_server-3.8.14\sbin
rabbit_plugins enable rabbitmq_management
```

### Add an Admin User

```
cd C:\Program Files\RabbitMQ Server\rabbitmq_server-3.8.14\sbin
rabbitmqctl add_user admin [THE PASSWORD]
Adding user "admin" ...
Done. Don't forget to grant the user permissions to some virtual hosts! See 'rabbitmqctl help set_permissions' to learn more.

rabbitmqctl set_user_tags test administrator
Setting tags for user ”admin" to [administrator] ...

rabbitmqctl set_permissions -p / admin ".*" ".*" ".*"
Setting permissions for user ”admin" in vhost "/" ...
```
