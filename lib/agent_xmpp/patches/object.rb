##############################################################################################################
module AgentXmpp  
  module StandardLibrary
    module ObjectPatches
    
      ####----------------------------------------------------------------------------------------------------
      module InstanceMethods

        #.......................................................................................................
        def to_x_data(type = 'result')
          Xmpp::XData.new(type).add_field_with_value(nil, to_s)
        end
  
        #.......................................................................................................
        def define_meta_class_method(name, &blk)
          (class << self; self; end).instance_eval {define_method(name, &blk)}
        end

        #.......................................................................................................
        def stuff_a
          kind_of?(Array) ? self : [self]
        end
  
      #### InstanceMethods
      end  
        
    #### ObjectPatches
    end
  ##### StandardLibrary
  end
#### AgentXmpp
end

##############################################################################################################
Object.send(:include, AgentXmpp::StandardLibrary::ObjectPatches::InstanceMethods)
