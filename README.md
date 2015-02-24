# puppet-iloopbacks
a simple loopback management module for puppet

## Concept

TODO

## Usage:
```
class { 'iloopbacks':
    loops => {
        lo1     => '192.168.100.10',
        loTEST  => 'resolv-this.ip.address.com',
    }
}
```
