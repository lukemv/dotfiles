1password_repo:
  pkgrepo.managed:
    - name: 1password
    - baseurl: https://downloads.1password.com/linux/rpm/stable/$basearch
    - gpgkey: https://downloads.1password.com/linux/keys/1password.asc
    - gpgcheck: 1
    - enabled: 1
    - repo_gpgcheck: 1
    - gpgautoimport: 1

1password_cli:
  pkg.installed:
    - name: 1password-cli
    - require:
      - pkgrepo: 1password_repo

