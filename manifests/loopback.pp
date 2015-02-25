# == defined function: iloopbacks::loopback
#
# A function that creates loopbacks as needed
# assumes Redhat/CentOS setup. Pull requests accepted!
#
# === Requirement/Dependencies:
#
# requires puppetlabs/stdlib for hashes + testing around IP
# addresses and domain names
#
# === Parameters
#
# [*loops_p*]
#   hash that includes a loopback name and a corresponding
#   IP address or domain name
#
# === Examples
#
# iloopbacks::loopback('lo1':
#   loops_p => {
#     lo1       => "172.16.10.5",
#     loTEST    => "192.168.10.1",
#     loWEB     => "myweb.domain.com",
#   }
# )}
#

define iloopbacks::loopback ($loops_p){

    # checking if the interface name is lo*
    if $name =~ /^lo[0-9a-zA-Z]+/ {
        # adding a column after 'lo'
        $interface = regsubst($name,'^lo([0-9a-zA-Z]+)$','lo:\1','G')
    }
    else{
        fail("The interface ${interface} does not start with lo")
    }
    # checking if the IP address is present 
    if has_key($loops_p,$name) and $loops_p[$name] != '' {
        $destination = $loops_p[$name]
        # checking if it's an IP address is formed properly
        if is_ip_address($destination) {
            $ipaddress = $destination
            $domain_name = ''
            notify { "loopback ${interface} for ip ${ipaddress}": }

        }
        elsif is_domain_name($destination) {
            # Not an IP address... fqdn?
            # TODO : add some validation steps there.

            $domain_name = $destination
            $ipaddress = ''
            #fail("The IP address $ipaddress for $interface is not correct")
        }
        else {
            fail("${destination} is not an IP address or a domain")
        }

        file { "ifcfg-${interface}":
            ensure  => present,
            mode    => '0644',
            owner   => root,
            group   => root,
            path    => "/etc/sysconfig/network-scripts/ifcfg-${interface}",
            content => template("${module_name}/ifcfg-lo.erb"),
        }

        exec {"ifup-${interface}":
            command     => "/sbin/ifdown ${interface}; /sbin/ifup ${interface}",
            subscribe   => File["ifcfg-${interface}"],
            refreshonly => true
        }

    }
    else{
        # no IP address provided. That means we want to delete
        # an existing IP address, or making sure it doesn't exist.
        # detaching existing loopback
        exec {"ifdown-${interface}":
            command     => "/sbin/ifdown ${interface}; echo",
        }
        # removing the interface file
        file { "ifcfg-${interface}":
            ensure =>  absent,
            path   =>  "/etc/sysconfig/network-scripts/ifcfg-${interface}",
        }
        Exec["ifdown-${interface}"] -> File["ifcfg-${interface}"]
    }

}
