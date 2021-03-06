##############################################################################################################
module AgentXmpp
  
  #####-------------------------------------------------------------------------------------------------------
  class Contact

    #####-------------------------------------------------------------------------------------------------------
    class << self

      #.........................................................................................................
      def contacts
        @contacts ||= AgentXmpp.agent_xmpp_db[:contacts]
      end

      #.........................................................................................................
      def drop
        AgentXmpp.agent_xmpp_db(:contacts)
      end
      
      #.........................................................................................................
      def load_config
        if AgentXmpp.config['roster'].kind_of?(Array)
          AgentXmpp.config['roster'].each {|c| update(c)}
        end
      end

      #.........................................................................................................
      def update(contact)
        groups = contact['groups'].kind_of?(Array) ? contact['groups'].join(",") : contact['groups']
        begin
          contacts << {:jid => contact['jid'], :groups => groups, :subscription => 'new', :ask => 'new'}
        rescue 
          contacts.filter(:jid => contact['jid']).update(:groups => groups)
        end
      end

      #.........................................................................................................
      def update_with_roster_item(roster_item)
        from_jid, subscription, ask = roster_item.jid.to_s, roster_item.subscription.to_s, roster_item.ask.to_s
        contacts.filter(:jid => from_jid).update(:subscription => subscription, :ask => ask)
      end

      #.........................................................................................................
      def find_all
        contacts.all
      end

      #.........................................................................................................
      def find_by_jid(jid)
        contacts[:jid => AgentXmpp.bare_jid_to_s(jid)]
      end

      #.........................................................................................................
      def find_all_by_subscription(subscription)
        contacts.filter(:subscription => subscription.to_s).all
      end

      #.........................................................................................................
      def has_jid?(jid)
        contacts.filter(:jid => AgentXmpp.bare_jid_to_s(jid)).count > 0
      end

      #.........................................................................................................
      def message_stats
        find_all.map do |c|
          stats = AgentXmpp.agent_xmpp_db["SELECT count(id) AS count, max(created_at) AS last FROM messages WHERE from_jid LIKE '#{c[:jid]}%'"].first
          {:jid=>c[:jid], :count=>stats[:count], :last=>stats[:last].nil? ? 'Never' : Time.parse(stats[:last]).strftime("%y/%m/%d %H:%M")}
        end        
      end
      
      #.........................................................................................................
      def destroy_by_jid(jid)
        contact = contacts.filter(:jid => AgentXmpp.bare_jid_to_s(jid))
        Roster.destroy_by_contact_id(contact.first[:id])
        contact.delete
      end 

      #.........................................................................................................
      def method_missing(meth, *args, &blk)
        contacts.send(meth, *args, &blk)
      end
      
    #### self
    end

  #### Contact
  end

#### AgentXmpp
end
