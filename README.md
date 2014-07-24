#OpenSCAP Puppet Module

OpenSCAP Puppet Module exposes OpenSCAP primitives to puppet DSL.

## Class: openscap::xccdf::eval

This class ensures that client system is evaluated against given XCCDF guidance.
The class supports reoccuring scans. The results are stored at the client system.

### Parameters:

 * $xccdf_path: Path to XCCDF or DataStream file
 * $xccdf_profile: XCCDF Profile to evaluate
 * $period: How often the evaluation shall happen
 * $weekday: Preferable weekday for evaluation to happen
 * $content_package: Package which includes $xccdf_path
 * $scan_name: The identifier of the reoccuring scan on the disk

Default arguments will evaluate SCAP-Security-Guide policy in a weekly manner.

### Sample Usage

The following example ensures that every week an SCAP audit is executed and the results
are stored under /var/lib/openscap directory. The openscap::xccdf::eval class ensures that
the very last audit result is present. I.e. if puppet is not run on Friday, the audit will
be executed within the next puppet run. The example will automatically attempt to install
ruby-openscap and scap-security-guide on the system.

```
class { openscap::xccdf::eval:
  name => my-weekly-ssg-audit,
  weekday => Friday,
  period => weekly,
}
```

## Class: openscap::xccdf::foreman_audit

This class is very same as openscap::xccdf::eval. The only difference is that
this one attempts to upload audit results to Foreman's smart-proxy.

### Parameters:

foreman_audit takes the same parameters as openscap::xccdf::eval, plus:

 * foreman_proxy: The URI of Foremen's Smart Proxy to receive the audit result

By default (without the foreman_proxy argument) foreman_audit assumes that proxy
is hosted on the same system as the puppetmaster.

