require 'rake'

module Clara
  # An environment used to run rake tasks
  class RakeEnv < Rake::Application
    def initialize(work_dir)
      super()
      @name = 'clara'
      @original_dir = work_dir
    end

    # Make our app the singleton application while we load tasks
    def load_imports
      old_app = Rake.application
      Rake.application = self
      super
      Rake.application = old_app
    end
  end
end
