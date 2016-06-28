# Zapix3

Zapix is a tool which makes the communication with the zabbix's api simple.

If you need a more detailed information of how to use zapix see the specs.

This version of zappix is compatible with zabbix 3.0

## Installation

Add this line to your application's Gemfile:

    gem 'zapix3', '0.1.2'

And then execute:

    $ bundle install

Or install it with gem:

    $ gem install zapix3

## Usage

### Remote client
First create a remote client. Feel free to
disable the debug mode if you find it annoying.

These environment variables also need to be set:

    ZABBIX_API_URL
    ZABBIX_API_LOGIN
    ZABBIX_API_PASSWORD

```ruby
require 'zapix'
zrc = ZabbixAPI.connect(
  :service_url => 'https://zabbix-server.foo/api_jsonrpc.php',
  :username => 'guybrush',
  :password => 'threepwood',
  :debug => true
)
```

## Functionality

### Hostgroup Operations
#### Creating a hostgroup
```ruby
zrc.hostgroups.create('test_hostgroup')
```

#### Checking if a hostgroup has any attached hosts
```ruby
zrc.hostgroups.any_hosts?('test_hostgroup')
```

#### Getting all host ids of hosts belonging to a hostgroup
```ruby
zrc.hostgroups.get_host_ids_of('test_hostgroup')
```

#### Deleting a hostgroup
Note that deleting a hostgroups with attached hosts also deletes the hosts.

```ruby
zrc.hostgroups.delete('test_hostgroup')
```

#### Getting the id of a hostgroup
```ruby
zrc.hostgroups.get_id('test_hostgroup')
```

#### Getting all hostgroups names
```ruby
zrc.hostgroups.get_all
```

### Host Operations

#### Getting the id of a host
```ruby
zrc.hosts.get_id('test_host')
```

#### Getting all host names
```ruby
zrc.hosts.get_all
```

#### Creating a host
Note that in zabbix host cannot exists on its own, it always needs a hostgroup.
```ruby 
hostgroup_id = zrc.hostgroups.get_id('test_hostgroup')

zabbix_interface = Interface.new(
  'ip'  => '127.0.0.1',
  'dns' => 'abrakadabra.com'
)

jmx_interface = Interface.new(
  'ip'  => '127.0.0.1',
  'dns' => 'abrakadabra.com',
  'type' => 4, # JMX
  'main' => 1, # default jmx interface
  'port' => 9003
)

template_1 = zrc.templates.get_id('example_template_1')
template_2 = zrc.templates.get_id('example_template_2')

example_host = Host.new
example_host.add_name('test_host')
example_host.add_interfaces(zabbix_interface.to_hash)
example_host.add_interfaces(jmx_interface.to_hash)
example_host.add_macros({'macro' => '{$TESTMACRO}', 'value' => 'test123'})
example_host.add_group_ids(hostgroup_id)
example_host.add_template_ids(template_1, template_2)
zrc.hosts.create(example_host.to_hash)
```

#### Deleting a host
```ruby
zrc.hosts.delete('test_host')
```

### Template Operations

#### Checking if a template exists
```ruby
zrc.templates.exists?('test_template')
```

#### Getting the id of a template
```ruby
zrc.templates.get_id('test_template')
```

#### Getting all templates for a host
```ruby
zrc.templates.get_templates_for_host(zrc.hosts.get_id('test_host'))
```

### Application Operations

#### Getting the id of an application
Note that an application always belogs to a host.
```ruby
zrc.applications.get_id({
  'name'   => 'test_app',
  'hostid' => zrc.hosts.get_id('test_name')
})
```

#### Creating an application for host
```ruby
zrc.applications.create({
  'name'   => 'test_application'
  'hostid' => zrc.hosts.get_id('test_host')
})
```

### Web Scenario Operations
Note that a web scenario needs a host and an application in zabbix 2.0.6. This is
going to change in the next versions of zabbix. When creating scenarios it also
makes sense to create triggers for them.

#### Checking if a scenario exists
```ruby
zrc.scenarios.exists?({
  'name'   => 'test_scenario',
  'hostid' => zrc.hosts.get_id('test_host')
})
```

#### Getting the id of a scenario
```ruby
zrc.scenarios.get_id({
  'name'   => 'test_scenario'
  'hostid' => zrc.hosts.get_id('test_host')
})
```

