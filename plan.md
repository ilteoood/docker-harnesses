# docker-harnesses Improvement Plan

## Context

The repository provides pre-built, multi-arch Docker images for various AI coding assistants. It contains 10 images, each with a dedicated Dockerfile and CI workflow.

---

## 1. Consolidate CI/CD Workflows

**What:** Extract the repeated workflow logic into a single reusable workflow called via `workflow_call`.

**Why:** All 10 workflow files share identical trigger patterns (`push` on `main`, `schedule`, `workflow_dispatch`) and publish steps. Only the build step differs by tool type (Rust cross-compilation, npm global install, binary download). Duplication makes maintenance error-prone — updating the Docker Hub credentials or buildx action requires editing 10 files.

**How:**
- Create `.github/workflows/reusable-build.yml` with the common trigger and publish jobs
- Create three reusable job templates: `build-rust`, `build-npm`, `build-binary`
- Convert each tool workflow to call the reusable workflow with appropriate inputs

**Files:** `.github/workflows/zeroclaw.yml`, `.github/workflows/claude-code.yml`, etc.

---

## 2. Add Healthchecks to Dockerfiles

**What:** Add `HEALTHCHECK` instructions to all Dockerfiles.

**Why:** None of the 10 Dockerfiles define a healthcheck. When running under `docker-compose`, Docker cannot detect if the main process has crashed. Without a healthcheck, `docker-compose up` will start the container even if the process dies immediately.

**How:**
- For Node.js-based images (Claude Code, Codex, Copilot CLI, OpenCode): `HEALTHCHECK CMD curl -f http://localhost:3000/health || exit 1` — assuming the tool exposes a health endpoint, or use a process-based check
- For Rust/binary images: `HEALTHCHECK CMD pgrep zeroclaw || exit 1`
- Where no native health endpoint exists, fall back to checking that the main process is still running

**Files:** `Dockerfile.zeroclaw`, `Dockerfile.claude-code`, etc.

---

## 3. Pin Base Image Tags to Digests

**What:** Replace floating tags (`node:lts-slim`, `ubuntu:24.04`) with immutable digest-pinned references.

**Why:** Floating tags allow base images to change silently between builds. A registry compromise or intentional tag mutation could introduce changed base images without any rebuild triggered. Pinning to a specific digest ensures reproducible, auditable builds.

**How:**
- Query current digests: `docker pull node:lts-slim && docker inspect --format='{{.RepoDigests}}' node:lts-slim`
- Replace `node:lts-slim` with `node:22.04.0-slim@sha256:<digest>`
- Replace `ubuntu:24.04` with `ubuntu:24.04@sha256:<digest>`
- Run a rebuild to verify each image still builds correctly

**Files:** All Dockerfiles using `node:lts-slim` or `ubuntu:24.04`

---

## 4. Add Shell Script Validation in CI

**What:** Run `shellcheck` on all entrypoint, init, and download scripts in CI.

**Why:** Scripts like `src/entrypoint`, `nullclaw/download_nullclaw`, and `picoclaw/download_picoclaw` are executed in every container start. Common issues (unquoted variables, missing `set -e`, unused variables) can cause silent failures or unexpected behavior. `shellcheck` catches these automatically.

**How:**
- Add a `lint-scripts` job to the reusable workflow that runs `shellcheck` on all `**/entrypoint`, `**/init`, and `**/download_*` files
- Alternatively, add a dedicated `shellcheck.yml` workflow triggered on all script changes

**Files:** All `entrypoint`, `init`, and `download_*` scripts

---

## 5. Security Hardening: Non-Root User

**What:** Add a `USER` directive to run containers as a non-root user.

**Why:** All Dockerfiles run as root by default. Running as root is unnecessary for all these images — the tools need no special privileges. A non-root user limits the blast radius if a process is exploited.

**How:**
- In each Dockerfile, add at the end (before or after `ENTRYPOINT`):
  ```dockerfile
  RUN groupadd -r appgroup && useradd -r -g appgroup appuser
  USER appuser
  ```
- Update `docker-compose.yml` to reflect the user if needed

**Files:** All Dockerfiles

---

## 6. Security Hardening: Read-Only Root Filesystem

**What:** Add `read_only: true` to the compose file service definitions.

**Why:** A read-only root filesystem prevents any write to the host's filesystem except where explicitly mounted. Combined with the non-root user directive, this significantly limits container escape scenarios.

**How:**
- Add `read_only: true` to each service in `docker-compose.yml`
- For tools that need to write temporary files (e.g., npm installs, cache directories), either use a `tmpfs` mount or an explicit volume

**Files:** `docker-compose.yml`

---

## Implementation Order

| # | Change | Complexity | Risk |
|---|--------|-----------|------|
| 1 | Consolidate CI/CD workflows | High | Medium — changes CI structure |
| 2 | Add healthchecks | Low | Low — additive Dockerfile change |
| 3 | Pin base image digests | Medium | Medium — requires rebuild verification |
| 4 | Shell script validation | Low | Low — additive CI check |
| 5 | Non-root user | Medium | Medium — some tools may need dir permissions |
| 6 | Read-only root filesystem | Medium | Medium — may break tools relying on temp writes |

Start with **2, 4** (low risk, additive). Then **3, 5, 6** (require testing). Save **1** for last due to CI complexity.