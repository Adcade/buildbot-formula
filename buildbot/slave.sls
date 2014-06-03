{% from 'buildbot/config.jinja' import base_config with context %}

{% if base_config('install_slave') == 'true' %}

buildbot_slave_check:
  cmd.run:
    - name: "[ -d {{ base_config('home') }}/slave ]; if [ $? == 1 ]; then echo -e '\nchanged=true'; fi"
    - stateful: True
    - require:
      - sls: buildbot.base

buildbot_slave_pip:
  pip.installed:
    - name: buildbot-slave
    - user: {{ base_config('user') }}
    - bin_env: {{ base_config('home') }}/bin/pip
    - require:
      - sls: buildbot.base

buildbot_slave:
  cmd.wait:
    - name: 'buildslave create-slave slave localhost:9989 example-slave pass'
    - user:{{ base_config('user') }}
    - cwd:  {{ base_config('home') }}
    - env:
      - PATH: '$PATH:/opt/buildbot/bin'
    - watch:
      - cmd: buildbot_slave_check
    - require:
      - pip: buildbot_slave_pip

buildbot_slave_upstart:
  file.managed:
    - name: /etc/init/buildslave.conf
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - source: salt://buildbot/files/buildslave.conf
    - require:
      - sls: buildbot.base
    - context:
        user: {{ base_config('user') }}
        home: {{ base_config('home') }}

buildslave_service:
  service.running:
    - name: buildslave
    - require:
      - file: buildbot_slave_upstart

{% endif %}
