Hieracles Changelog
=======================

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
- added a simple filter fetaure for yaml format,
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
