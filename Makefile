# ================================
# 🚀 Makefile for ModSecurity WAF
# ================================

.DEFAULT_GOAL := help

# ---------------------------------
# 📦 Build & Run (Standalone WAF)
# ---------------------------------
build:
        docker-compose -f docker-compose.yml build --no-cache

up:
        docker-compose -f docker-compose.yml up -d

down:
        docker-compose -f docker-compose.yml down

restart:
        make down && make up

logs:
        docker-compose logs -f

watch:
        docker exec -it modsec /usr/local/bin/watcher.sh

# ----------------------------------------------------
# 🛡️ Reverse Proxy WAF + Node App (One-Click Setup)
# ----------------------------------------------------
build-reverse:
        docker-compose -f docker-compose.override.yml build

up-reverse:
        docker-compose -f docker-compose.override.yml up -d

down-reverse:
        docker-compose -f docker-compose.override.yml down

logs-reverse:
        docker-compose -f docker-compose.override.yml logs -f

# ----------------------------------------------------
# 🧩 One Command to Deploy Node App + Reverse WAF
# ----------------------------------------------------
all:
        docker-compose -f docker-compose.override.yml build --no-cache
        docker-compose -f docker-compose.override.yml up -d

# ----------------------------------------------------
# 🔁 Update OWASP CRS
# ----------------------------------------------------
update-crs:
        bash update-crs.sh

# ----------------------------------------------------
# 🔐 Generate TLS certs
# ----------------------------------------------------
gen-certs:
        bash cert-gen.sh

# ----------------------------------------------------
# 🆘 Help
# ----------------------------------------------------
help:
        @echo "Usage: make <target>"
        @echo
        @echo "🧱 Basic Lifecycle Commands:"
        @echo "  build           Build standalone WAF image"
        @echo "  up              Start standalone WAF"
        @echo "  down            Stop standalone WAF"
        @echo "  restart         Restart standalone WAF"
        @echo "  logs            Tail logs for WAF"
        @echo "  watch           Watch rule file changes"
        @echo
        @echo "🛡️  Reverse Proxy + App:"
        @echo "  build-reverse   Build WAF + Node app"
        @echo "  up-reverse      Run reverse proxy WAF + app"
        @echo "  down-reverse    Stop reverse proxy WAF + app"
        @echo "  logs-reverse    Tail logs for reverse proxy setup"
        @echo
        @echo "🚀 Shortcuts:"
        @echo "  all             Build & deploy full stack (WAF + app)"
        @echo "  update-crs      Download & apply latest OWASP CRS rules"
        @echo "  gen-certs       Generate new TLS certs"
