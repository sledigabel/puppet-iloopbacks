# puppet-iloopbacks
a simple loopback management module for puppet

## Concept

TODO

## Dependencies

Requires the ```puppetlabs\stdlib``` module for hash manipulation and validations.

## Usage:
```
class { 'iloopbacks':
    loops => {
        lo1     => '192.168.100.10',
        loTEST  => 'resolv-this.ip.address.com',
    }
}
```
