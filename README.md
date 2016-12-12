ws-cloudera-docker
==================

Olá! Este container foi feito para tornar mais simples a vida de pessoas
que querem testar o Hadoop sem ter que instalar um monte de dependências
em várias máquinas diferentes.

Utilizar as máquinas virtuais da Cloudera pode ser uma opção, mas para
isso, é necessário usar VMs com uma boa quantidade de memória e CPU,
e isso torna o laboratório pesado para a maioria dos PCs com um
pouco mais de idade.

A abordagem com Docker é muito mais leve, já que não é necessário
subir 4 sistemas operacionais completos (inclusive com modo gráfico, X11)
como é feito nas máquinas da Cloudera. Por se tratar de container,
apenas os processos são executados de forma isolada, sem o overhead
do sistema operacional guest.


Construindo
-----------

Para usar esta imagem é necessário antes construí-la, e em seguida levantar
o cluster usando o `docker-compose`.

1.  Clone o projeto, baixe a pasta com os repositórios da Cloudera
e construa a imagem:

```
$ git clone https://github.com/wesleyit/ws-cloudera-docker.git
$ cd ws-cloudera-docker/Image/
$ wget www.xxx.xxx.xx/xxx/xxxx/xxx.xxx.zip
$ unzip xxx.xxx.zip
$ docker build --rm -t wesleyit/ws-cloudera-docker:latest .
```

2.  Entre no diretorio do Compose e inicie os containers:

```
$ cd ../Compose/
$ make start
```
