# Git server with SSL and authentication

A set of containers to provide a Git server HTTPS and basic authentication. Git in HTTP Smart mode (git-http-backend) + Basic HTTP Authentication + HTTPS redirect.
Nginx is used to front the GIT traffic, providing BA and TLS. It is 

## Building

	docker-compose build

## Running

Create basic auth file using htpasswd command from the apache2-utils package

	htpasswd -cbB .htpasswd admin [password]
	htpasswd -bB .htpasswd user [password] # note the lack of -c to prevent file overwrite

Generate SSL certificates and copy them into a folder/volume with the following names:

`privkey.pem`  : the private key for your certificate.
`fullchain.pem`: the certificate file used in most server software.
`chain.pem`    : used for OCSP stapling in Nginx >=1.3.7.

Note, if you are using self signed certs or a private CA use `git -c http.sslVerify=false` for each git invocation or configure it with `git config http.sslVerify false` (not recommended)

The start with `dc run` or

	docker run --name gitserver --rm -it -v $(pwd)/ssl:/etc/nginx/ssl -v $(pwd)/git:/git -v $(pwd)/.htpasswd:/www/.htpasswd -p 8443:443 alexivkin/gitserver

Once it is started, create a repo on the server

	docker exec -it gitserver sh

CD into the volume that you mounted as git, then

```
mkdir repo1.git
cd repo1.git
git --bare init
```

Make sure the user that owns the files has UID:GID of 1000:1000 (matching the nginx:nginx inside the container).

## Using

Use it as any other normal git server with authentication

```
git init
git add README.md
git commit -m "first commit"
git remote add origin https://yourserver/git/repo1.git
git push -u origin master
```

## References

* https://stackoverflow.com/questions/6414227/how-to-serve-git-through-http-via-nginx-with-user-password
* https://git-scm.com/book/en/v2/Git-on-the-Server-Smart-HTTP
