# docker-harnesses

Ready-to-run, multi-arch Docker images for AI coding assistants and personal AI tools — automatically built and published to [Docker Hub](https://hub.docker.com/u/ilteoood).

---

## Overview

**docker-harnesses** provides [multi-arch](https://medium.com/gft-engineering/docker-why-multi-arch-images-matters-927397a5be2e) Docker images (`linux/amd64` and `linux/arm64`) for several AI-powered tools. Every image is rebuilt automatically via [GitHub Actions](https://github.com/features/actions) to always track the latest upstream release.

## Available Images

| Image | Upstream Project | Base Image | Ports | Build Status | Build Schedule |
|---|---|---|---|---|---|
| [`ilteoood/zeroclaw`](https://hub.docker.com/r/ilteoood/zeroclaw) | [zeroclaw-labs/zeroclaw](https://github.com/zeroclaw-labs/zeroclaw) | Ubuntu 24.04 | `42617` | ![ZeroClaw](https://github.com/ilteoood/docker-harnesses/workflows/ZeroClaw/badge.svg?branch=main) | Daily |
| [`ilteoood/openclaw`](https://hub.docker.com/r/ilteoood/openclaw) | [openclaw/openclaw](https://github.com/openclaw/openclaw) | `ghcr.io/openclaw/openclaw:latest` | `18789` | ![OpenClaw](https://github.com/ilteoood/docker-harnesses/workflows/OpenClaw/badge.svg?branch=main) | Daily |
| [`ilteoood/opencode`](https://hub.docker.com/r/ilteoood/opencode) | [opencode-ai](https://www.npmjs.com/package/opencode-ai) (npm) | Node.js LTS slim | — | ![OpenCode](https://github.com/ilteoood/docker-harnesses/workflows/OpenCode/badge.svg?branch=main) | Daily |
| [`ilteoood/openfang`](https://hub.docker.com/r/ilteoood/openfang) | [RightNow-AI/openfang](https://github.com/RightNow-AI/openfang) | Ubuntu 24.04 | — | ![OpenFang](https://github.com/ilteoood/docker-harnesses/workflows/OpenFang/badge.svg?branch=main) | Daily |
| [`ilteoood/picoclaw`](https://hub.docker.com/r/ilteoood/picoclaw) | [sipeed/picoclaw](https://github.com/sipeed/picoclaw) | Ubuntu 24.04 | `18790` | ![PicoClaw](https://github.com/ilteoood/docker-harnesses/workflows/PicoClaw/badge.svg?branch=main) | Weekly (Mon) |
| [`ilteoood/claude-code`](https://hub.docker.com/r/ilteoood/claude-code) | [@anthropic-ai/claude-code](https://www.npmjs.com/package/@anthropic-ai/claude-code) (npm) | Node.js LTS slim | — | ![ClaudeCode](https://github.com/ilteoood/docker-harnesses/workflows/ClaudeCode/badge.svg?branch=main) | Daily |
| [`ilteoood/codex`](https://hub.docker.com/r/ilteoood/codex) | [@openai/codex](https://www.npmjs.com/package/@openai/codex) (npm) | Node.js LTS slim | — | ![Codex](https://github.com/ilteoood/docker-harnesses/workflows/Codex/badge.svg?branch=main) | Daily |
| [`ilteoood/copilot-cli`](https://hub.docker.com/r/ilteoood/copilot-cli) | [@github/copilot](https://www.npmjs.com/package/@github/copilot) (npm) | Node.js LTS slim | — | ![CopilotCLI](https://github.com/ilteoood/docker-harnesses/workflows/CopilotCLI/badge.svg?branch=main) | Daily |

---

## Image Details

### ZeroClaw

Personal AI Assistant — zero overhead, zero compromise, 100% Rust, 100% agnostic.

- **Dockerfile:** [`Dockerfile.zeroclaw`](./Dockerfile.zeroclaw)
- **Architectures:** `linux/amd64`, `linux/arm64`
- **Build process:** The Rust binary is cross-compiled from the latest upstream release with all features enabled. A web dashboard (Node.js) is built and bundled alongside the binary.
- **Configuration:** Mount a config file at `/root/.zeroclaw/config.toml`.
- **Exposed port:** `42617`

```sh
docker run --name zeroclaw -v /path/to/home:/root -p 42617:42617 ilteoood/zeroclaw
```

Once running, the ZeroClaw gateway is accessible at `http://localhost:42617`.

### OpenClaw

- **Dockerfile:** [`Dockerfile.openclaw`](./Dockerfile.openclaw)
- **Architectures:** `linux/amd64`, `linux/arm64`
- **Build process:** Extends the official `ghcr.io/openclaw/openclaw:latest` image with a custom entrypoint and init script.
- **Exposed port:** `18789`

```sh
docker run --name openclaw -p 18789:18789 ilteoood/openclaw
```

### OpenCode

- **Dockerfile:** [`Dockerfile.opencode`](./Dockerfile.opencode)
- **Architectures:** `linux/amd64`, `linux/arm64`
- **Build process:** Installs the latest `opencode-ai` npm package globally on a Node.js LTS slim base.

```sh
docker run --name opencode -v /path/to/home:/root ilteoood/opencode
```

### OpenFang

- **Dockerfile:** [`Dockerfile.openfang`](./Dockerfile.openfang)
- **Architectures:** `linux/amd64`, `linux/arm64`
- **Build process:** The Rust binary is cross-compiled from the latest upstream release of [RightNow-AI/openfang](https://github.com/RightNow-AI/openfang).

```sh
docker run --name openfang ilteoood/openfang
```

### PicoClaw

A standalone [PicoClaw](https://github.com/sipeed/picoclaw) container.

- **Dockerfile:** [`Dockerfile.picoclaw`](./Dockerfile.picoclaw)
- **Architectures:** `linux/amd64`, `linux/arm64`
- **Build process:** Downloads the latest PicoClaw release from GitHub.
- **Environment variables:**
  - `PICOCLAW_MODE` — PicoClaw run mode (default: `gateway`)
- **Exposed port:** `18790`

```sh
docker run --name picoclaw -p 18790:18790 ilteoood/picoclaw
```

### Claude Code

- **Dockerfile:** [`Dockerfile.claude-code`](./Dockerfile.claude-code)
- **Architectures:** `linux/amd64`, `linux/arm64`
- **Build process:** Installs the latest `@anthropic-ai/claude-code` and `happy` npm packages globally on a Node.js LTS slim base.

```sh
docker run --name claude-code -v /path/to/home:/root ilteoood/claude-code
```

### Codex CLI

- **Dockerfile:** [`Dockerfile.codex`](./Dockerfile.codex)
- **Architectures:** `linux/amd64`, `linux/arm64`
- **Build process:** Installs the latest `@openai/codex` npm package globally on a Node.js LTS slim base.

```sh
docker run --name codex -v /path/to/home:/root ilteoood/codex
```

### GitHub Copilot CLI

- **Dockerfile:** [`Dockerfile.copilot-cli`](./Dockerfile.copilot-cli)
- **Architectures:** `linux/amd64`, `linux/arm64`
- **Build process:** Installs the latest `@github/copilot` npm package globally on a Node.js LTS slim base.

```sh
docker run --name copilot -v /path/to/home:/root ilteoood/copilot-cli
```

---

## Custom Initialization

Every image supports a custom init script. Mount your own script at `/usr/local/bin/init` to install additional software or run arbitrary commands when the container starts. The init script is executed before the main process.

Example with Docker Compose:

```yaml
configs:
  init_script:
    file: /path/to/your/init/script

services:
  zeroclaw:
    image: ilteoood/zeroclaw
    configs:
      - source: init_script
        target: /usr/local/bin/init
        mode: 0755
```

---

## Docker Compose

A ready-to-use [`docker-compose.yml`](./docker-compose.yml) is included in the repository. It defines services for `zeroclaw`, `picoclaw`, `opencode`, and `claude-code` with shared volumes and configuration support.

```sh
docker compose up -d
```

---

## Repository Structure

```
.
├── .github/
│   ├── workflows/          # CI/CD workflows (one per image)
│   │   ├── zeroclaw.yml
│   │   ├── openclaw.yml
│   │   ├── opencode.yml
│   │   ├── openfang.yml
│   │   ├── picoclaw.yml
│   │   ├── claude-code.yml
│   │   ├── codex.yml
│   │   └── copilot-cli.yml
│   ├── dependabot.yml      # Automated Docker base-image updates
│   └── funding.yml         # Sponsorship configuration
├── src/                    # ZeroClaw entrypoint & init scripts
├── openclaw/               # OpenClaw entrypoint & init scripts
├── opencode/               # OpenCode entrypoint & init scripts
├── claude-code/            # Claude Code entrypoint & init scripts
├── picoclaw/             # PicoClaw entrypoint, init & download scripts
├── codex/                   # Codex CLI entrypoint & init scripts
├── copilot-cli/             # Copilot CLI entrypoint & init scripts
├── scripts/                # Build helper scripts for Rust binaries
│   ├── binary_zeroclaw.sh
│   └── binary_openfang.sh
├── Dockerfile.zeroclaw
├── Dockerfile.openclaw
├── Dockerfile.opencode
├── Dockerfile.openfang
├── Dockerfile.picoclaw
├── Dockerfile.claude-code
├── Dockerfile.codex
├── Dockerfile.copilot-cli
├── docker-compose.yml
└── README.md
```

---

## CI/CD

All images are built and published automatically using [GitHub Actions](https://github.com/features/actions):

- **Trigger:** Push to `main`, manual dispatch, or a scheduled cron job.
- **Schedule:** Most images are rebuilt daily at 03:00 UTC; PicoPilot is rebuilt weekly on Mondays.
- **Multi-arch builds** are performed with [`ilteoood/docker_buildx`](https://github.com/ilteoood/docker_buildx).
- **Rust images** (ZeroClaw, OpenFang) use [`houseabsolute/actions-rust-cross`](https://github.com/houseabsolute/actions-rust-cross) for cross-compilation.
- **Dependabot** is configured to check for Docker base-image updates daily.

---

## Do you like my work?

<p align="center">
    <a href="https://www.patreon.com/ilteoood">
        <img align="center" alt="patreon" src="https://img.shields.io/endpoint.svg?url=https%3A%2F%2Fshieldsio-patreon.vercel.app%2Fapi%3Fusername%3Dilteoood%26type%3Dpatrons&style=for-the-badge">
        </img>
    </a>
    or
    <a href="https://www.buymeacoffee.com/ilteoood">
        <img align="center" alt="buy-me-a-coffee" src="https://img.shields.io/badge/-buy_me_a%C2%A0coffee-gray?logo=buy-me-a-coffee">
        </img>
    </a>
</p>
