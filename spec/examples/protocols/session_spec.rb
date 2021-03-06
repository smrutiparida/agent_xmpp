##########################################################################################################################################################################
require 'spec_helper'

##########################################################################################################################################################################
describe 'session protocol' do
##########################################################################################################################################################################

  #.......................................................................................................................................................................
  include SpecInclude
  
  ####**********************************************************************************************************************************************************************
  context 'when TCP connection to server is established' do

    ####--------------------------------------------------------------------------------------------------------------------------------------------------------------------
    it 'should send XML version message and stream initialization message' do
      messages = [SessionMessages.send_supported_xml_version(agent_jid), SessionMessages.send_stream(agent_jid)]
      client_should_send_data(messages.first)
      client_should_send_data(messages.last)
      client.connection_completed.should == messages
    end
  
  end

  ####**********************************************************************************************************************************************************************
  context 'when connection status is not authenticated' do
    
    ####--------------------------------------------------------------------------------------------------------------------------------------------------------------------
    it 'should equal :not_authenticated' do
      client.connection_status.should == :not_authenticated
    end

    ####**********************************************************************************************************************************************************************
    context 'and before preauthenticate stream features are received' do
  
      ####--------------------------------------------------------------------------------------------------------------------------------------------------------------------
      it 'should not call on_authenticate' do
        test_delegate.on_authenticate_method.should_not be_called
      end
  
      ####--------------------------------------------------------------------------------------------------------------------------------------------------------------------
      it 'should not call on_preauthenticate_features' do
        test_delegate.on_preauthenticate_features_method.should_not be_called
      end
  
      ####--------------------------------------------------------------------------------------------------------------------------------------------------------------------
      it 'should not not call on_bind' do
        test_delegate.on_bind_method.should_not be_called
      end

      ####--------------------------------------------------------------------------------------------------------------------------------------------------------------------
      it 'should not call on_start_session' do
        test_delegate.on_start_session_method.should_not be_called
      end
  
    end
  
    ####**********************************************************************************************************************************************************************
    context 'and when preauthenticate stream features are received' do
  
      ####**********************************************************************************************************************************************************************
      context 'with PLAIN authentication' do
  
        #.......................................................................................................................................................................
        before(:each) do
          client_should_send_data(SessionMessages.send_auth_plain(agent_jid))
        end  
        
        ####--------------------------------------------------------------------------------------------------------------------------------------------------------------------
        it 'should call on_preauthenticate_features'  do
          client_receiving(SessionMessages.recv_preauthentication_stream_features_with_plain_SASL(agent_jid))
          test_delegate.on_preauthenticate_features_method.should be_called
        end

        ####--------------------------------------------------------------------------------------------------------------------------------------------------------------------
        it 'should send a PLAIN authentication message' do
          client_receiving(SessionMessages.recv_preauthentication_stream_features_with_plain_SASL(agent_jid)).should respond_with(SessionMessages.send_auth_plain(agent_jid))
        end
  
      end
  
      ####**********************************************************************************************************************************************************************
      context 'without PLAIN authentication' do
  
        ####--------------------------------------------------------------------------------------------------------------------------------------------------------------------
        it 'should raise an exception' do
          expect{client_receiving(SessionMessages.recv_preauthentication_stream_features_without_plain_SASL(agent_jid))}.to raise_error(AgentXmpp::AgentXmppError)
        end
  
      end
  
    end
  
    ####**********************************************************************************************************************************************************************
    context 'and when the PLAIN authentication success message is received' do
  
      #.......................................................................................................................................................................
      before(:each) do
        client_should_send_data(SessionMessages.send_stream(agent_jid))
      end  
        
      ####--------------------------------------------------------------------------------------------------------------------------------------------------------------------
      it 'should send stream initialization message' do
        client_receiving(SessionMessages.recv_auth_success(agent_jid)).should respond_with(SessionMessages.send_stream(agent_jid))
      end

      ####--------------------------------------------------------------------------------------------------------------------------------------------------------------------
      it 'should call on_authenticate'  do
        client_receiving(SessionMessages.recv_auth_success(agent_jid))
        test_delegate.on_authenticate_method.should be_called
      end
      
      ####--------------------------------------------------------------------------------------------------------------------------------------------------------------------
      it 'should set connection status to :authenticated' do
        client_receiving(SessionMessages.recv_auth_success(agent_jid))
        client.connection_status.should == :authenticated       
      end
                 
    end
  
    ####**********************************************************************************************************************************************************************
    context 'and when the PLAIN authentication failure message is received' do
  
      ####--------------------------------------------------------------------------------------------------------------------------------------------------------------------
      it 'should raise an exception' do
        expect{client_receiving(SessionMessages.recv_auth_failure(agent_jid))}.to raise_error(AgentXmpp::AgentXmppError)
      end
      
    end
     
  end
  
  ####************************************************************************************************************************************************************************
  context 'when connection status is authenticated' do
    
    #.......................................................................................................................................................................
    before(:each) do
      client_should_send_data(SessionMessages.send_stream(agent_jid))
      client_receiving(SessionMessages.recv_auth_success(agent_jid))      
    end
  
    ####**********************************************************************************************************************************************************************
    context 'and before postauthenticate stream features are received' do
      
      ####--------------------------------------------------------------------------------------------------------------------------------------------------------------------
      it 'should not call on_postauthenticate_features' do
        test_delegate.on_postauthenticate_features_method.should_not be_called
      end

      ####--------------------------------------------------------------------------------------------------------------------------------------------------------------------
      it 'should not call on_bind' do
        test_delegate.on_bind_method.should_not be_called
      end

      ####--------------------------------------------------------------------------------------------------------------------------------------------------------------------
      it 'should not call on_start_session' do
        test_delegate.on_start_session_method.should_not be_called
      end
      
    end

    ####**********************************************************************************************************************************************************************
    context 'and when postauthenticate stream features are received' do

      #.......................................................................................................................................................................
      before(:each) do
        client_should_send_data(SessionMessages.send_iq_set_bind(agent_jid))
      end
      
      ####--------------------------------------------------------------------------------------------------------------------------------------------------------------------
      it 'should send bind resource message' do
        client_receiving(SessionMessages.recv_postauthentication_stream_features(agent_jid)).should respond_with(SessionMessages.send_iq_set_bind(agent_jid))
      end
      
      ####--------------------------------------------------------------------------------------------------------------------------------------------------------------------
      it 'should call on_postauthenticate_features' do
        client_receiving(SessionMessages.recv_postauthentication_stream_features(agent_jid))
        test_delegate.on_postauthenticate_features_method.should be_called
      end
      
    end
  
    ####**********************************************************************************************************************************************************************
    context 'and when bind resource success message is received' do

      #.......................................................................................................................................................................
      before(:each) do
        client_should_send_data(SessionMessages.send_iq_set_session(agent_jid))
        client_should_send_data(SessionMessages.send_iq_set_bind(agent_jid))
        client_receiving(SessionMessages.recv_postauthentication_stream_features(agent_jid))        
      end
      
      ####--------------------------------------------------------------------------------------------------------------------------------------------------------------------
      it 'should send start session message' do
        client_receiving(SessionMessages.recv_iq_result_bind(agent_jid)).should respond_with(SessionMessages.send_iq_set_session(agent_jid))
      end
      
      ####--------------------------------------------------------------------------------------------------------------------------------------------------------------------
      it 'should call on_bind' do
        client_receiving(SessionMessages.recv_iq_result_bind(agent_jid))
        test_delegate.on_bind_method.should be_called
      end
      
    end

    ####**********************************************************************************************************************************************************************
    context 'and when bind resource failure message is received' do

      #.......................................................................................................................................................................
      before(:each) do
        client_should_send_data(SessionMessages.send_iq_set_bind(agent_jid))
        client_receiving(SessionMessages.recv_postauthentication_stream_features(agent_jid))        
      end
      
      ####--------------------------------------------------------------------------------------------------------------------------------------------------------------------
      it 'should raise an exception' do
        expect{client_receiving(SessionMessages.recv_error_bind(agent_jid))}.to raise_error{AgentXmpp::AgentXmppError}
      end
      
    end

    ####**********************************************************************************************************************************************************************
    context 'and when start session success message is received' do
      
      #.......................................................................................................................................................................
      before(:each) do
        client_should_send_data(SessionMessages.send_iq_set_bind(agent_jid))
        client_should_send_data(SessionMessages.send_iq_set_session(agent_jid))
        client_should_send_data(PresenceMessages.send_sign_on_presence(agent_jid))
        client_should_send_data(RosterMessages.send_iq_get_query_roster(agent_jid))
        client_should_send_data(ServiceDiscoveryMessages.send_iq_get_query_discoinfo(agent_jid))
        client_receiving(SessionMessages.recv_postauthentication_stream_features(agent_jid)) 
        client_receiving(SessionMessages.recv_iq_result_bind(agent_jid))       
      end
      
      ####--------------------------------------------------------------------------------------------------------------------------------------------------------------------
      it 'should send sign on presense message' do
        client_receiving(SessionMessages.recv_iq_result_session(agent_jid)).should respond_with(PresenceMessages.send_sign_on_presence(agent_jid))
      end

      ####--------------------------------------------------------------------------------------------------------------------------------------------------------------------
      it 'should send disco#info' do
        client_receiving(SessionMessages.recv_iq_result_session(agent_jid)).should respond_with(ServiceDiscoveryMessages.send_iq_get_query_discoinfo(agent_jid))
      end

      ####--------------------------------------------------------------------------------------------------------------------------------------------------------------------
      it 'should send roster request message' do
        client_receiving(SessionMessages.recv_iq_result_session(agent_jid)).should respond_with(RosterMessages.send_iq_get_query_roster(agent_jid))
      end
      
      ####--------------------------------------------------------------------------------------------------------------------------------------------------------------------
      it 'should call on_start_session' do
        client_receiving(SessionMessages.recv_iq_result_session(agent_jid))
        test_delegate.on_start_session_method.should be_called
      end
      
    end

    ####**********************************************************************************************************************************************************************
    context 'and when start session failure message is received' do
      
      #.......................................................................................................................................................................
      before(:each) do
        client_should_send_data(SessionMessages.send_iq_set_bind(agent_jid))
        client_should_send_data(SessionMessages.send_iq_set_session(agent_jid))
        client_receiving(SessionMessages.recv_postauthentication_stream_features(agent_jid)) 
        client_receiving(SessionMessages.recv_iq_result_bind(agent_jid))       
      end
      
      ####--------------------------------------------------------------------------------------------------------------------------------------------------------------------
      it 'should raise an exception' do
        expect{client_receiving(SessionMessages.recv_error_session(agent_jid))}.to raise_error(AgentXmpp::AgentXmppError)
      end
      
    end
    
  end
  
end
