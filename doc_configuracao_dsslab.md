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
1. docker exec -it container_name /bin/bash
2. mysql -u root
3. GRANT ALL PRIVILEGES ON *.* TO 'dcspt-dlab-web'@'localhost' IDENTIFIED BY 'GuRTHDFPDHl8teRv';
4. exit # para sair do terminal mysql
5. mysql -u dcspt-dlab-web *e forneça a senha*
6. CREATE DATABASE dcspt_dlab;

```
    Ainda é necessário:
    * Configurar o Apache para receber as solicitações do nginx
    * Deixar o banco de dados persistente
```

* Componente 2: [Phusion-passenger](https://github.com/phusion/passenger-docker)
1. Usar o Dockerfile do phusion-passenger
2. docker run -p 80:80 image_id /sbin/my_init

* Componente 3: NodeJS Server
Obs.: Criei essa imagem. Seguir essas recomendações depois
5. cd .../bundle/programs/server && npm install
6. cd .../bundle
7. export ROOT_URL=http://localhost
8. export PORT=3000
9. node main.js
