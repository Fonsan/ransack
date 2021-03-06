module Ransack
  module Adapters
    module ActiveRecord
      module Base

        def self.extended(base)
          alias :search :ransack unless base.method_defined? :search
          base.instance_eval do
            class_attribute :_ransackers
            self._ransackers ||= {}
          end
        end

        def ransack(params = {}, options = {})
          Search.new(self, params, options)
        end

        def ransacker(name, opts = {}, &block)
          Ransacker.new(self, name, opts, &block)
        end

        # TODO: Let's actually do some authorization. Whitelist-only.
        def ransackable_attributes(auth_object)
          column_names + _ransackers.keys
        end

        def ransackable_associations(auth_object)
          reflect_on_all_associations.map {|a| a.name.to_s}
        end

      end
    end
  end
end