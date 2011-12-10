module Fudge
  module FudgeFile
    module Tasks
      class Rspec
        DEFAULT_OPTIONS = { :path => 'spec/' }

        def self.name
          :rspec
        end

        def initialize(options={})
          @options = DEFAULT_OPTIONS.merge(options)
        end

        def run
          output = `rspec #{path}`
          return false unless $?.success?

          if coverage
            return false unless Fudge::FudgeFile::Utils::CoverageChecker.new.check(output, '\) covered', coverage)
          end

          true
        end

        private
        def coverage
          @options[:coverage]
        end

        def path
          @options[:path]
        end
      end

      TaskRegistry.register(Tasks::Rspec)
    end
  end
end
