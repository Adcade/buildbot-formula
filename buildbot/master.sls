{% from 'buildbot/config.jinja' import defaults with context %}

buildbot:
  pkg.installed

{{ defaults('MASTER_BASEDIR') }}:
  file.directory:
    - user: {{ defaults('MASTER_USER') }}
    - group: {{ defaults('MASTER_USER') }}
    - mode: 755
    - makedirs: true
    - require:
      - pkg: buildbot

create_buildmaster:
  cmd.wait:
    - name: buildbot create-master master/
    - user: {{ defaults('MASTER_USER') }}
    - cwd: {{ defaults('MASTER_BASEDIR') }}
    - watch:
      - pkg: buildbot

/etc/default/buildmaster:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - source: salt://buildbot/files/buildmaster
    - context:
      MASTER_ENABLED: {{ defaults('MASTER_ENABLED') }}
      MASTER_NAME: {{ defaults('MASTER_NAME') }}
      MASTER_USER: {{ defaults('MASTER_USER') }}
      MASTER_BASEDIR: {{ defaults('MASTER_BASEDIR') }}
      MASTER_OPTIONS: {{ defaults('MASTER_OPTIONS') }}
      MASTER_PREFIXCMD: {{ defaults('MASTER_PREFIXCMD') }}
