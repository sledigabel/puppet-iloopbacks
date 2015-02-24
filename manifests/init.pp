# == Class: iloopbacks
#
# A Puppet module, that creates, manages and deletes loopbacks by name
# Currently VERY limited - assumes Redhat/CentOS setup. Pull requests accepted!
#
# === Requirement/Dependencies:
#
# Requires stdlib for hash manipulation and checks
#
# === Parameters
#
# [*loops*]
#   Hash containing loopback names (keys) and ip addresses or fqdn (values)
#
# === Examples
#
#  class { 'iloopbacks':
#    loops => {
#      'lo1'    => '192.168.10.5',
#      'loTEST' => 'vip.domain.net',
#    }
#  }
#

class iloopbacks ( $loops ){
    require stdlib
    $list_loop = keys($loops)
    $list_loop_1 = $list_loop[0]
    iloopbacks::loopback { $list_loop:
        loops_p => $loops
    }
}
