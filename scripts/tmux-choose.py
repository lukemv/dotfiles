#!/usr/bin/env python3
import libtmux
import os


def list_windows():
    server = libtmux.Server()
    session = server.sessions.filter(session_name="development")[0]
    windows = list([f"{w.id}: {w.name}" for w in session.windows])

    for i in range(1, 3):
        if os.path.exists(f"/tmp/tmux.prev.{i}"):
            with open(f"/tmp/tmux.prev.{i}", "r") as f:
                w = f.read()
                if w.strip() in windows:
                    windows.remove(w.strip())
                    windows.insert(0, w.strip())

    for window in windows:
        print(window)


if __name__ == "__main__":
    list_windows()
