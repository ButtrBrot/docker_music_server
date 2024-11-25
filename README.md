A Docker container containing the snapcast server and the librespot binaries.
By default a librespot stream named Spotify will be started.

# docker build

```docker build --progress=plain -t docker_music_server:0.1 .```

# docker run

```docker run -dit --network=host --name docker_music_server docker_music_server:0.1```
