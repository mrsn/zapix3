require 'zapix/version'
require_relative 'zapix/zabbix_rpc_client'

class ZabbixAPI
  attr_reader :client

  def self.connect(options = {})
    new(options)
  end

  def initialize(options = {})
    @client = ZabbixRPCClient.new(options)
    Dir["#{File.dirname(__FILE__)}/zapix/zabbix_classes/*.rb"].each { |f| load(f) }
    Dir["#{File.dirname(__FILE__)}/zapix/proxies/*.rb"].each { |f| load(f) }
  end

  def hostgroups
    @hostgroups ||= HostGroups.new(client)
  end

  def hosts
    @hosts ||= Hosts.new(client)
  end

  def templates
    @templates ||= Templates.new(client)
  end

  def applications
    @applications ||= Applications.new(client)
  end

  def scenarios
    @scenarios ||= Scenarios.new(client)
  end

  def triggers
    @triggers ||= Triggers.new(client)
  end

  def hostinterfaces
    @hostinterfaces ||= Hostinterfaces.new(client)
  end

  def actions
    @actions ||= Actions.new(client)
  end

  def usergroups
    @usergroups ||= Usergroups.new(client)
  end

  def users
    @users ||= Users.new(client)
  end

end
