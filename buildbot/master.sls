{% from 'buildbot/config.jinja' import defaults with context %}

buildbot:
  user.present:
    - shell: /bin/bash
    - home: /opt/buildbot
    - createhome: true

/opt/buildbot/.bash_profile:
  file.managed:
    - user: buildbot
    - group: buildbot
    - mode: 644
    - source: salt://buildbot/files/bash_profile
    - require:
      - user: buildbot

/opt/buildbot/.virtualenv:
  virtualenv.managed:
    - user: buildbot
    - requirements: salt://buildbot/files/requirements.txt
    - require:
      - user: buildbot
