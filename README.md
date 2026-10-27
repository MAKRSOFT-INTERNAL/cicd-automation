# MAKRSOFT IT SOLUTIONS Nginx

## Run locally

Build and start the Nginx server with:

```sh
export IMAGE_TAG=$(git rev-parse --short=12 HEAD)
docker compose -f docker-compose.yml up --build
```

Open `http://localhost:8080` to see the welcome page. Stop the server with `Ctrl+C`, or run `docker compose -f docker-compose.yml down`.

## CI workflow

The Docker workflow runs on pushes to `main` and manual dispatches on `main`, using the self-hosted runner labeled `docker-agent`. It tags each image with the first 12 characters of the triggering commit SHA, packages it as `DockerImages/nginx-<short-sha>.tar`, uploads the image and job logs as Actions artifacts, verifies the welcome page, stops Nginx, and commits the image archive to `main`.

## Self-hosted runner

Create a repository runner registration token in GitHub under **Settings > Actions > Runners > New self-hosted runner**. Copy `runner/.env.example` to `runner/.env`, set the repository URL and token, then start the one-job runner before triggering the workflow:

```sh
cp runner/.env.example runner/.env
# Edit runner/.env and set RUNNER_TOKEN to the registration token.
bash runner/run-once.sh
```

The script waits for one workflow job, then removes the ephemeral runner container. The workflow stops the Nginx container even if its smoke test fails. Download console/build logs from the job's `docker-job-logs` artifact; logs are not committed to Git. The runner mounts `/var/run/docker.sock`, which grants it control of the Docker host. Use it only on a trusted, isolated machine and do not run untrusted pull-request code on this runner. The registration token is short-lived; never commit `runner/.env`.