#### Creating a scenario
```ruby

zrc.applications.create({
  'name'   => 'test_app',
  'hostid' => zrc.hosts.get_id('test_name')
})

webcheck_options = Hash.new
webcheck_options['hostid'] = zrc.hosts.get_id('host')
webcheck_options['name'] = 'my first scenario'
webcheck_options['applicationid'] = zrc.applications.get_id('test_app')
webcheck_options['steps'] = [{'name' => 'Homepage', 'url' => 'm.test.de', 'status_codes' => 200, 'no' => 1}]
zrc.scenarios.create(webcheck_options)
```

#### Deleting a scenario
```ruby
zrc.scenarios.delete({
  'name'   => 'test_scenario',
  'hostid' => zrc.hosts.get_id('test_host')
})
```

### Trigger Operations

#### Checking if a trigger exists
```ruby
zrc.triggers.exists?({
  'expression' => "{test_host:web.test.fail[test_scenario].max(#3)}#0"
})
```

### Getting the id of a trigger
```ruby
zrc.triggers.get_id({
  'expression' => "{test_host:web.test.fail[test_scenario].max(#3)}#0"
})
```

### Creating a trigger
```ruby
options = Hash.new
options['description'] = 'Webpage failed on {HOST.NAME}'
options['expression'] = "{test_host:web.test.fail[test_scenario].max(#3)}#0"
options['priority'] = 2 # 2 means Warning
zrc.triggers.create(options)
```

### Deleting a trigger
```ruby
trigger_id = zrc.triggers.get_id({
  'expression' => "{test_host:web.test.fail[test_scenario].max(#3)}#0"
})

zrc.triggers.delete(trigger_id)
```

### Usergroups Operations

#### Geting the id of a usergroup
```ruby
zrc.usergroups.get_id({
  'name' = 'test_usergroup'
})
```

#### Creating a usergroup
```ruby
options = Hash.new
options['name'] = 'test_usergroup'
options['rights'] = {
  'permission' => 3,
  'id' => zrc.hostgroups.get_id('test_hostgroup')
}
zrc.usergroups.create(options)
```

#### Deleting a user group
```ruby
usergroup_id = zrc.usergroups.get_id({'name' => 'test_usergroup'})
zrc.usergroups.delete(usergroup_id)
```

#### Getting the id of a user
```ruby
zrc.users.get_id({'alias' => 'max'})
```

#### Creating a user
```ruby
group_id = zrc.usergroups.get_id({'name' => 'test_usergroup'})
user_options = Hash.new

user_options['alias']   = 'igor'
user_options['passwd']  = 'geheim'
user_options['usrgrps'] = [{
  'usrgrpid' => group_id
}]

user_options['user_medias'] = [{
  'mediatypeid' => 1,
  'sendto' => 'support@company.com',
  'active' => 0,
  'severity' => 63,
  'period' => '1-7,00:00-24:00'
}]

zrc.users.create(user_options)
```

### Actions Operations

#### Getting the id of an action
```ruby
  zrc.actions.get_id({'name' => 'Report problems to Zabbix administrators'})
```

#### Creating an action
```ruby
  usergroup_options = Hash.new({'name' = 'test_usergroup'})
  action_options = Hash.new
  action_options['name'] = 'Report problems to Zabbix administrators'
  action_options['eventsource'] = 0
  action_options['evaltype'] = 1 # AND
  action_options['status'] = 1 # Disabled
  action_options['esc_period'] = 3600
  action_options['def_shortdata'] = '{TRIGGER.NAME}: {TRIGGER.STATUS}'
  action_options['def_longdata'] = "{TRIGGER.NAME}: {TRIGGER.STATUS}\r\nLast value: {ITEM.LASTVALUE}\r\n\r\n{TRIGGER.URL}"
  action_options['conditions'] = [{
    'conditiontype' => 0, # Hostgroup
    'operator'      => 0, # =
    'value' => zrc.hostgroups.get_id('Templates')
   },
   # not in maintenance
   {
     'conditiontype' => 16, # Maintenance
     'operator'      => 7,  # not in
     'value'         => 'maintenance'
   }]

  action_options['operations'] = [{
    'operationtype' => 0,
    'esc_period'     => 0,
    'esc_step_from'  => 1,
    'esc_step_to'    => 1,
    'evaltype'       => 0,
    'opmessage_grp'  => [{
      'usrgrpid' => zrc.usergroups.get_id(usergroup_options)
    }],
    'opmessage' => {
      'default_msg' => 1,
      'mediatypeid' => 1
    }
  }]
  zrc.actions.create(action_options)
```

### Remote client and tests
In order to run the rspec tests you need a running zabbix test server.

### TODOs
Open source the docker-compose setup of the whole zabbix installation.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Don't forget to write tests
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
