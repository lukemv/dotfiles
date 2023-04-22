package dotfiles

import (
	"fmt"
	"os"
	"path/filepath"
	"testing"
)

func TestSymlinks(t *testing.T) {

	home, err := os.UserHomeDir()

	if err != nil {
		t.Errorf("failed to locate user home folder: %v", err)
	}

	cwd, err := os.Getwd()
	dfPath := filepath.Dir(cwd)

	if err != nil {
		t.Errorf("failed to resolve cwd: %v", err)
	}

	maps := map[string]string{
		fmt.Sprintf("%s/.bashrc", home):    fmt.Sprintf("%s/bashrc", dfPath),
		fmt.Sprintf("%s/.zshrc", home):     fmt.Sprintf("%s/zshrc", dfPath),
		fmt.Sprintf("%s/.tmux.conf", home): fmt.Sprintf("%s/tmux.conf", dfPath),
		fmt.Sprintf("%s/.vimrc", home):     fmt.Sprintf("%s/vimrc", dfPath),
		fmt.Sprintf("%s/.gitconfig", home): fmt.Sprintf("%s/gitconfig", dfPath),
		// config files
		fmt.Sprintf("%s/.config/gh/config.yml", home): fmt.Sprintf("%s/config/gh/config.yml", dfPath),
	}

	for k, v := range maps {
		res, err := os.Readlink(k)

		if err != nil {
			t.Errorf("failed to read link %s: %v", k, err)
		}

		if res != v {
			t.Errorf("got %s, wanted %s", res, v)
		}
	}
}
