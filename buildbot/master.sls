{% from 'buildbot/config.jinja' import base_config with context %}

{% if base_config('install_master') == 'true' %}

buildbot_check_master:
  cmd.run:
    - name: "[ -d {{ base_config('home') }}/master ]; if [ $? == 1 ]; then echo -e '\nchanged=true'; fi"
    - stateful: True
    - require:
      - sls: buildbot.base

buildbot_master:
  cmd.wait:
    - name: buildbot create-master master
    - user: buildbot
    - cwd: {{ base_config('home') }}
    - env:
      - PATH: '$PATH:/opt/buildbot/bin'
    - watch:
      - cmd: buildbot_check_master

buildbot_master_config:
  file.managed:
    - name: /opt/buildbot/master/master.cfg
    - user: buildbot
    - group: buildbot
    - template: jinja
    - mode: 644
    - source: salt://buildbot/files/master.cfg

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
        user: {{ base_config('user') }}
        home: {{ base_config('home') }}

buildbot_service:
  service.running:
    - name: buildbot
    - reload: True
    - require:
      - file: buildbot_master_upstart
    - watch:
      - file: buildbot_master_config

{% endif %}
