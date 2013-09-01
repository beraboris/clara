require 'clara/script/environment'

module Clara
  module Script
    ##
    # Runs scripts
    class Runner
      def initialize(script_path)
        @script_path = script_path
      end

      ##
      # Run the script
      def run
        setup_env
        run_script
      end

      private

      ##
      # Setup the environment to run the script
      def setup_env
        @env = Clara::Script::Environment.new
      end

      ##
      # Runs the script
      def run_script
        @env.run @script_path
      end
    end
  end
end
