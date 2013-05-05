module Clara
  module Utils
    module Abstract
      def abstract_methods(*names)
        names.each{ |name| abstract_method name }
      end

      def abstract_method(name)
        define_method name do |*_|
          raise NotImplementedError.new "Abstract method #{name} must be implemented"
        end
      end

      def abstract_class_methods(*names)
        names.each{ |name| abstract_class_method name }
      end

      def abstract_class_method(name)
        define_singleton_method(name) do |*_|
          raise NotImplementedError.new "Abstract class method #{name} must be implemented"
        end
      end
    end
  end
end
