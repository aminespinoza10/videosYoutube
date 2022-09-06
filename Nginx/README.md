# Comandos utilizados para desplegar sitios web en Nginx

En mi video acerca de cómo aprender a utilizar Nginx utilizo una larga secuencia de comandos, este es el video:

[![nginx](http://img.youtube.com/vi/TPExGCeTdbo/0.jpg)](http://www.youtube.com/watch?v=TPExGCeTdbo)

Y estos son los comandos en el orden utilizado:

```bash
sudo apt install nginx
```

```bash
systemctl status nginx
```

```html
<html>
    <title>Mi primer sitio</title>
    <h1>Bienvenido a mi primer sitio hospedado con Nginx</h1>
</html>
```

```html
<html>
    <title>Mi segundo sitio</title>
    <h1>Bienvenido a mi segundo sitio hospedado con Nginx</h1>
</html>
```

```bash
mkdir amintube.com/html
```

```bash
ln -s /etc/nginx/sites-available/amintube.com.conf /etc/nginx/sites-enabled/
```

```json
server {
        listen 80;
        listen [::]:80;
        root /var/www/amintube.com/html;
        index index.html index.htm;
        server_name amintube.com;

   location / {
       try_files $uri $uri/ =404;
   }

}
```

```bash
nginx -t
```

```bash
systemctl restart nginx
```

```bash
sudo nano /etc/hosts
```