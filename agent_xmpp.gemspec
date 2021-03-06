# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{agent_xmpp}
  s.version = "0.1.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Troy Stribling}]
  s.date = %q{2011-06-16}
  s.email = %q{troy.stribling@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE",
    "README.rdoc"
  ]
  s.files = [
    ".document",
    ".rvmrc",
    "LICENSE",
    "README.rdoc",
    "Rakefile",
    "VERSION",
    "agent_xmpp.gemspec",
    "default.gems",
    "lib/agent_xmpp.rb",
    "lib/agent_xmpp/admin.rb",
    "lib/agent_xmpp/client.rb",
    "lib/agent_xmpp/client/boot.rb",
    "lib/agent_xmpp/client/client.rb",
    "lib/agent_xmpp/client/connection.rb",
    "lib/agent_xmpp/client/controller.rb",
    "lib/agent_xmpp/client/message_delegate.rb",
    "lib/agent_xmpp/client/message_pipe.rb",
    "lib/agent_xmpp/client/response.rb",
    "lib/agent_xmpp/config.rb",
    "lib/agent_xmpp/main.rb",
    "lib/agent_xmpp/models.rb",
    "lib/agent_xmpp/models/contact.rb",
    "lib/agent_xmpp/models/message.rb",
    "lib/agent_xmpp/models/publication.rb",
    "lib/agent_xmpp/models/roster.rb",
    "lib/agent_xmpp/models/service.rb",
    "lib/agent_xmpp/models/subscription.rb",
    "lib/agent_xmpp/models/table_definitions.rb",
    "lib/agent_xmpp/patches.rb",
    "lib/agent_xmpp/patches/array.rb",
    "lib/agent_xmpp/patches/float.rb",
    "lib/agent_xmpp/patches/hash.rb",
    "lib/agent_xmpp/patches/object.rb",
    "lib/agent_xmpp/patches/rexml.rb",
    "lib/agent_xmpp/patches/string.rb",
    "lib/agent_xmpp/xmpp.rb",
    "lib/agent_xmpp/xmpp/element.rb",
    "lib/agent_xmpp/xmpp/entry.rb",
    "lib/agent_xmpp/xmpp/error_response.rb",
    "lib/agent_xmpp/xmpp/iq.rb",
    "lib/agent_xmpp/xmpp/iq_command.rb",
    "lib/agent_xmpp/xmpp/iq_disco.rb",
    "lib/agent_xmpp/xmpp/iq_pubsub.rb",
    "lib/agent_xmpp/xmpp/iq_roster.rb",
    "lib/agent_xmpp/xmpp/iq_version.rb",
    "lib/agent_xmpp/xmpp/jid.rb",
    "lib/agent_xmpp/xmpp/message.rb",
    "lib/agent_xmpp/xmpp/presence.rb",
    "lib/agent_xmpp/xmpp/sasl.rb",
    "lib/agent_xmpp/xmpp/stanza.rb",
    "lib/agent_xmpp/xmpp/x_data.rb",
    "test/app/app.rb",
    "test/cases/test_application_message_processing.rb",
    "test/cases/test_errors.rb",
    "test/cases/test_presence_management.rb",
    "test/cases/test_roster_management.rb",
    "test/cases/test_service_discovery.rb",
    "test/cases/test_session_management.rb",
    "test/cases/test_version_discovery.rb",
    "test/helpers/matchers.rb",
    "test/helpers/mocks.rb",
    "test/helpers/test_case_extensions.rb",
    "test/helpers/test_client.rb",
    "test/helpers/test_delegate.rb",
    "test/helpers/test_helper.rb",
    "test/messages/application_messages.rb",
    "test/messages/error_messages.rb",
    "test/messages/presence_messages.rb",
    "test/messages/roster_messages.rb",
    "test/messages/service_discovery_messages.rb",
    "test/messages/session_messages.rb",
    "test/messages/version_discovery_messages.rb",
    "test/peer/peer.rb"
  ]
  s.homepage = %q{http://imaginaryproducts.com/projects/agent-xmpp}
  s.require_paths = [%q{lib}]
  s.rubygems_version = %q{1.8.5}
  s.summary = %q{Agent XMPP is a ruby XMPP bot framework inspired by web frameworks.}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<eventmachine>, [">= 0.12.6"])
      s.add_runtime_dependency(%q<sequel>, [">= 3.9.0"])
      s.add_runtime_dependency(%q<evma_xmlpushparser>, [">= 0.0.1"])
      s.add_runtime_dependency(%q<sqlite3>, [">= 1.3.3"])
    else
      s.add_dependency(%q<eventmachine>, [">= 0.12.6"])
      s.add_dependency(%q<sequel>, [">= 3.9.0"])
      s.add_dependency(%q<evma_xmlpushparser>, [">= 0.0.1"])
      s.add_dependency(%q<sqlite3>, [">= 1.3.3"])
    end
  else
    s.add_dependency(%q<eventmachine>, [">= 0.12.6"])
    s.add_dependency(%q<sequel>, [">= 3.9.0"])
    s.add_dependency(%q<evma_xmlpushparser>, [">= 0.0.1"])
    s.add_dependency(%q<sqlite3>, [">= 1.3.3"])
  end
end

