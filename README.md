Hieracles
================

[![Gem Version](https://img.shields.io/gem/v/hieracles.svg)](http://rubygems.org/gems/hieracles)
[![Downloads](http://img.shields.io/gem/dt/hieracles.svg)](https://rubygems.org/gems/hieracles)
[![Build Status](https://img.shields.io/travis/Gandi/hieracles.svg)](https://travis-ci.org/Gandi/hieracles)
[![Coverage Status](https://img.shields.io/coveralls/Gandi/hieracles.svg)](https://coveralls.io/r/Gandi/hieracles?branch=master)
[![Dependency Status](https://img.shields.io/gemnasium/Gandi/hieracles.svg)](https://gemnasium.com/Gandi/hieracles)
[![Code Climate](https://img.shields.io/codeclimate/github/Gandi/hieracles.svg)](https://codeclimate.com/github/Gandi/hieracles)

Hieracles is a command-line tool for analysis and deep examination of [Hiera][hiera] paramaters in a [Puppet][puppet] setup. It's used internally at [Gandi][gandi] and its first incarnation is strongly tied to Gandi puppet architecture. But Hieracles tends to become, in time, a generic Hiera overlay visualisation tool.

Prerequisite
---------------

There are many ways to setup puppet and use hiera. This tool is designed to match a certain kind of setup, including:

- an [external node classifier (ENC)][enc]
- a yaml hiera datastore
- classes that only contains includes and no code
- local availability of a hierafile

As the development is going on, more generic options will be provided, but for now, we mainly make it robust to fit the context we have.


Install
-----------
At this stage, it's to early to even think about installing anything. The internal code from Gandi is still in progress of transition towards total freedom and generic usage.

Despite this warning, you can

    gem install hieracles

or add in your Gemfile:

    gem 'hieracles'


Configuration
----------------
At first launch it will create a configuration file in `~/.config/hieracles/config.yml`

Configuration variables are:

- classpath
- modulepath
- basepath
- encpath
- hierafile
- format

For an  example setup you can check in `spec/files`.

Usage
-------------


    Usage: hc <fqdn> <command> [extra_args]

    Available commands:
      info        provides the farm, datacenter, country
                  associated to the given fqdn
      files       list all files containing params affecting this fqdn
                  (in more than commons)
      paths       list all file paths for files with params
      modules     list modules included in the farm where the node is
      params      list params for the node matching the fqdn
                  An extra filter string can be added to limit the list
                  use ruby regexp without the enclosing slashes
                  eg. hc <fqdn> params postfix.*version
                  eg. hc <fqdn> params '^postfix'
                  eg. hc <fqdn> params 'version$'
      allparams   same as params but including the common.yaml params (huge)
                  Also accepts a search string

    Extra args:
      -f <plain|console|csv|yaml|rawyaml> default console
      -p extraparam=what;anotherparam=this 
      -c <configfile>
      -h <hierafile>
      -b <basepath> default ./
      -e <encdir>

Completion
-------------
There is a simple zsh completion file in `tools/completion`. 

If you use [oh-my-zsh][omz] put it in `~/.oh-my-zsh/completions`

    wget -O ~/.oh-my-zsh/completions/_hc https://raw.githubusercontent.com/Gandi/hieracles/master/tools/completion/_hc
    echo 'compdef _hc hc "bundle exec hc"' >> ~/.zshrc

Otherwise 

    mkdir ~/.zsh-completions
    wget -O ~/.zsh-completions/_hc https://raw.githubusercontent.com/Gandi/hieracles/master/tools/completion/_hc
    echo 'fpath=(~/.zsh-completions $fpath)' >> ~/.zshrc
    echo 'compdef _hc hc "bundle exec hc"' >> ~/.zshrc


Debian packaging
--------------------
On a Jessie

    apt-get install gem2deb ruby-coveralls ruby-all-dev ruby-rspec ruby-rspec-expectations 

Then build

    gem2deb -p hieracles hieracles

and install

    dpkg -i hieracles_0.0.6-1_all.deb

Todo
--------------
- add json format
- add override information in yaml format
- add a command to search for node according to a filter
- add a command to find all nodes that use a given module
- add a command that finds all nodes for which a params is defined
- detect unused params
- create a repl, which at launch reads all data so the queries are blazing fast
- adapt to other ENCs
- adapt to puppetdb storage


Authors
-----------
Hieracles original code is writen by [@mose](https://github.com/mose).

License
-----------
Hieracles is available under MIT license. See [LICENSE](./LICENSE) file for more details

Copyright
------------
copyright (c) 2015 Gandi http://gandi.net


[puppet]:    https://github.com/puppetlabs/puppet
[hiera]:     https://github.com/puppetlabs/hiera
[gandi]:     https://gandi.net
[enc]:       https://docs.puppetlabs.com/guides/external_nodes.html
[omz]:       https://github.com/robbyrussell/oh-my-zsh
