.PHONY: help keyboard keyboard-build keyboard-server-start keyboard-server-stop keyboard-server-status keyboard-server-logs tmux-plugins pgadmin-start pgadmin-stop pgadmin-logs pgadmin-status

help:
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
