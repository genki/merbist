module Merb
  module Fixtures
    class Hash
      def code_to_create_record(model, hash)
        resource = model.new(hash)
        resource.send :hookable__create_nan_before_advised
        resource
      end

      def code_to_create_child_record(parent_record, relation_name, hash)
        resource = parent_record.send(relation_name).new(hash) 
        resource.send :hookable__create_nan_before_advised
        resource
      end
    end
  end
end
