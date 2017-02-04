# hyperspace

A real-time multiplayer space shooter.

## Development

 * Run `make` to run a local copy at http://localhost:9393.

 * Run `./watch` to run a local copy that auto-restarts when server files are changed (requires fswatch - `brew install fswatch`)

## Installation

### Add to Nginx configuration

Add to bottom of http block:

```conf
include /srv/hyperspace/etc/nginx.conf;
```

Add systemd service:

```sh
sudo ln -s /srv/hyperspace/etc/hyperspace.service /etc/systemd/system/
sudo systemctl start hyperspace
```


### Add dependencies

```sh
go get github.com/gorilla/websocket
go get github.com/lucasb-eyer/go-colorful
```
