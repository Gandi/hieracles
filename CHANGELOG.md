Hieracles Changelog
=======================

### 0.4.4 - 2023-01-06
- fix lib/hieracles/node.rb params function to load YAML properly
  when moving to ruby3.2.0 / psych4 and the alias parsing behaviour
  change.
- fix deprecated exists? method for File:Class in favor to exist?
  (exists? is deprecated)

### 0.4.3 - 2020-03-31
- fix formatting for console colors

### 0.4.2 - 2017-03-17
- fix formatting for console on params

### 0.4.1 - 2017-01-05
- fix broken hc command

### 0.4.0 - 2016-12-30
- prepare a new command `hieracles` for preparing version 1.0.0
- refactoring of main lib to be less node-centric
- make farms list not to use cache by default

### 0.3.6 - 2016-04-27
- avoid abusive caching for all farms information

### 0.3.5 - 2016-02-18
- change extraparams separator from ; to , to avoid having to quote argument
- fix merge order for extraparams to override configuration and puppetdb values

### 0.3.4 - 2016-02-12
- add a farms_counted method to registry for a ponderated list of farms

### 0.3.3 - 2016-02-11
- add some convenience methods for usage as a lib
- add a nodes_data in registry module to get all info for all nodes.

### 0.3.2 - 2015-12-30
- fix ppdb that suffered a regression

### 0.3.1 - 2015-12-28
- added some relevance to the registry class
- changed the internal way to store the nodes information
- moved Config singleton to a proper class for modularity sake

### 0.3.0 - 2015-12-16
- added json output as an option to ppdb
- added some more ppdb commands
  - ppdb resources <queries>
  - ppdb same
  - ppdb factnames
- updated manpage for ppdb with proper documentation
- prepare a queries transformation class to 
  match puppetdb weird query language with a more human one
- updated ppdb zsh completion

### 0.2.2 - 2015-12-11
- remove support for ruby 1.9.3
  because of the mime-type gem

### 0.2.1 - 2015-12-11
- add configuration variables for connection to PuppetDB
- make PuppetDB calls fill up the facts for the node queried
- add a `facts` command to display the facts, provided locally 
  or from PuppetDB directly
- make a new CLI tool named ppdb for direct calls to PuppetDB
- add optional filtering on ppdb commands
- add a man page for ppdb
- add zsh completion for ppdb

### 0.2.0 - 2015-11-24
- fix merging for unsorted arrays
- translate all paths to absolute paths,
  so that hc can be executed out of puppet dir

### 0.1.7 - 2015-11-23
- various fixes on deep_merge behavior

### 0.1.6 - 2015-11-18
- add dependency on `deep-merge` gem like hiera does
- take in account the `merge_behavior` in hiera file
- make possible to use `%{::variables}` from puppet scope
  but this is a temporary implementation, 
  only works for top level variables

### 0.1.5 - 2015-11-15
- add `interactive` new option `-i` for having 
  CLI user prompted to fill up missing scope vars
- implement interpolation adapted from the code of hiera
- fixed the single option parsing for `-i`

### 0.1.4 - 2015-11-13
- no real change, just preparing for BSD port

### 0.1.3 - 2015-11-12
- added scope (facts) interpretation for the hiera file
  (very basic interpolation, not yet hiera-lib level)

### 0.1.2 - 2015-11-12
- fix yaml more for case of nilclass in params
- fix the case when a params file is empty

### 0.1.1 - 2015-11-11
- add json format output
- add an option to load facts files in json or yaml
- fix yaml output when there is a fixnum or a float in yaml

### 0.1.0 - 2015-11-10
- display full local path in params output
- add an option to display version
- fix yaml output for true and false cases
- added a simple filter feature for yaml format,
  but it only matches like a 'start_with'

### 0.0.6 - 2015-09-21
- added doc on how to build the debian package

### 0.0.5 - 2015-09-21
- made rspec tests compat with 2.14, bundled with jessie

### 0.0.4 - 2015-09-21
- another adjustment for debian packaging

### 0.0.3 - 2015-09-21
- preparing hieracles to be packageable for debian

### 0.0.2 - 2015-09-16
- added `yaml` format including comments about where the params is defined
- the uncommented yaml is now the format `rawyaml`

### 0.0.1 - 2015-09-12
- first alpha release
- added extensive testing using rspec
- add more config variables and parameters for fitting various environments
- initial transition to Github from internal v0.0.5 Gandi code.
