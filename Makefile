.PHONY: help keyboard keyboard-build keyboard-server-start keyboard-server-stop keyboard-server-status keyboard-server-logs tmux-plugins pgadmin-start pgadmin-stop pgadmin-logs pgadmin-status test test-host test-docker test-docker-build install-shell install-desktop

help:
	@echo "Installation Targets:"
	@echo "  install-shell          - Install shell-only configuration"
	@echo "  install-desktop        - Install desktop environment (Fedora/Wayland)"
	@echo ""
	@echo "Testing Targets:"
	@echo "  test                   - Run Goss tests on host system"
	@echo "  test-docker-build      - Build Docker test environment"
	@echo "  test-docker            - Run Goss tests in Docker container"
	@echo ""
	@echo "Keyboard Firmware Targets:"
	@echo "  keyboard-build         - Build QMK firmware for ZSA Voyager"
	@echo "  keyboard-server-start  - Start firmware HTTP server (port 8888)"
	@echo "  keyboard-server-stop   - Stop firmware HTTP server"
	@echo "  keyboard-server-status - Check server status and list files"
	@echo "  keyboard-server-logs   - View server logs"
	@echo "  keyboard               - Build firmware and start server"
	@echo ""
	@echo "Tmux Targets:"
	@echo "  tmux-plugins           - Install/update tmux plugins via TPM"
	@echo ""
	@echo "Database Tools:"
	@echo "  pgadmin-start          - Start pgAdmin (http://localhost:5050)"
	@echo "  pgadmin-stop           - Stop pgAdmin"
	@echo "  pgadmin-logs           - View pgAdmin logs"
	@echo "  pgadmin-status         - Check pgAdmin status"

# Installation targets
install-shell:
	@echo "Installing shell configuration..."
	./install install.shell.conf.yaml

install-desktop:
	@echo "Installing desktop environment..."
	./install install.fedora.conf.yaml

# Testing targets
test:
	@echo "Running Goss tests on host system..."
	@goss validate --format documentation

test-docker-build:
	@echo "Building Docker test environment..."
	docker compose build dot

test-docker: test-docker-build
	@echo "Running Goss tests in Docker container..."
	@echo "First, installing dotfiles in container..."
	docker compose run --rm dot /bin/zsh -c "cd /home/me/dotfiles && ./install install.shell.conf.yaml && goss validate --format documentation"

keyboard-build:
	@echo "Building keyboard firmware..."
	cd qmk_keymaps/muccau && ./build.sh

keyboard-server-start:
	@echo "Starting firmware server..."
	./qmk_keymaps/serve.sh start

keyboard-server-stop:
	@echo "Stopping firmware server..."
	./qmk_keymaps/serve.sh stop

keyboard-server-status:
	@./qmk_keymaps/serve.sh status

keyboard-server-logs:
	@./qmk_keymaps/serve.sh logs

keyboard: keyboard-build keyboard-server-start
	@echo "Firmware built and server started!"
	@echo "Access firmware at http://localhost:8888/"

tmux-plugins:
	@echo "Installing/updating tmux plugins..."
	@~/.tmux/plugins/tpm/bin/install_plugins
	@echo "Tmux plugins installed!"

pgadmin-start:
	@echo "Starting pgAdmin..."
	@docker compose up -d pgadmin
	@echo "pgAdmin started at http://localhost:5050"
	@echo "Login: admin@local.dev / admin"

pgadmin-stop:
	@echo "Stopping pgAdmin..."
	@docker compose stop pgadmin

pgadmin-logs:
	@docker compose logs -f pgadmin

pgadmin-status:
	@docker compose ps pgadmin
