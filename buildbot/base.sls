{% from 'buildbot/config.jinja' import base_config with context %}
{% from 'buildbot/map.jinja' import buildbot with context %}

{% set install_type = base_config('install_type') %}

{% set home = base_config('home') %}
{% set user = base_config('user') %}

{% if install_type == 'pip' %}

include:
  - nvm

buildbot_packages:
  pkg.installed:
    - names:
        - python-dev
        - {{ buildbot.virtualenv }}

buildbot_user:
  user.present:
    - name: {{ user }}
    - home: {{ home }}
    - shell: /bin/bash
    - createhome: True

buildbot_virtualenv:
  virtualenv.managed:
    - name: {{ home }}
    - user: {{ user }}
    - requirements: salt://buildbot/files/requirements.txt
    - require:
      - user: buildbot_user
      - pkg: buildbot_packages

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

