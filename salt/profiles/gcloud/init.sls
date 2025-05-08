profiles.gcloud.repos.gcloud_cli:
  pkgrepo.managed:
    - name: google-cloud-cli
    - humanname: Google Cloud CLI
    - baseurl: https://packages.cloud.google.com/yum/repos/cloud-sdk-el8-x86_64
    - gpgcheck: 1
    - gpgkey: https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
    - enabled: 1

profiles.gloud.packages:
  pkg.installed:
    - name: google-cloud-cli

