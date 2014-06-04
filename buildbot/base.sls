{% from 'buildbot/config.jinja' import base_config with context %}

{% set install_type = base_config('install_type') %}

{% set home = base_config('home') %}
{% set user = base_config('user') %}

{% if install_type == 'pip' %}

buildbot_user:
  user.present:
    - name: {{ user }}
    - home: {{ home }}
    - shell: /bin/bash
    - createhome: True


buildbot_virtualenv:
  virtualenv.managed:
    - name: {{ home }}
    - user: buildbot
    - requirements: salt://buildbot/files/requirements.txt
    - require:
      - user: buildbot_user

buildbot_profile:
  file.append:
    - name: {{ home }}/.profile
    - require:
      - virtualenv: buildbot_virtualenv
    - text: |
        if [ -f "$HOME/bin/activate" ] ; then
          source ~/bin/activate
        fi

{% endif %}

