# frozen_string_literal: true

# Rake tasks for the Bookshelf application.
#
# Loaded by Rakefile via `Rake.add_rakelib "lib/tasks"`. Run with:
#
#   bundle exec rake docs        # build HTML API docs into tmp/docs
#   bundle exec rake docs:clean  # remove generated docs
#   bundle exec rake docs:rebuild
namespace :docs do
     # Generate HTML API documentation into tmp/docs using .yardopts.
  desc "Generate HTML API documentation with YARD"
  task :generate do
    sh("bundle exec yard --output-dir tmp/docs")
  end

     # Run docs:generate without a prior :environment load.
  task default: :generate

     # Remove previously generated documentation.
  desc "Delete generated API documentation under tmp/docs"
  task :clean do
    require "fileutils"
    FileUtils.rm_rf("tmp/docs")
  end

     # Convenience: clean then generate.
  desc "Clean then regenerate API documentation"
  task rebuild: [:clean, :generate]
end
