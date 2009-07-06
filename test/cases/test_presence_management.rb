##############################################################################################################
require 'test_helper'

##############################################################################################################
class TestPresenceManagement < Test::Unit::TestCase

  #.........................................................................................................
  def setup
    @config = {'jid' => 'test@nowhere.com', 'roster' =>['dev@nowhere.com', 'troy@nowhere.com'], 'password' => 'nopass'}
    @client = TestClient.new(@config)
    test_init_roster(@client)
    @delegate = @client.new_delegate
    @home = AgentXmpp::Xmpp::JID.new('troy@nowhere.com/home')
    @work = AgentXmpp::Xmpp::JID.new('troy@nowhere.com/work')
    @noone = AgentXmpp::Xmpp::JID.new('noone@nowhere.com/here')
  end
    
  ####------------------------------------------------------------------------------------------------------
  context "on receipt of first presence message from jid in configured roster" do
  
    setup do
      AgentXmpp::Xmpp::IdGenerator.set_gen_id([1,2])
      @client.roster.resources(@home).should be_empty
      @delegate.did_receive_presence_method.should_not be_called
      @client.receiving(PresenceMessages.recv_presence_available(@client, @home.to_s)).should \
        respond_with(VersionDiscoveryMessages.send_iq_get_query_version(@client, @home.to_s), \
                     ServiceDiscoveryMessages.send_iq_get_query_discoinfo(@client, @home.to_s))
      @delegate.did_receive_presence_method.should be_called
      @client.roster.resource(@home).should_not be_nil
    end
  
    #.........................................................................................................
    should "create presence status entry in roster for resource and send client version request to jid" do
    end
      
    #.........................................................................................................
    should "update roster item resource presence status to unavailble on receiving unavailable presence" do
      @delegate = @client.new_delegate
      @delegate.did_receive_presence_unavailable_method.should_not be_called
      @client.roster.resource(@home).type.should be_nil # nil presence type=available
      @client.receiving(PresenceMessages.recv_presence_unavailable(@client, @home.to_s)).should not_respond
      @delegate.did_receive_presence_unavailable_method.should be_called
      @client.roster.resource(@home).type.should be(:unavailable)   
    end
     
    #.........................................................................................................
    should "update existing roster item resource presence status from unavailble to availble on receiving available presence" do
      @delegate = @client.new_delegate
      @client.receiving(PresenceMessages.recv_presence_unavailable(@client, @home.to_s)).should not_respond
      AgentXmpp::Xmpp::IdGenerator.set_gen_id([1,2])
      @client.roster.resource(@home).type.should be(:unavailable)   
      @delegate.did_receive_presence_method.should_not be_called
      @client.receiving(PresenceMessages.recv_presence_available(@client, @home.to_s)).should \
        respond_with(VersionDiscoveryMessages.send_iq_get_query_version(@client, @home.to_s), \
                     ServiceDiscoveryMessages.send_iq_get_query_discoinfo(@client, @home.to_s))
      @delegate.did_receive_presence_method.should be_called
      @client.roster.resource(@home).type.should be_nil # nil presence type=available
    end
          
    #.........................................................................................................
    should "maintain multiple presence status entries for multiple resources for a roster item" do
      @delegate = @client.new_delegate
      AgentXmpp::Xmpp::IdGenerator.set_gen_id([1,2])
      @delegate.did_receive_presence_method.should_not be_called
      @client.roster.resource(@work).should be_nil
      @client.receiving(PresenceMessages.recv_presence_available(@client, @work.to_s)).should \
        respond_with(VersionDiscoveryMessages.send_iq_get_query_version(@client, @work.to_s), \
                     ServiceDiscoveryMessages.send_iq_get_query_discoinfo(@client, @work.to_s))
      @delegate.did_receive_presence_method.should be_called
      @client.roster.resource(@work).should_not be_nil  
      @client.roster.resource(@home).should_not be_nil  
    end
      
  end
     
  #.........................................................................................................
  should "create presence status for resource on receipt of self presence" do
    @client.roster.resources(@client.client.jid).should be_empty
    @delegate.did_receive_presence_method.should_not be_called
    @client.receiving(PresenceMessages.recv_presence_self(@client)).should not_respond
    @delegate.did_receive_presence_method.should be_called
    @client.roster.resource(@client.client.jid).should_not be_nil
  end
       
  #.........................................................................................................
  should "ignore presence messages from jids not in configured roster" do
    @client.roster.has_jid?(@noone).should be(false)
    @delegate.did_receive_presence_method.should_not be_called
    @client.receiving(PresenceMessages.recv_presence_available(@client, @noone.to_s)).should not_respond
    @delegate.did_receive_presence_method.should be_called
    @client.roster.has_jid?(@noone).should be(false)
  end
    
  #.........................................................................................................
  should "accept subscription requests from jids which are in the configured roster" do
    @client.roster.has_jid?(@home).should be(true)
    @delegate.did_receive_presence_subscribe_method.should_not be_called
    @delegate.did_receive_presence_subscribed_method.should_not be_called
    @client.receiving(PresenceMessages.recv_presence_subscribe(@client, @home.bare.to_s)).should \
      respond_with(PresenceMessages.send_presence_subscribed(@client, @home.bare.to_s))
    @client.receiving(PresenceMessages.recv_presence_subscribed(@client, @home.bare.to_s)).should not_respond
    @delegate.did_receive_presence_subscribe_method.should be_called
    @delegate.did_receive_presence_subscribed_method.should be_called
    @client.roster.has_jid?(@home).should be(true)
  end
  
  #.........................................................................................................
  should "remove roster item with jid from configured roster when an unsubscribe resquest is recieved" do
    @client.roster.has_jid?(@home).should be(true)
    @delegate.did_receive_presence_unsubscribed_method.should_not be_called
    @client.receiving(PresenceMessages.recv_presence_unsubscribed(@client, @home.bare.to_s)).should \
      respond_with(RosterMessages.send_iq_set_query_roster_remove(@client, @home.bare.to_s))
    @client.receiving(RosterMessages.recv_iq_result_query_roster_ack(@client)).should not_respond
    @delegate.did_receive_presence_unsubscribed_method.should be_called
    @client.roster.has_jid?(@home).should be(false)
  end
    
  #.........................................................................................................
  should "do nothing when an unsubscribe resquest is recieved from a jid not in the configured roster" do
    @client.roster.has_jid?(@noone).should be(false)
    @delegate.did_receive_presence_unsubscribed_method.should_not be_called
    @client.receiving(PresenceMessages.recv_presence_unsubscribed(@client, @noone.bare.to_s)).should not_respond
    @delegate.did_receive_presence_unsubscribed_method.should be_called
    @client.roster.has_jid?(@noone).should be(false)
  end
    
  #.........................................................................................................
  should "decline subscription requests from jids which are not in the configured roster" do
    @client.roster.has_jid?(@noone).should be(false)
    @delegate.did_receive_presence_subscribe_method.should_not be_called
    @client.receiving(PresenceMessages.recv_presence_subscribe(@client, @noone.bare.to_s)).should \
      respond_with(PresenceMessages.send_presence_unsubscribed(@client, @noone.bare.to_s))
    @delegate.did_receive_presence_subscribe_method.should be_called
    @client.roster.has_jid?(@noone).should be(false)
  end
  
end

