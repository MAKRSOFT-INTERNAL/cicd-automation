# MAKRSOFT IT SOLUTIONS Nginx

## Run locally

Build and start the Nginx server with:

```sh
export IMAGE_TAG=$(git rev-parse --short=12 HEAD)
docker compose -f docker-compose.yml up --build
```

Open `http://localhost:8080` to see the welcome page. Stop the server with `Ctrl+C`, or run `docker compose -f docker-compose.yml down`.

## CI workflow

The Docker workflow runs on pushes, pull requests, and manual dispatch. It tags each image with the first 12 characters of the triggering commit SHA, packages it as `DockerImages/nginx-<short-sha>.tar`, uploads that tarball as an Actions artifact, and verifies that the served page contains `Welcome to MAKRSOFT IT SOLUTIONS`. After a successful build and smoke test, push and manual runs commit the SHA-tagged archive to their branch. Pull request runs upload an artifact without trying to write to the branch; download it from the completed workflow run.

## Self-hosted Docker runner

The optional self-hosted workflow runs only when manually dispatched. It builds and tests the Nginx image, captures console and container output, stops and removes the Nginx container, and uploads the image and logs as artifacts on the workflow run. Logs are retained for 30 days; image archives are retained for 7 days. They are stored as GitHub Actions artifacts rather than committed to source history.

1. In the repository's **Settings > Actions > Runners**, choose **New self-hosted runner** and create a repository-level registration token.
2. Copy `runner/.env.example` to `runner/.env`, set `REPO_URL` and the fresh `RUNNER_TOKEN`, and keep the token private. The `.env` file is Git-ignored.
3. Start the one-job runner container:

	```sh
	docker compose --env-file runner/.env -f runner/docker-compose.yml up --detach
	```

4. In GitHub, open **Actions > Docker on self-hosted runner > Run workflow**. The runner has the `docker-nginx` label and exits after one job.
5. After the run completes, remove the stopped runner container:

	```sh
	docker compose --env-file runner/.env -f runner/docker-compose.yml down --remove-orphans
	```

The runner mounts the host Docker socket, which grants it control over the host's Docker daemon. Use it only with trusted workflows and protect access to the runner host.