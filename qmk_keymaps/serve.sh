#!/bin/bash
#
# QMK Firmware Server Manager
# Serves compiled firmware binaries via HTTP
#

set -e

cd "$(dirname "$0")/.."

case "${1:-start}" in
    start)
        echo "🚀 Starting QMK firmware server..."
        docker compose -f docker-compose.qmk.yml up -d firmware-server

        # Wait a moment for server to start
        sleep 1

        # Get the container's IP and port
        if docker ps | grep -q qmk-firmware-server; then
            echo "✅ Firmware server is running!"
            echo ""
            echo "📂 Available firmware files:"
            curl -s http://localhost:8888/ | grep -o 'href="[^"]*\.bin"' | sed 's/href="//;s/"//' || echo "   (no firmware files yet)"
            echo ""
            echo "🌐 Access your firmware at:"
            echo "   http://localhost:8888/"
            echo ""
            echo "   Or from another machine on your network:"
            echo "   http://$(hostname -I | awk '{print $1}'):8888/"
            echo ""
            echo "💡 Tip: Build firmware with './qmk_keymaps/muccau/build.sh'"
            echo "        Then download from http://localhost:8888/"
        else
            echo "❌ Failed to start firmware server"
            exit 1
        fi
        ;;

    stop)
        echo "🛑 Stopping QMK firmware server..."
        docker compose -f docker-compose.qmk.yml stop firmware-server
        docker compose -f docker-compose.qmk.yml rm -f firmware-server
        echo "✅ Firmware server stopped"
        ;;

    restart)
        echo "🔄 Restarting QMK firmware server..."
        $0 stop
        $0 start
        ;;

    status)
        if docker ps | grep -q qmk-firmware-server; then
            echo "✅ Firmware server is running on port 8888"
            echo ""
            echo "📂 Available firmware files:"
            curl -s http://localhost:8888/ | grep -o 'href="[^"]*\.bin"' | sed 's/href="//;s/"//' | sed 's/^/   /'
            echo ""
            echo "🌐 http://localhost:8888/"
        else
            echo "❌ Firmware server is not running"
            echo "   Run '$0 start' to start it"
            exit 1
        fi
        ;;

    logs)
        docker compose -f docker-compose.qmk.yml logs -f firmware-server
        ;;

    *)
        echo "Usage: $0 {start|stop|restart|status|logs}"
        echo ""
        echo "Commands:"
        echo "  start   - Start the firmware server (default)"
        echo "  stop    - Stop the firmware server"
        echo "  restart - Restart the firmware server"
        echo "  status  - Check server status and list files"
        echo "  logs    - View server logs"
        exit 1
        ;;
esac
