{% set config = pillar.get("profiles.sudo", {}) %}

{% do salt.test.assertion("users" in config) %}
{% do salt.test.assertion("groups" in config) %}

{% set users = config.users %}
{% set groups = config.groups %}
{% set validate_cmd = '/usr/sbin/visudo -cf %s' %}

{#-- Manage user sudoers --#}
{% for user, user_cfg in users|dictsort %}
profiles.sudo.user_{{ user }}:
  file.managed:
    - name: /etc/sudoers.d/user_{{ user }}
    - mode: '0440'
    - user: root
    - group: root
    - contents: |
        {{ user }} ALL=(ALL) {{ 'NOPASSWD:' if user_cfg.get('nopasswd', false) else '' }}{{ user_cfg.get('commands', 'ALL') }}
    - validate: {{ validate_cmd }}
{% endfor %}

{#-- Manage group sudoers --#}
{% for group, group_cfg in groups|dictsort %}
profiles.sudo.group_{{ group }}:
  file.managed:
    - name: /etc/sudoers.d/group_{{ group }}
    - mode: '0440'
    - user: root
    - group: root
    - contents: |
        %{{ group }} ALL=(ALL) {{ 'NOPASSWD:' if group_cfg.get('nopasswd', false) else '' }}{{ group_cfg.get('commands', 'ALL') }}
    - validate: {{ validate_cmd }}
{% endfor %}

