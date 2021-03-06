#####-------------------------------------------------------------------------------------------------------
class TestUtils

  #####-----------------------------------------------------------------------------------------------------
  class << self
    
    #.........................................................................................................
    def bind_resource(client)
      AgentXmpp::Xmpp::IdGenerator.set_gen_id
      client.receiving(SessionMessages.recv_preauthentication_stream_features_with_plain_SASL(client)) 
      client.receiving(SessionMessages.recv_auth_success(client)) 
      client.receiving(SessionMessages.recv_postauthentication_stream_features(client)) 
      client.receiving(SessionMessages.recv_iq_result_bind(client))
    
    end

    #.........................................................................................................
    def test_send_roster_request(client)
    
      #### client configured with two contacts in roster
      delegate = client.new_delegate
      bind_resource(client)
    
      #### session starts and roster is requested
      delegate.on_start_session_method.should_not be_called
      AgentXmpp::Xmpp::IdGenerator.set_gen_id([1,2])
      client.receiving(SessionMessages.recv_iq_result_session(client)).should \
        respond_with(SessionMessages.send_presence_init(client), RosterMessages.send_iq_get_query_roster(client), \
                     ServiceDiscoveryMessages.send_iq_get_query_discoinfo(client, client.jid.domain)) 
      delegate.on_start_session_method.should be_called
      AgentXmpp::Xmpp::IdGenerator.set_gen_id
    
    end
  
    #.........................................................................................................
    def test_init_roster(client)
    
      #### client configured with two contacts in roster
      test_send_roster_request(client)
      delegate = client.new_delegate
        
      #### receive roster request and verify that roster items are activated
      delegate.on_all_roster_items_method.should_not be_called     
      AgentXmpp::Roster.find_all{|r| r[:status].should be(:inactive)}  
      client.receiving(RosterMessages.recv_iq_result_query_roster(client, AgentXmpp.config['roster'])).should not_respond
      AgentXmpp::Roster.find_all{|r| r[:status].should be(:both)}  
      delegate.on_all_roster_items_method.should be_called     
    
    end
    
    #.........................................................................................................
    def test_receive_roster_item(client)
      delegate = client.new_delegate
      delegate.on_roster_item_method.should_not be_called
      delegate.on_all_roster_items_method.should_not be_called
      yield client
      delegate.on_roster_item_method.should be_called
      delegate.on_all_roster_items_method.should be_called     
    end
    
  #### self  
  end
  
#### TestUtils  
end
