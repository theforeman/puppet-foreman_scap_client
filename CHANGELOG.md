# Changelog

## [2.0.0](https://github.com/theforeman/puppet-foreman_scap_client/tree/2.0.0) (2026-09-09)

[Full Changelog](https://github.com/theforeman/puppet-foreman_scap_client/compare/v1.1.1...2.0.0)

**Breaking changes:**

- Switch from puppet to OpenVox 8 [\#89](https://github.com/theforeman/puppet-foreman_scap_client/pull/89) ([bastelfreak](https://github.com/bastelfreak))

## [v1.1.1](https://github.com/theforeman/puppet-foreman_scap_client/tree/v1.1.1) (2026-09-09)

[Full Changelog](https://github.com/theforeman/puppet-foreman_scap_client/compare/v1.1.0...v1.1.1)

**Fixed bugs:**

- Rename COPYING to LICENSE [\#90](https://github.com/theforeman/puppet-foreman_scap_client/pull/90) ([ekohl](https://github.com/ekohl))

## [v1.1.0](https://github.com/theforeman/puppet-foreman_scap_client/tree/v1.1.0) (2026-08-04)

[Full Changelog](https://github.com/theforeman/puppet-foreman_scap_client/compare/v1.0.0...v1.1.0)

**Implemented enhancements:**

- Add AlmaLinux 8 & 9 support [\#79](https://github.com/theforeman/puppet-foreman_scap_client/pull/79) ([archanaserver](https://github.com/archanaserver))
- Confine custom fact to only execute on Linux systems [\#78](https://github.com/theforeman/puppet-foreman_scap_client/pull/78) ([amandaharth](https://github.com/amandaharth))
- Mark compatible with puppetlabs/stdlib 9.x [\#77](https://github.com/theforeman/puppet-foreman_scap_client/pull/77) ([ekohl](https://github.com/ekohl))

**Merged pull requests:**

- Update puppet\_metadata to ~\> 4.0 and voxpupuli-acceptance to ~\> 3.0 [\#80](https://github.com/theforeman/puppet-foreman_scap_client/pull/80) ([archanaserver](https://github.com/archanaserver))

## [v1.0.0](https://github.com/theforeman/puppet-foreman_scap_client/tree/v1.0.0) (2023-11-08)

[Full Changelog](https://github.com/theforeman/puppet-foreman_scap_client/compare/v0.4.1...v1.0.0)

**Breaking changes:**

- Drop Puppet 6 support [\#76](https://github.com/theforeman/puppet-foreman_scap_client/pull/76) ([ekohl](https://github.com/ekohl))
- Drop Debian/Ubuntu support [\#70](https://github.com/theforeman/puppet-foreman_scap_client/pull/70) ([ekohl](https://github.com/ekohl))
- Drop Puppet 5 support [\#67](https://github.com/theforeman/puppet-foreman_scap_client/pull/67) ([evgeni](https://github.com/evgeni))

**Implemented enhancements:**

- Support Puppet 8 [\#74](https://github.com/theforeman/puppet-foreman_scap_client/pull/74) ([ekohl](https://github.com/ekohl))
- Use a structured fact for rh\_certificate [\#73](https://github.com/theforeman/puppet-foreman_scap_client/pull/73) ([ekohl](https://github.com/ekohl))
- add EL8 and EL9 support [\#68](https://github.com/theforeman/puppet-foreman_scap_client/pull/68) ([evgeni](https://github.com/evgeni))
- Use $trusted\['certname'\] for the certificate file path, not $facts\['fqdn'\] [\#63](https://github.com/theforeman/puppet-foreman_scap_client/pull/63) ([vollmerk](https://github.com/vollmerk))
- Allow stdlib 6.x and require 4.25.0 [\#61](https://github.com/theforeman/puppet-foreman_scap_client/pull/61) ([ekohl](https://github.com/ekohl))
- Allow switching provider for Package installation [\#58](https://github.com/theforeman/puppet-foreman_scap_client/pull/58) ([vollmerk](https://github.com/vollmerk))

**Merged pull requests:**

- Update gems to support testing Puppet 8 [\#75](https://github.com/theforeman/puppet-foreman_scap_client/pull/75) ([ekohl](https://github.com/ekohl))
- Add a basic acceptance test [\#69](https://github.com/theforeman/puppet-foreman_scap_client/pull/69) ([ekohl](https://github.com/ekohl))
- migrate to GHA [\#66](https://github.com/theforeman/puppet-foreman_scap_client/pull/66) ([evgeni](https://github.com/evgeni))

## [v0.4.1](https://github.com/theforeman/puppet-foreman_scap_client/tree/v0.4.1) (2020-03-02)

[Full Changelog](https://github.com/theforeman/puppet-foreman_scap_client/compare/v0.3.24...v0.4.1)

**Merged pull requests:**

- Drop EOL Puppet versions and require \>= 5.5.8; use data types [\#60](https://github.com/theforeman/puppet-foreman_scap_client/pull/60) ([ekohl](https://github.com/ekohl))
- Correct specs context [\#59](https://github.com/theforeman/puppet-foreman_scap_client/pull/59) ([ekohl](https://github.com/ekohl))

## [v0.3.24](https://github.com/theforeman/puppet-foreman_scap_client/tree/v0.3.24) (2019-11-26)

[Full Changelog](https://github.com/theforeman/puppet-foreman_scap_client/compare/v0.3.23...v0.3.24)

**Implemented enhancements:**

- Fixes [\#28358](https://projects.theforeman.org/issues/28358) - Call subscription-manager by full path [\#57](https://github.com/theforeman/puppet-foreman_scap_client/pull/57) ([xprazak2](https://github.com/xprazak2))

## [v0.3.23](https://github.com/theforeman/puppet-foreman_scap_client/tree/v0.3.23) (2019-08-21)

[Full Changelog](https://github.com/theforeman/puppet-foreman_scap_client/compare/v0.3.22...v0.3.23)

**Merged pull requests:**

- These changes allow this module to work with foreman 1.20+ [\#55](https://github.com/theforeman/puppet-foreman_scap_client/pull/55) ([zshahan](https://github.com/zshahan))
- Use $package\_name in resource title [\#54](https://github.com/theforeman/puppet-foreman_scap_client/pull/54) ([yjarosz](https://github.com/yjarosz))

## [v0.3.22](https://github.com/theforeman/puppet-foreman_scap_client/tree/v0.3.22) (2019-05-23)

[Full Changelog](https://github.com/theforeman/puppet-foreman_scap_client/compare/v0.3.20...v0.3.22)

**Implemented enhancements:**

- Fixes [\#26700](https://projects.theforeman.org/issues/26700) - Add timeout [\#52](https://github.com/theforeman/puppet-foreman_scap_client/pull/52) ([xprazak2](https://github.com/xprazak2))

## [v0.3.20](https://github.com/theforeman/puppet-foreman_scap_client/tree/v0.3.20) (2019-02-06)

[Full Changelog](https://github.com/theforeman/puppet-foreman_scap_client/compare/v0.3.19...v0.3.20)

**Implemented enhancements:**

- use different name for ubuntu package [\#48](https://github.com/theforeman/puppet-foreman_scap_client/pull/48) ([hlawatschek](https://github.com/hlawatschek))

**Merged pull requests:**

- Add missing docs for parameters [\#50](https://github.com/theforeman/puppet-foreman_scap_client/pull/50) ([xprazak2](https://github.com/xprazak2))
- Add tests, improve metadata [\#49](https://github.com/theforeman/puppet-foreman_scap_client/pull/49) ([ekohl](https://github.com/ekohl))

## [v0.3.19](https://github.com/theforeman/puppet-foreman_scap_client/tree/v0.3.19) (2018-07-27)

[Full Changelog](https://github.com/theforeman/puppet-foreman_scap_client/compare/v0.3.18...v0.3.19)

**Implemented enhancements:**

- Fixes [\#20449](https://projects.theforeman.org/issues/20449) - Add cron\_splay parameter [\#47](https://github.com/theforeman/puppet-foreman_scap_client/pull/47) ([treydock](https://github.com/treydock))
- Add parameters fetch\_remote\_resources, http\_proxy\_server and http\_proxy\_port [\#43](https://github.com/theforeman/puppet-foreman_scap_client/pull/43) ([treydock](https://github.com/treydock))
- Fixes [\#21389](https://projects.theforeman.org/issues/21389) - Add header into cron file [\#41](https://github.com/theforeman/puppet-foreman_scap_client/pull/41) ([xprazak2](https://github.com/xprazak2))
- Adding install options. [\#40](https://github.com/theforeman/puppet-foreman_scap_client/pull/40) ([dforste](https://github.com/dforste))

**Merged pull requests:**

- Fix README markdown [\#42](https://github.com/theforeman/puppet-foreman_scap_client/pull/42) ([alexjfisher](https://github.com/alexjfisher))

## [v0.3.18](https://github.com/theforeman/puppet-foreman_scap_client/tree/v0.3.18) (2017-10-18)

[Full Changelog](https://github.com/theforeman/puppet-foreman_scap_client/compare/v0.3.16...v0.3.18)

## [v0.3.16](https://github.com/theforeman/puppet-foreman_scap_client/tree/v0.3.16) (2017-06-23)

[Full Changelog](https://github.com/theforeman/puppet-foreman_scap_client/compare/v0.3.15...v0.3.16)

**Implemented enhancements:**

- Fixes [\#19471](https://projects.theforeman.org/issues/19471) - Update SSL path on puppet 4+ [\#37](https://github.com/theforeman/puppet-foreman_scap_client/pull/37) ([ares](https://github.com/ares))

**Closed issues:**

- Cannot get setup to work. [\#38](https://github.com/theforeman/puppet-foreman_scap_client/issues/38)

## [v0.3.15](https://github.com/theforeman/puppet-foreman_scap_client/tree/v0.3.15) (2017-03-23)

[Full Changelog](https://github.com/theforeman/puppet-foreman_scap_client/compare/v0.3.14...v0.3.15)

**Fixed bugs:**

- Restore Puppet 3.8 compatibility [\#35](https://github.com/theforeman/puppet-foreman_scap_client/pull/35) ([ares](https://github.com/ares))

## [v0.3.14](https://github.com/theforeman/puppet-foreman_scap_client/tree/v0.3.14) (2017-02-21)

[Full Changelog](https://github.com/theforeman/puppet-foreman_scap_client/compare/v0.3.12...v0.3.14)

**Implemented enhancements:**

- Fixes [\#18111](https://projects.theforeman.org/issues/18111): Add managemet of foreman-plugins yum repo [\#32](https://github.com/theforeman/puppet-foreman_scap_client/pull/32) ([helge000](https://github.com/helge000))

**Merged pull requests:**

- Update readme about releasing [\#33](https://github.com/theforeman/puppet-foreman_scap_client/pull/33) ([ares](https://github.com/ares))

## [v0.3.12](https://github.com/theforeman/puppet-foreman_scap_client/tree/v0.3.12) (2017-01-06)

[Full Changelog](https://github.com/theforeman/puppet-foreman_scap_client/compare/v0.3.13...v0.3.12)

## [v0.3.13](https://github.com/theforeman/puppet-foreman_scap_client/tree/v0.3.13) (2017-01-06)

[Full Changelog](https://github.com/theforeman/puppet-foreman_scap_client/compare/v0.3.11...v0.3.13)

**Implemented enhancements:**

- Fixes [\#14158](https://projects.theforeman.org/issues/14158) - Add support for tailoring file [\#31](https://github.com/theforeman/puppet-foreman_scap_client/pull/31) ([xprazak2](https://github.com/xprazak2))

## [v0.3.11](https://github.com/theforeman/puppet-foreman_scap_client/tree/v0.3.11) (2016-09-09)

[Full Changelog](https://github.com/theforeman/puppet-foreman_scap_client/compare/v0.3.10...v0.3.11)

## [v0.3.10](https://github.com/theforeman/puppet-foreman_scap_client/tree/v0.3.10) (2016-08-29)

[Full Changelog](https://github.com/theforeman/puppet-foreman_scap_client/compare/v0.3.9...v0.3.10)

**Implemented enhancements:**

- Fixes [\#16149](https://projects.theforeman.org/issues/16149) - Move scap to a cron file [\#26](https://github.com/theforeman/puppet-foreman_scap_client/pull/26) ([shlomizadok](https://github.com/shlomizadok))

## [v0.3.9](https://github.com/theforeman/puppet-foreman_scap_client/tree/v0.3.9) (2016-08-19)

[Full Changelog](https://github.com/theforeman/puppet-foreman_scap_client/compare/v0.3.8...v0.3.9)

**Implemented enhancements:**

- add the possibility to update the gem package [\#18](https://github.com/theforeman/puppet-foreman_scap_client/pull/18) ([cristifalcas](https://github.com/cristifalcas))

**Fixed bugs:**

- Add data.empty? since subscription-manager config exec can result in … [\#21](https://github.com/theforeman/puppet-foreman_scap_client/pull/21) ([csschwe](https://github.com/csschwe))
- fix for invalid cert path when host name is set in upper-case letters [\#19](https://github.com/theforeman/puppet-foreman_scap_client/pull/19) ([allomani](https://github.com/allomani))

**Merged pull requests:**

- Add blacksmith for release automation [\#25](https://github.com/theforeman/puppet-foreman_scap_client/pull/25) ([ares](https://github.com/ares))

## [v0.3.8](https://github.com/theforeman/puppet-foreman_scap_client/tree/v0.3.8) (2016-01-11)

[Full Changelog](https://github.com/theforeman/puppet-foreman_scap_client/compare/v0.3.7...v0.3.8)

- Support vintage ruby interpreters
- The command output shall go to /dev/null
- fix the documentation typo

## [v0.3.7](https://github.com/theforeman/puppet-foreman_scap_client/tree/v0.3.7) (2015-05-07)

[Full Changelog](https://github.com/theforeman/puppet-foreman_scap_client/compare/v0.3.6...v0.3.7)

- Support for content automated content fetching

## [v0.3.6](https://github.com/theforeman/puppet-foreman_scap_client/tree/v0.3.6) (2015-04-09)

[Full Changelog](https://github.com/theforeman/puppet-foreman_scap_client/compare/v0.3.5...v0.3.6)

- Support for subscription manager certificates

## [v0.3.5](https://github.com/theforeman/puppet-foreman_scap_client/tree/v0.3.5) (2015-03-03)

[Full Changelog](https://github.com/theforeman/puppet-foreman_scap_client/compare/v0.3.4...v0.3.5)

- port is now mandatory parameter

## [v0.3.4](https://github.com/theforeman/puppet-foreman_scap_client/tree/v0.3.4) (2015-02-26)

[Full Changelog](https://github.com/theforeman/puppet-foreman_scap_client/compare/v0.3.3...v0.3.4)

- bugfix package rubygem-foreman-scap-client installation

## [v0.3.3](https://github.com/theforeman/puppet-foreman_scap_client/tree/v0.3.3) (2015-02-09)

[Full Changelog](https://github.com/theforeman/puppet-foreman_scap_client/compare/0.3.2...v0.3.3)

- bugfixes foreman_scap_client.cfg template distribution

## [0.3.2](https://github.com/theforeman/puppet-foreman_scap_client/tree/0.3.2) (2015-01-15)

[Full Changelog](https://github.com/theforeman/puppet-foreman_scap_client/compare/0.3.1...0.3.2)

- new class foreman_scap_client introduced in body of puppet-openscap
- the puppet-openscap remains live in github.com/OpenSCAP/puppet-openscap

## [0.3.1](https://github.com/theforeman/puppet-foreman_scap_client/tree/0.3.1) (2014-07-25)

[Full Changelog](https://github.com/theforeman/puppet-foreman_scap_client/compare/0.3.0...0.3.1)

## [0.3.0](https://github.com/theforeman/puppet-foreman_scap_client/tree/0.3.0) (2014-07-25)

[Full Changelog](https://github.com/theforeman/puppet-foreman_scap_client/compare/0.2.0...0.3.0)

- All stored results are bzip2ed (~90% reduction of disc space)
- Module can upload results to Foreman's Smart Proxy
  (Assuming foreman-proxy_openscap plug-in installed).
- Support of Ruby 1.8 (previously 2.0+ was needed)
- Introduced resources:
  - scap_upload
- Introduced classes:
  - openscap::xccdf::foreman_audit

## [0.2.0](https://github.com/theforeman/puppet-foreman_scap_client/tree/0.2.0) (2014-07-16)

[Full Changelog](https://github.com/theforeman/puppet-foreman_scap_client/compare/0.1.0...0.2.0)

- the module attempts to install its dependencies
- introduced classes:
  - openscap
  - openscap::params
  - openscap::package
  - openscap::xccdf::eval

## [0.1.0](https://github.com/theforeman/puppet-foreman_scap_client/tree/0.1.0) (2014-06-05)

[Full Changelog](https://github.com/theforeman/puppet-foreman_scap_client/compare/d523ede483f4c060040108edfdcb91c1b737508f...0.1.0)

- project started
- introduced resources:
  - scap_schedule
  - xccdf_scan


\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/github-changelog-generator/github-changelog-generator)*
