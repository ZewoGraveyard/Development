# Flux

## OS X

- Dependencies

```bash
$ brew install openssl postgresql zeromq --with-libsodium libxml2
$ brew link --force openssl libxml2
```

- Build command

```
swift build -Xcc -I/usr/local/include -Xcc -I/usr/local/include/libxml2 -Xlinker -L/usr/local/lib/
```

## Linux

- Dependencies

```bash
$ sudo apt-get install libssl-dev libpq-dev libzmq3-dev libxml2-dev 
```

- Build command

```
swift build -Xcc -I/usr/include/libxml2 -Xcc -I/usr/include/postgresql
```
