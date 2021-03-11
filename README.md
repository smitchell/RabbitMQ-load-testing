# RabbitMQ Load Testing

The purpose of this project is to set-up, then test a RabbitMQ cluster.

# Setup

This set is for Windows servers running on Azure. The fastest way to setup RabbitMQ for testing is with Docker:

## RabbitMQ Node 1
```
docker run -d \
    --hostname rabbitmq1 \
    --name rabbitmq1 \
    --publish 4369:4369 \
    --publish 5671:5671 \
    --publish 5672:5672 \
    --publish 15671:15671 \
    --publish 15672:15672 \
    --publish 25672:25672 \
    --volume=/Users/stevemitchell/Development/RabbitMQ/rabbitmqload-test/rabbitmq.config:/etc/rabbitmq/rabbitmq.config \
    --volume=/Users/stevemitchell/Development/RabbitMQ/rabbitmqload-test/definitions.json:/etc/rabbitmq/definitions.json \
    -e RABBITMQ_ERLANG_COOKIE=0b396ed8-8011-11eb-9439-0242ac130002 \
    -e RABBITMQ_NODE_NAME=rabbitmq1 \
    -e RABBITMQ_DEFAULT_USER=rabbit-admin \
    -e RABBITMQ_DEFAULT_PASS=changeMe! \
    rabbitmq:3-management
```

## RabbitMQ Node 2
```
docker run -d \
    --hostname rabbitmq2 \
    --name rabbitmq2 \
    --volume=/Users/stevemitchell/Development/RabbitMQ/rabbitmqload-test/rabbitmq.config:/etc/rabbitmq/rabbitmq.config \
    --volume=/Users/stevemitchell/Development/RabbitMQ/rabbitmqload-test/definitions.json:/etc/rabbitmq/definitions.json \
    -e RABBITMQ_ERLANG_COOKIE=0b396ed8-8011-11eb-9439-0242ac130002 \
    -e RABBITMQ_NODE_NAME=rabbitmq2 \
    --link=rabbitmq1:rabbitmq1 \
    rabbitmq:3-management
```


## RabbitMQ Node 3
```
docker run -d \
    --hostname rabbitmq3 \
    --name rabbitmq3 \
    --volume=/Users/stevemitchell/Development/RabbitMQ/rabbitmqload-test/rabbitmq.config:/etc/rabbitmq/rabbitmq.config \
    --volume=/Users/stevemitchell/Development/RabbitMQ/rabbitmqload-test/definitions.json:/etc/rabbitmq/definitions.json \
    -e RABBITMQ_ERLANG_COOKIE=0b396ed8-8011-11eb-9439-0242ac130002 \
    -e RABBITMQ_NODE_NAME=rabbitmq3 \
    --link=rabbitmq1:rabbitmq1 \
    --link=rabbitmq2:rabbitmq2
    rabbitmq:3-management
```

You can then go to http://localhost:8080 or http://host-ip:8080 in a browser and use the credentials guest/guest

## Install Erlang

[Download Erlang](https://www.erlang.org/downloads) and run the installation. Accept the default values.

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
./rabbitmqctl add_user "admin" "changeme"
Adding user "admin" ...
Done. Don't forget to grant the user permissions to some virtual hosts! See 'rabbitmqctl help set_permissions' to learn more.

./rabbitmqctl set_user_tags ”admin" "administrator"
Setting tags for user ”admin" to [administrator] ...

./rabbitmqctl set_permissions -p / "admin" ".*" ".*" ".*"
Setting permissions for user ”admin" in vhost "/" ...
```

## Setup Environments


## Setup Test
./rabbitmqctl add_vhost "test"
./rabbitmqctl add_user "test_admin" "54f0419bed25491694087067683a9eec"
./rabbitmqctl set_user_tags ”test_admin" "administrator"
./rabbitmqctl set_permissions -p "test" "test_admin" ".*" ".*" ".*"


## Setup qa
./rabbitmqctl add_vhost "qa"
./rabbitmqctl add_user "qa_admin" "d5d3d44d469a47d5ad0d1a600e9b41f3"
./rabbitmqctl set_user_tags ”qa_admin" "administrator"
./rabbitmqctl set_permissions -p "qa" "qa_admin" ".*" ".*" ".*"

## Setup uat
./rabbitmqctl add_vhost "uat"
./rabbitmqctl add_user "uat_admin" "6f786ecdd4cd45b2bc6223b35f242e6a"
./rabbitmqctl set_user_tags ”uat_admin" "administrator"
./rabbitmqctl set_permissions -p "uat" "uat_admin" ".*" ".*" ".*"


----
# References
* [RabbitMQ - Clustering Guide](https://www.rabbitmq.com/clustering.html)
* [RabbitMQ - Downloading and Installing RabbitMQ](https://www.rabbitmq.com/download.html)
* [Erlang - Installation Guide](https://erlang.org/doc/installation_guide/users_guide.html)
* [RabbitMQ - Installing on Windows](https://www.rabbitmq.com/install-windows.html)
* [Dave Donaldson - Installing RabbitMQ on Windows](http://arcware.net/installing-rabbitmqon-windows/)

