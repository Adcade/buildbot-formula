{% from 'buildbot/config.jinja' import defaults with context %}

buildbot-slave:
  pkg.installed

{{ defaults('SLAVE_BASEDIR') }}:
  file.directory:
    - user: {{ defaults('SLAVE_USER') }}
    - group: {{ defaults('SLAVE_USER') }}
    - mode: 755
    - makedirs: true
    - require:
      - pkg: buildbot-slave

create_buildslave:
  cmd.wait:
    - name: buildslave create-slave slave/ {{ defaults('MASTER_ADDRESS') }} {{ defaults('MASTER_USERNAME') }} {{ defaults('MASTER_PASSWORD') }}
    - user: {{ defaults('MASTER_USER') }}
    - cwd: {{ defaults('MASTER_BASEDIR') }}
    - watch:
      - pkg: buildbot-slave

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
