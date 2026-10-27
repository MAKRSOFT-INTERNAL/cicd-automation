# MAKRSOFT IT SOLUTIONS Nginx

## Run locally

Build and start the Nginx server with:

```sh
docker compose -f docker-compose.yml up --build
```

Open `http://localhost:8080` to see the welcome page. Stop the server with `Ctrl+C`, or run `docker compose -f docker-compose.yml down`.

## CI workflow

The Docker workflow runs on pushes, pull requests, and manual dispatch. It builds the image, packages it as `DockerImages/nginx.tar`, uploads the tarball as an Actions artifact, and verifies that the served page contains `Welcome to MAKRSOFT IT SOLUTIONS`. After a successful build and smoke test, push and manual runs commit the archive to their branch. Pull request runs upload an artifact without trying to write to the branch; download it from the completed workflow run.