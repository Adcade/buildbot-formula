{% from 'buildbot/config.jinja' import defaults with context %}

buildbot-slave:
  pkg.installed

/etc/default/buildslave:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - source: salt://buildbot/files/buildslave
    - context:
      SLAVE_ENABLED: {{ defaults('SLAVE_ENABLED') }}
      SLAVE_NAME: {{ defaults('SLAVE_NAME') }}
      SLAVE_USER: {{ defaults('SLAVE_USER') }}
      SLAVE_BASEDIR: {{ defaults('SLAVE_BASEDIR') }}
      SLAVE_OPTIONS: {{ defaults('SLAVE_OPTIONS') }}
      SLAVE_PREFIXCMD: {{ defaults('SLAVE_PREFIXCMD') }}
