{% from 'buildbot/config.jinja' import base_config, master_config with context %}

{% set home = base_config('home') %}
{% set user = base_config('user') %}

{% set conf_path = master_config('conf_path') %}

{% if base_config('install_master') == 'true' %}

buildbot_master_upstart:
  file.managed:
    - name: /etc/init/buildbot.conf
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - source: salt://buildbot/files/buildbot.conf
    - require:
      - sls: buildbot.base
    - context:
        user: {{ user }}
        home: {{ home }}

{% endif %}
