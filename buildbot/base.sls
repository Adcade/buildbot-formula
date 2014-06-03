{% from 'buildbot/config.jinja' import base_config with context %}

{% if base_config('install_type') == 'pip' %}

buildbot_user:
  user.present:
    - name: {{ base_config('user') }}
    - home: {{ base_config('home') }}
    - shell: /bin/bash
    - createhome: True


buildbot_virtualenv:
  virtualenv.managed:
    - name: {{ base_config('home') }}
    - user: buildbot
    - requirements: salt://buildbot/files/requirements.txt
    - require:
      - user: buildbot_user

buildbot_profile:
  file.append:
    - name: {{ base_config('home') }}/.profile
    - require:
      - virtualenv: buildbot_virtualenv
    - text: |
        if [ -f "$HOME/bin/activate" ] ; then
          source ~/bin/activate
        fi

{% endif %}

