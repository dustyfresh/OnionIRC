# OnionIRC
Docker container for running an IRC server as a Tor hidden service. Runs great on a [Raspberry Pi](https://www.raspberrypi.org/).

```
git clone https://github.com/dustyfresh/OnionIRC.git
```

#### Why is this useful?
You can share the private key of your Tor hidden service within your circle of trust. This provides redundancy in your server as in the event of a disaster anyone that had your private key could rebuild the exact image you were running  and the network would be up and running 100% again.

#### Notes
* [ngircd](http://ngircd.barton.de/) (IRC Server)
* [Debian Jessie](https://hub.docker.com/_/debian/) (base docker image)
* IRC talks on default port 6667, and yes we're using SSL. See the next section about the certificate and key specification.
* [Tor](https://www.torproject.org/)
* [Supervisord](http://supervisord.org/) -- this daemon will restart critical services if they are found to not be running as expected.

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
docker run -d -v $(pwd):/var/lib/tor --name onionirc onionirc
```

#### Get your onion name:
```
cat ./hidden_service/hostname
```

Remember that your **private key** is in this directory. This is used to identify your host with Tor so you can use the assigned onion address. If this address changes you will need a way to notify the users of this change -- which is difficult. **Do not lose this key!** It is also recommended that you an encrypted filesystem like [eCryptfs](http://ecryptfs.org/).

Connect to your hidden service using the onion domain returned from the last command **on port 6667 with SSL**.
