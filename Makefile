.PHONY: help keyboard keyboard-build keyboard-server-start keyboard-server-stop keyboard-server-status keyboard-server-logs

help:
	@echo "Keyboard Firmware Targets:"
	@echo "  keyboard-build         - Build QMK firmware for ZSA Voyager"
	@echo "  keyboard-server-start  - Start firmware HTTP server (port 8888)"
	@echo "  keyboard-server-stop   - Stop firmware HTTP server"
	@echo "  keyboard-server-status - Check server status and list files"
	@echo "  keyboard-server-logs   - View server logs"
	@echo "  keyboard               - Build firmware and start server"

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
