##########################################################################################################
require 'rubygems'
require "#{File.dirname(__FILE__)}/../../lib/agent_xmpp"

##########################################################################################################
before_start do
  AgentXmpp.logger.level = Logger::DEBUG
  AgentXmpp.logger.info "before_start"
end

#.........................................................................................................
discovered_command_nodes do |jid, nodes|
  AgentXmpp.logger.info "discovered_command_nodes"
  nodes.each do |n|
    AgentXmpp.logger.info "COMMAND NODE: #{jid}, #{n}"
  end
end

##########################################################################################################
chat do
  AgentXmpp.logger.info "CHAT MESSAGE: #{params[:from]}, #{params[:body]}"
  'leave me alone'  
end

##########################################################################################################
execute 'hello' do
  AgentXmpp.logger.info "EXECUTE: hello"
  'hello'
end
  
##########################################################################################################
event 'dev@plan-b.ath.cx', 'shot' do
  AgentXmpp.logger.info "EVENT: dev@plan-b.ath.cx/shot"
  params[:resources].map do |r| 
    AgentXmpp.logger.info "COMMAND REQUEST: #{r}, hash_hola"
    command(:to=>r, :node=> 'hash_hello') do |status, data|
      AgentXmpp.logger.info "COMMAND RESPONSE: #{status}, #{data.inspect}"
    end
  end
end