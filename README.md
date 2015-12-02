# OnionIRC
Docker container for running an IRC server as a Tor hidden service

```
git clone https://github.com/dustyfresh/OnionIRC.git
```

#### Notes
* [ngircd](http://ngircd.barton.de/) (IRC Server)
* [Debian Jessie](https://hub.docker.com/_/debian/) (base docker image)
* IRC talks on default port 6667 using SSL. See the next section about the certificate and key specification.
* [Tor](https://www.torproject.org/)

#### Generate SSL certs:
Here is where you will generate the self signed SSL certificate. You do not need to fill anything out — just hold the enter key until the process is complete.
```
cd ssl/ && openssl genrsa -out server.key 1024 && openssl req -new -key server.key -out server.csr && openssl x509 -req -days 1337 -in server.csr -signkey server.key -out server.crt
```

#### Customize the configuration:
There are some things you will need to modify before you can get your IRC hidden service running.
```
vim conf/ngircd.conf
```

Change the server name, it must be a FQDN name.

Find this towards the bottom of the file and modify the operator login information:

```
[Operator]
    Name = root
    Password = changeme
```

Modify as you wish. This is the main admin user of the server. **Use strong passwords**!

Also change the Channel at the very bottom to create your own private channel with a password.

#### Change the MOTD
Modify the ngircd MOTD file:
```
vim conf/ngircd.motd
```

#### Build the image:
```
docker build --rm -t onionirc .
```

#### Run the server:
```
docker run -d --name onionirc onionirc
```

#### Get your onion name:
```
docker exec onionirc bash -c 'cat /var/lib/tor/hidden_service/hostname'
```

Connect to your hidden service using the onion domain returned from the last command **on port 6667 using SSL**.
