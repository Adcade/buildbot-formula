include:
  - buildbot.master
  - buildbot.slave

buildbot_reqs:
  pkg.installed:
    - pkgs:
      - python-pip
      - python-dev
      - python-virtualenv
