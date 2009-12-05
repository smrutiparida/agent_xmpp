##############################################################################################################
module AgentXmpp

  #####-------------------------------------------------------------------------------------------------------
  module Xmpp

    #####-------------------------------------------------------------------------------------------------------
    class Entry < Element

      #.....................................................................................................
      name_xmlns 'entry', 'http://www.w3.org/2005/Atom'

      #.......................................................................................................
      def initialize(t = nil)
        super()
        add_element(REXML::Element.new("title").add_text(t)) if t
      end

      #.......................................................................................................
      def title
        first_element_text('title')
      end

      #.......................................................................................................
      def title=(t)
        replace_element_text('title', t)
      end

    #### Entry
    end

  #### XMPP
  end

#### AgentXmpp
end