module Clara
  module Script
    ##
    # Runs scripts
    class Runner
      def initialize(work_tree, script_path)
        @work_tree = work_tree
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

      end

      ##
      # Runs the script
      def run_script
        Dir.chdir @work_tree
        load @script_path
      end
    end
  end
end
