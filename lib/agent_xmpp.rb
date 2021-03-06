$:.unshift(File.dirname(__FILE__))

require 'find'
require 'singleton'
require 'logger'
require 'socket'
require 'optparse'
require 'rexml/document'
require 'base64'
require 'yaml'

require 'eventmachine'
require 'evma_xmlpushparser'

require 'sequel'

require 'agent_xmpp/patches'
require 'agent_xmpp/client'
require 'agent_xmpp/xmpp'
require 'agent_xmpp/config'
require 'agent_xmpp/models'
require 'agent_xmpp/main'
require 'agent_xmpp/admin'
