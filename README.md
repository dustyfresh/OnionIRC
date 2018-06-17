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
* For raspberry pi: Comment out the corresponding line in the Dockerfile

#### Generate SSL certs:

**It important to note that the strength of your RSA keys. Since this is a hidden service you will want to use at minimum 2048 bits, but 4096 bits is better. The larger the key the more time it will take generating the key -- introduce more entropy on the host to fix this. See [Haveged](http://www.issihosts.com/haveged/).**

Here is where you will generate the self signed SSL certificate. You do not need to fill anything out — just hold the enter key until the process is complete.

```
cd ssl/ && openssl genrsa -out server.key 4096 && openssl req -new -key server.key -out server.csr && openssl x509 -req -days 1337 -in server.csr -signkey server.key -out server.crt
```

It is wise to backup the contents of the ssl directory and make sure it doesn't fall in wrong hands. You need it when you rebuild the server (or you have to generate a new cert, but everyone that has explicitly trusted this certificate will get a warning / will be unable to connect).

#### Customize the configuration:
There are some things you will need to modify before you can get your IRC hidden service running.

```
vim conf/ngircd.conf
```

Change the server name, it must be a FQDN (Fully Qualified Domain Name, like supersecretirc.net or s0m30n10n4ddr3s.onion).

Find this towards the bottom of the file and modify the IRC operator login information:

```
[Operator]
    Name = root
    Password = changeme
```

Modify as you wish. This is the main admin user of the server. **Use strong passwords**!

Also change the Channel at the very bottom to create your own private channel with a password.

This is an example configuration, to tailor the server to your specific needs see [ngirc docs](https://github.com/ngircd/ngircd/blob/master/doc/sample-ngircd.conf.tmpl)

#### Logging
Currently this is disabled. If you wish to log you can modify the rsyslog configuration found within conf/rsyslog.conf.

#### Change the MOTD
Modify the ngircd MOTD file. This is the first thing a user sees when logging into your server:
```
vim conf/ngircd.motd
```

#### Build the image:
```
docker build --rm -t onionirc .
```

#### Run the server (Tor only):
```
sudo docker run -d -v /srv/hidden-service-data:/var/lib/tor --name onionirc --restart=always onionirc

```

#### Run the server (Tor and regular connections):
```
sudo docker run -d -v /srv/hidden-service-data:/var/lib/tor --name onionirc --restart=always -p 6667:6667 onionirc

```


Where /srv/onionirc-hidden-service-data is a directory on your docker hosts filesystem. This is where the private key and the hostname of your hidden service is kept.

#### Get your onion name:
```
cat /srv/onionirc-hidden-service-data/hostname
```

Remember that your **private key** is in this directory. This is used to identify your host with Tor so you can use the assigned onion address. If this address changes you will need a way to notify the users of this change -- which is difficult. **Do not lose this key!** It is also recommended that you utilize an encrypted filesystem like [eCryptfs](http://ecryptfs.org/).

Connect to your hidden service using the onion domain returned from the last command **on port 6667 with SSL**.
