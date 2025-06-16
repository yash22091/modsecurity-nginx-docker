# ModSecurity NGINX WAF - Containerized Open Source Web Application Firewall

## Overview

This project packages **ModSecurity v3**, **OWASP Core Rule Set (CRS)**, and **NGINX** into a lightweight, secure, and flexible **containerized Web Application Firewall** (WAF). It supports both **standalone deployment** and **reverse proxy mode** in front of backend apps like **Node.js**, **Django**, **Flask**, or **Apache** servers.

# Containerized Open Source WAF with ModSecurity + NGINX

## Prerequisites

Before deploying this WAF stack, ensure your environment has:

### Required Tools

| Tool               | Minimum Version | Purpose                        |
|--------------------|------------------|--------------------------------|
| **Docker**         | >= 20.10         | Container build/runtime        |
| **Docker Compose** | >= 1.29          | Multi-container orchestration |
| **Make**           | *(Optional)*     | Use `Makefile` shortcuts       |
| **OpenSSL**        | >= 1.1           | TLS certificate generation     |
| **Git**            | >= 2.x           | Cloning/pushing repo           |

### 💻 System Requirements

- OS: Linux/macOS (Ubuntu, Alpine, etc.)
- CPU: 1–2 vCPU
- RAM: 1–2 GB (2 GB for WAF + backend)

### Network Ports

- **8080/8443** or **80/443** must be open and unused

---

## Why Use a WAF?

A **Web Application Firewall (WAF)** helps detect and block:

- SQL Injection
- Cross-Site Scripting (XSS)
- Automated bots/scanners
- Protocol misuse (e.g., header abuse)

You need it if your app is:

- Internet-facing
- Serving APIs
- Lacking granular firewall protection
- Running in Docker/Kubernetes environments

---

## Features

- ModSecurity v3 + OWASP CRS rules
- Docker + Alpine base image
- Custom rules support
- Inotify-based hot reload of rules
- Secure HTTP headers & rate limiting
- Standalone OR Reverse Proxy setup
- Configurable backend app integration (Node.js, Apache, Django)
- Sample Node.js test app included

---

## Directory Structure Explained

```bash
modsecuirty/
├── cert-gen.sh                  # TLS cert generator
├── docker-compose.yml           # Compose file for standalone WAF
├── docker-compose.override.yml  # WAF in front of app
├── Makefile                     # CLI shortcuts for lifecycle
├── modsec-data/
│   ├── certs/                   # TLS certs
│   ├── crs/                     # OWASP Core Rule Set
│   ├── custom-rules.conf        # Your ModSecurity rules
│   ├── modsecurity.conf         # Main WAF config
│   ├── nginx.conf               # NGINX config (standalone)
│   ├── nginx.conf.reverse.proxy # NGINX config (reverse proxy)
│   └── logs/                    # ModSecurity logs
├── nodeapp/
│   ├── app.js                   # Node.js backend
│   └── Dockerfile               # Dockerfile for Node app
├── update-crs.sh                # CRS updater
├── watcher.sh                   # Auto-reload for rule changes
```

### nginx.conf Usage Strategy

* `modsec-data/nginx.conf`: Used by default for standalone WAF.
* `modsec-data/nginx.conf.reverse.proxy`: Used when reverse proxying to a backend. **Make sure to update proxy settings inside it as per your app ports and routes.**

You can mount either in `docker-compose.yml` or `docker-compose.override.yml`.

---

## Makefile Shortcuts for Quick Deployment

The repository comes with a ready-to-use `Makefile` to help manage TLS certs, build the WAF, update rules, and deploy quickly.

| Command              | Description                                                    |
| -------------------- | ---------------------------------------------------------------|
| `make all`           | Build & deploy full stack (WAF + app) with reverse proxy setup |
| `make build`         | Build standalone WAF image                                     |
| `make up`            | Start standalone WAF mode (`modsec-data/nginx.conf`)           |
| `make down`          | Stop standalone WAF                                            |
| `make restart`       | Restart standalone WAF                                         |
| `make logs`          | Tail logs from WAF                                             |
| `make watch`         | Hot reload rules via watcher.sh                                |
| `make build-reverse` | Build reverse proxy + Node.js app                              |
| `make up-reverse`    | Run reverse proxy mode with backend app                        |
| `make down-reverse`  | Stop reverse proxy setup                                       |
| `make logs-reverse`  | Logs from reverse setup                                        |
| `make update-crs`    | Download & update latest OWASP CRS rules                       |
| `make gen-certs`     | Generate TLS certificates                                      |

---

## Getting Started in Minutes

### First-Time Full Setup

```bash
git clone <repo-url>
cd modsecurity-nginx-docker
make all     # Will build and deploy reverse proxy WAF + app
```

### Standalone WAF Deployment

```bash
make build
make up
```

### Reverse Proxy WAF + Backend App

```bash
make down           # Stop standalone mode first
make build-reverse
make up-reverse
```

Visit: `https://<your-ip>:8443`

---

## ModSecurity Custom Rules (Example)

```apache
# Block a specific parameter
SecRule ARGS:testparam "@streq test" "id:10001,phase:2,deny,log,status:403,msg:'Test parameter blocked'"

# Block curl User-Agent
SecRule REQUEST_HEADERS:User-Agent "@contains curl" "id:10002,phase:1,deny,log,status:403,msg:'Curl blocked'"

# Basic SQLi pattern
SecRule ARGS "@rx (?i)(union(.*?)select|select.+from)" "id:10003,phase:2,deny,log,status:403,msg:'SQLi blocked'"
```

---

## Dynamic Rule Reload (Watcher)

The `watcher.sh` script watches `custom-rules.conf` and reloads NGINX:

```bash
make watch
```

No container restart is needed. For this to work:

* Mount rules in `docker-compose.yml`
* Ensure `modsecurity_rules_file` in `modsecurity.conf` includes them

---

## Troubleshooting Guide

| Problem                    | Solution                                                               |
| -------------------------- | ---------------------------------------------------------------------- |
| `ssl` directive fails      | Rebuild NGINX with `--with-http_ssl_module`                            |
| Cannot load `.data` files  | Ensure CRS `.data` files are mounted                                   |
| ModSecurity not triggering | Ensure `SecRuleEngine On` and rule IDs are unique                      |
| Rule edits not applied     | Use `make watch` or restart container                                  |
| HTTPS error                | Ensure valid `server.crt` and `server.key` exist                       |
| WAF config not picked      | Double check which nginx.conf is mounted (standalone vs reverse proxy) |

---

## Security Best Practices Implemented

* `server_tokens off` to hide version info
* HTTPS enforced with redirect from HTTP
* Rate limiting per IP (10r/s)
* Secure headers: `X-Frame-Options`, `X-XSS-Protection`, `Referrer-Policy`, `Permissions-Policy`
* TLS certificate auto-generation via `cert-gen.sh`
* Runtime user separation (optional)
* Auto reload of rules via watcher


## License

MIT License. Based on open-source work by OWASP, NGINX, and ModSecurity teams.

## Contributing

PRs are welcome. Open issues for bugs or enhancements.

---

Made with ❤️ by Yash Patel. Secure your web apps the open way.
