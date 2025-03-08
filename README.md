# web-test-container
Minimal container for testing container orchestration and hosting setups

```shell
docker pull ghcr.io/data5tream/web-test-container:latest
docker run --rm -p 8080:8080 ghcr.io/data5tream/web-test-container:latest
```

## Configuration

Configure via environment variables

- `CONTAINER_NAME` - Name of the container, defaults to `WebTestContainer`
- `LOG_LEVEL` - Log level, defaults to `info`

## Endpoints

- `/` - Returns the value of the `CONTAINER_NAME` environment variable or `WebTestContainer`
- `/ping` - Pong
- `/status/<u16>` - Returns the status code provided in the path
- `/headers` - Returns all headers received by the server
