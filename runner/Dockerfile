FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates curl docker.io git jq sudo tar \
    && rm -rf /var/lib/apt/lists/*

ARG TARGETARCH
RUN set -eux; \
    case "$TARGETARCH" in \
      amd64) runner_arch=x64; compose_arch=x86_64 ;; \
      arm64) runner_arch=arm64; compose_arch=aarch64 ;; \
      *) echo "Unsupported architecture: $TARGETARCH" >&2; exit 1 ;; \
    esac; \
    runner_version="$(curl -fsSL https://api.github.com/repos/actions/runner/releases/latest | jq -er '.tag_name | ltrimstr("v")')"; \
    curl -fsSL "https://github.com/actions/runner/releases/download/v${runner_version}/actions-runner-linux-${runner_arch}-${runner_version}.tar.gz" -o /tmp/actions-runner.tar.gz; \
    compose_version="$(curl -fsSL https://api.github.com/repos/docker/compose/releases/latest | jq -er '.tag_name')"; \
    install -d /usr/local/lib/docker/cli-plugins; \
    curl -fsSL "https://github.com/docker/compose/releases/download/${compose_version}/docker-compose-linux-${compose_arch}" -o /usr/local/lib/docker/cli-plugins/docker-compose; \
    chmod 0755 /usr/local/lib/docker/cli-plugins/docker-compose; \
    mkdir -p /runner; \
    tar -xzf /tmp/actions-runner.tar.gz -C /runner; \
    rm /tmp/actions-runner.tar.gz; \
    /runner/bin/installdependencies.sh

WORKDIR /runner
COPY entrypoint.sh /usr/local/bin/runner-entrypoint
RUN chmod 0755 /usr/local/bin/runner-entrypoint

ENV RUNNER_ALLOW_RUNASROOT=1
ENTRYPOINT ["/usr/local/bin/runner-entrypoint"]