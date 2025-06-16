# 🔐 ModSecurity NGINX WAF - Containerized Open Source Web Application Firewall

## 📊 Overview

This project packages **ModSecurity v3**, **OWASP Core Rule Set (CRS)**, and **NGINX** into a lightweight, secure, and flexible **containerized Web Application Firewall** (WAF). It supports both **standalone deployment** and **reverse proxy mode** in front of backend apps like **Node.js**, **Django**, **Flask**, or **Apache** servers.

## 📁 Project Structure

```
modsecurity-nginx-docker/
├── cert-gen.sh                  # TLS cert generation script
├── docker-compose.yml           # For standalone WAF deployment
├── docker-compose.override.yml  # For WAF in reverse proxy mode
├── modsec-data/
│   ├── certs/                   # SSL certs
│   ├── crs/                     # OWASP CRS rules
│   ├── custom-rules.conf        # Your custom ModSecurity rules
│   ├── modsecurity.conf         # Main WAF configuration
│   ├── logs/                    # Logs from WAF
│   ├── nginx.conf               # Standalone NGINX + WAF config
│   └── nginx.conf.reverse.proxy # Reverse proxy NGINX + WAF config
├── nodeapp/                     # Sample backend app (Node.js)
│   ├── app.js                   # Simple Node.js app
│   └── Dockerfile               # Node.js app container
├── watcher.sh                   # Auto-reload WAF rules using inotify
├── update-crs.sh                # Script to fetch latest OWASP CRS
├── Dockerfile                   # Multi-stage build for ModSecurity+NGINX
├── Makefile                     # CLI shortcuts for common commands
```

## ✨ Features

* OWASP CRS included
* Auto HTTPS with self-signed certs
* TLS fallback redirect from HTTP
* Secure headers
* Rate limiting
* Auto-reload on rule changes (inotify-based)
* Deploy as standalone or reverse proxy

## 🚀 Getting Started

📦 Makefile Shortcuts for Quick Deployment

The repository comes with a ready-to-use Makefile to help manage TLS certs, build the WAF, update rules, and deploy quickly.

Command

Description

make all

🔧 Build & deploy full stack (WAF + app) with reverse proxy setup

make build

🛠 Build standalone WAF image

make up

🟢 Start standalone WAF mode (modsec-data/nginx.conf)

make down

⛔ Stop standalone WAF

make restart

🔁 Restart standalone WAF

make logs

📋 Tail logs from WAF

make watch

♻️ Hot reload rules via watcher.sh

make build-reverse

🛠 Build reverse proxy + Node.js app

make up-reverse

🚀 Run reverse proxy mode with backend app

make down-reverse

🛑 Stop reverse proxy setup

make logs-reverse

📋 Logs from reverse setup

make update-crs

🔄 Download & update latest OWASP CRS rules

make gen-certs

🔐 Generate TLS certificates

### 1. Clone and Build

```bash
git clone https://github.com/<your-username>/modsecurity-nginx-docker.git
cd modsecurity-nginx-docker
make all
```

### 2. Run WAF in Standalone Mode

```bash
docker-compose -f docker-compose.yml up -d --build
```

Visit: `https://localhost:8443`

### 3. Run WAF with Backend App (Reverse Proxy)

```bash
docker-compose -f docker-compose.yml down

# Build and launch with reverse proxy
docker-compose -f docker-compose.override.yml build
docker-compose -f docker-compose.override.yml up -d
```

Visit: `https://localhost:8443` → gets routed to Node.js backend

> ⚠️ Make sure to edit `modsec-data/nginx.conf.reverse.proxy` to reflect your custom app's `proxy_pass` settings.

### 4. Enable Rule Watching (Hot Reload)

```bash
make watch
```

## ⚙️ Build Your Own App

Replace the contents of `nodeapp/` with your own app and Dockerfile. Keep the `EXPOSE` port consistent (e.g., 3000).

## 🔐 Security Best Practices Implemented

* `server_tokens off`
* HTTPS enforced
* Secure headers (`X-Content-Type-Options`, `Referrer-Policy`, etc.)
* Rate limiting
* Self-signed certs auto-generated if missing

## ⚡ Troubleshooting

| Issue                  | Fix                                                  |
| ---------------------- | ---------------------------------------------------- |
| Rule not applied       | Restart container or run `make watch`                |
| CRS not loading        | Check CRS path is correct and properly mounted       |
| SSL error              | Run `cert-gen.sh` or ensure certs exist              |
| ModSecurity not firing | Ensure `SecRuleEngine On` is set in modsecurity.conf |

## 🚪 License

MIT License. Based on open-source work by OWASP, NGINX, and ModSecurity teams.

## 🙌 Contributing

PRs are welcome. Open issues for bugs or enhancements.

---

Made with ❤️ by \[Yash Patel]. Secure your web apps the open way.
