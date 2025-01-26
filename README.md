A Docker container containing the snapcast server and the librespot binaries.
By default a librespot stream named Spotify will be started.

# docker build

```docker build --progress=plain -t docker_music_server:0.1 .```

# docker run

```docker run -dit --network=host --restart unless-stopped --name docker_music_server docker_music_server:0.1```
```docker run -dit -p 1704:1704 -p 1705:1705 -p 1780:1780 -p 5353:5353 -p 43945:43945 --restart unless-stopped --name docker_music_server docker_music_server:0.1```
