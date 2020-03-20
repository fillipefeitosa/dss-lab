# Documentação de Configuração
## Servidor dcspt-govcopp.ua.pt
---

Objetivo: prover os dois módulos (duas aplicações) como um único
serviço do dss-lab centralizado.

---

* Login:

ssh username@dcspt-govcopp.ua.pt

*  Orientação:
Caso eu fosse instalar o sistema no seco:
https://ericlondon.com/2012/03/11/creating-a-web-server-to-host-ruby-on-rails-and-php-using-phusion-passenger-nginx-and-apache.html
1. Instalar o apache e o php
2. Configurar vHost no apache
    2.1 Add symlink para a configuração do apache
3. Instalar o Phusion normalmente com o a aplicação do NodeJs

* Componente 1: [Docker lamp](https://hub.docker.com/r/mattrayner/lamp)
Atenção para a password informada no início do log.
docker run -p "80:80" -v ${PWD}/phpapp:/app mattrayner/lamp:latest-1804



1. docker exec -it container_name /bin/bash
2. mysql -u root
3. GRANT ALL PRIVILEGES ON *.* TO 'dcspt-dlab-web'@'localhost' IDENTIFIED BY 'password';
4. exit # para sair do terminal mysql
5. mysql -u dcspt-dlab-web -p *e forneça a senha*
6. CREATE DATABASE dcspt_dlab;
7. Depois, é necessário inserir o backup via terminal ou phpmyadmin
8. Configuração de porta "8000:80". Desse jeito tudo que chegar na porta 8000, o container vai escutar como se fosse a porta 80
9. É necessário criar um .dockerignore para que não seja necessário remover as pastas dos bancos de dados quando for recriar as builds
    * [link](https://stackoverflow.com/questions/55103438/permission-denied-error-when-rebuilding-docker-image-with-volume)


```
    Ainda é necessário:
    * Configurar o Apache para receber as solicitações do nginx
    * Deixar o banco de dados persistente (para isso bastar montar o volume para o banco de dados) - OK
```
Para fazer deploy updates:
1. docker-compose stop phusion
2. docker-compose build phusion
3. docker-compose up -d --no-deps phusion
[discussão relevante no github](https://github.com/docker/compose/issues/1487)
Esses comandos vão parar o container, recriar a imagem ignorando as pastas dos bancos de dados (via .dockerignore) e 
subir o container novamente atualizado.



* Componente 2: [Phusion-passenger](https://github.com/phusion/passenger-docker)
1. Usar o Dockerfile do phusion-passenger
2. docker run -p 80:80 image_id /sbin/my_init (com docker compose esse comando não é mais necessário)
3. Arrumar o arquivo de sites-enabled:
    * É necessário subir o arquivo para container no Dockerfile
4. Atualizar o npm (via Dockerfile)
    * RUN npm install npm@latest -g
5. O phusion não aceita a versão 12 do node. Ou seja. Preciso voltar tudo pro jeito que era antes.
    * Versão do Meteorjs: 1.8.3 --> meteor update --release 1.8.3
    * Atualizar a versão dos pacotes instalados: meteor update --all-packages
6. É necessário usar o endereço correto para o mongo na configuração do nginx
    * passenger_env_var MONGO_URL mongodb://mongo:27017/dsslab;
7. Garantir que os modules de download/upload de arquivos estão usando pastas com permissões certas.
    * Ostrio Files