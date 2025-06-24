
# To figure out which python versions are available
# ssh into the server and sudo su (we run pyenv as root)
# /usr/local/pyenv/bin/pyenv install --list
{% set virtualenv_path = '/opt/python-envs' %}

# These packages are required to build Python versions
profiles.python.pyenv.packages:
  pkg.installed:
    - pkgs:
      - make
      - openssl-devel
      - zlib-devel
      - bzip2-devel
      - readline-devel
      - sqlite-devel
      - wget
      - curl
      - llvm

profiles.python.pyenv.groups:
  pkg.group_installed:
    - name: 'Development Tools'

# The top level directory should be readable by all users
profiles.python.directory:
  file.directory:
    - name: {{ virtualenv_path }}
    - user: root
    - group: root
    - mode: 755
    - makedirs: True

{% set kernels_add = pillar.get("profiles.python.kernels.add", []) %}

{% for kernel in kernels_add %}
{% do salt.test.assertion("pyenv_version" in kernel) %}
{% do salt.test.assertion("kernel_name" in kernel) %}
{% do salt.test.assertion("packages" in kernel) %}
{% do salt.test.assertion("index_url" in kernel) %}
{% do salt.test.assertion("acl_user" in kernel) %}
{% do salt.test.assertion("acl_group" in kernel) %}

{% set pyenv_version = kernel.get("pyenv_version") %}
{% set kernel_name = kernel.get("kernel_name") %}
{% set pypi_packages = kernel.get("packages") %}
{% set index_url = kernel.get("index_url") %}
{% set extra_index_url = kernel.get("extra_index_url") %}
{% set acl_user = kernel.get("acl_user") %}
{% set acl_group = kernel.get("acl_group") %}
{% set kernel_path = virtualenv_path + "/" + kernel_name %}

# note that this will creat a python at /usr/local/pyenv/versions/<python_version>
# This s has to be a valid pyenv available version
profiles.python.{{ kernel_name }}.pyenv:
  pyenv.installed:
    - name: {{ pyenv_version }}
    - user: root

profiles.python.{{ kernel_name }}.directory:
  file.directory:
    - name: {{ kernel_path }}
    - user: {{ acl_user }}
    - group: {{ acl_group }}
    # Set the setgid bit so that everything in this
    # directory is writable by the group
    - mode: 2775
    - makedirs: True

profiles.python.{{ kernel_name}}.virtualenv:
  cmd.run:
    - name: /usr/local/pyenv/versions/{{ pyenv_version }}/bin/python -m venv {{ virtualenv_path }}/{{ kernel_name }}
    - creates: {{ virtualenv_path }}/{{ kernel_name }}/bin/python

{% for pypi_package in pypi_packages %}
profiles.python.pip-install.{{ kernel_name }}.{{ pypi_package }}:
  pip.installed:
    - name: "{{ pypi_package }}"
    - bin_env: {{ virtualenv_path }}/{{ kernel_name }}/bin/pip
    - upgrade: True
    - index_url: {{ index_url }}
    {% if extra_index_url %}
    - extra_index_url: {{ extra_index_url }}
    {% endif %}
{% endfor %}

# Always update pip to the latest version
profiles.python.pip-install.{{ kernel_name }}-pip:
  pip.installed:
    - name: pip
    - bin_env: {{ virtualenv_path }}/{{ kernel_name }}/bin/pip
    - upgrade: True

{% set kernels_remove = pillar.get("profiles.python.kernels.remove", []) %}

profiles.python.remove.{{ kernel_name }}-directory:
  file.absent:
    - name: {{ virtualenv_path }}/{{ kernel_name }}
{% endfor %}

