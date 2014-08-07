========
Buildbot
========

.. note::

    Currently I will not manage master.cfg or slave.cfg, they are too complicated to manage with Saltstack.

    See the full `Salt Formulas installation and usage instructions
    <http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.

Available states
================

.. contents::
    :local:

``buildbot``
------------
Install both Buildmaster and Buildslave components.

``buildbot.slave``
-----------------------
Install Buildslave components.

``buildbot.master``
--------------------
Install Buildmaster components.
