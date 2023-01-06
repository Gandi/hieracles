Hieracles
================

[![Gem Version](https://img.shields.io/gem/v/hieracles.svg)](http://rubygems.org/gems/hieracles)
[![Downloads](http://img.shields.io/gem/dt/hieracles.svg)](https://rubygems.org/gems/hieracles)
[![Build Status](https://img.shields.io/travis/Gandi/hieracles.svg)](https://travis-ci.org/Gandi/hieracles)
[![Coverage Status](https://img.shields.io/coveralls/Gandi/hieracles.svg)](https://coveralls.io/github/Gandi/hieracles)
[![Dependency Status](https://gemnasium.com/Gandi/hieracles.svg)](https://gemnasium.com/Gandi/hieracles)
[![Code Climate](https://img.shields.io/codeclimate/github/Gandi/hieracles.svg)](https://codeclimate.com/github/Gandi/hieracles)

Hieracles is a command-line tool for analysis and deep examination of [Hiera][hiera] parameters in a [Puppet][puppet] setup. It can be used to quickly visualize, from a local puppet (typically on a developers environment), all the Hiera params related to a specific node.

It's used internally at [Gandi][gandi] and its first incarnation is strongly tied to Gandi puppet architecture. But Hieracles tends to become, in time, a generic Hiera overlay visualization tool.

Have a look at the [Changelog](CHANGELOG.md) for details about the evolution.

Prerequisite
---------------

There are many ways to setup puppet and use Hiera. This tool is designed to match a certain kind of setup, including:

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

- basepath (alias localpath)  
  This is where your puppet repo is cloned
- classpath  
  where to find classes defined in the ENC
- modulepath  
  where to find modules called in the classes
- encpath  
  where to read information about each nodes
- hierafile  
  where to find a hierafile customized for your local puppet installation
- format  
  can be plain, console, csv, yaml, rawyaml, json
- defaultscope  
  a hash defining scope variables that will be used if not defined by a facts file or by params passed as arguments

For an  example setup you can check in `spec/files`.

If you don't specify the basepath, your current location will be used as a base path.

Usage
-------------

    Usage: hc <fqdn> <command> [extra_args]

    Available commands:
      info        provides the farm, datacenter, country
                  associated to the given fqdn
                  An extra param can be added for filtering
                  eg. hc <fqdn> info timestamp
                  eg. hc <fqdn> info farm
      facts       lists facts, either provided as a fact file
                  or grabbed from puppetdb.
                  An extra param can be added for filtering
                  eg. hc <fqdn> facts architecture
                  eg. hc <fqdn> facts 'memory.*mb'
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
      -f <plain|console|csv|yaml|rawyaml|json> - default console
      -p extraparam=what,anotherparam=this 
      -c <configfile>
      -h <hierafile>
      -b <basepath> default ./
      -e <encdir>
      -v - displays version
      -y <fact_file> - facts in yaml format
      -j <fact_file> - facts in json format
      -i - interactive mode
      -db - query puppetdb
      -nodb - do not query puppetdb


About facts aka. scope
------------------------

Like with Hiera CLI you can use hieracles with defined top-scope variables. Those top-scope vars can be defined with:

- `-p extraparam=what;anotherparam=this`
- `-y <fact_file>` which takes the fact file from a yaml source created by `facter -y` on your node for example, but it can be written manually for experimentation purposes.
- `-j <fact_file>` same as above, but with output of `facter -j`

You can define a default scope in your configuration file `defaultscope` in `~/.confg/hieracles/config.yml`. For example:

    ---
    classpath: farm_modules/%s/manifests/init.pp
    hierafile: dev/hiera-local.yaml
    encpath: enc 
    defaultscope:
        operatingsystem: Debian
        lsbdistcodename: Jessie

In order the scope with be built from:

- the config file
- if `-y <file>` option (or `-j`) is present the `defaultscope` in the config file will be totally ignored
- the `-p key=value` option with overide variable per variable

Note that if the scope var is not defined or if the file declared in hiera config is not found, this entry is silently ignored.

An option, `-i` enables the `interactive mode` in which you are prompted to fill up for undefined scope variables encountered in the hiera config file. This behavior can be made systematic by enabling `interactive: true` in hieracles configuration file.


Optionnaly connecting to a puppetDB
--------------------------------------

#### Configuration

When adding to the configuration file:

    usedb: false
    puppetdb:
      usessl: false
      host: puppetdb.example.com
      port: 8080

or for a ssl setup:

    usedb: false
    puppetdb:
      usessl: true
      host: puppetdb.example.com
      port: 8081
      key: path/to/key
      key_password: somepassword
      cert: path/to/cert
      ca_file: path/to/ca_file
      verify_peer: false

Note: the SSL config was not tested yet.

#### Usage

If you set `usedb: false` the `hc` commands will not query the puppetdb unless you pass the `-db` options.

If you set `usedb: true` the `hc` command will query the puppetdb by default and display extra informations for the queried node. This default behavior can be changed by passing the `-nodb` option on the commandline.

#### Impact

When usedb is true, a call to puppetdb will be made for all commands to retrieve facts if they are present for the queried node.

#### Extra commandline tool: ppdb

When hieracles is configured with parameters to connect to PuppetDB, you also can use the ppdb commandline to send direct queries to the database. Check `man ppdb` for more information.


Completion
-------------
There is a simple zsh completion file in `tools/completion`. 

If you use [oh-my-zsh][omz] put it in `~/.oh-my-zsh/completions`

    wget -O ~/.oh-my-zsh/completions/_hc https://raw.githubusercontent.com/Gandi/hieracles/master/tools/completion/zsh/_hc
    echo 'compdef _hc hc "bundle exec hc"' >> ~/.zshrc
    echo 'autoload -U _hc' >> ~/.zshrc
    
Otherwise 

    mkdir ~/.zsh-completions
    wget -O ~/.zsh-completions/_hc https://raw.githubusercontent.com/Gandi/hieracles/master/tools/completion/zsh/_hc
    echo 'fpath=(~/.zsh-completions $fpath)' >> ~/.zshrc
    echo 'compdef _hc hc "bundle exec hc"' >> ~/.zshrc
    echo 'autoload -U _hc' >> ~/.zshrc

Note: `ppdb` also has a completion file https://raw.githubusercontent.com/Gandi/hieracles/master/tools/completion/zsh/_ppdb

Debian packaging
--------------------

A debian/ dir is included you can just use `sbuild` in here and it will build the .deb.

For new releases:

- update the debian/changelog file

FreeBSD packaging
--------------------

For new releases:

- update the Makefile with new version number
- in a FreeBSD jail or machine:
```
cd hieracles
git pull
cd ports/
make makesum
# test the stuff, get that there is no warning or what
portlint
make stage
make check-orphans
make package
make install
make deinstall
make clean
cd ..
shar `find rubygem-hieracles` > rubygem-hieracles.shar
```
- on https://bugs.freebsd.org submit the new version


GEM packaging
-------------

- edit the CHANGELOG.md file (bump version/add the necessary comments)
- `gem build hieracles.gemspec`
- `gem install [--user-install] ./hieracles-X.Y.Z.gem`


Todo
--------------
- add json format (done)
- add override information in yaml format (done)
- add a command to search for node according to a filter (done)
- add a command to find all nodes that use a given module
- add a command that finds all nodes for which a params is defined
- detect unused params
- create a repl, which at launch reads all data so the queries are blazing fast
- adapt to other ENCs
- adapt to PuppetDB storage

Other hiera tools
-------------------

- https://github.com/binford2k/hiera_explain

Authors
-----------
Hieracles original code is written by [@mose](https://github.com/mose).

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
