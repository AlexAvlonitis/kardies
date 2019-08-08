namespace :reindex do
  desc "This task re-indexes elastic cache"

  task :cache => :environment do
    User.__elasticsearch__.create_index! force: true
    User.__elasticsearch__.refresh_index!

    UserDetail.__elasticsearch__.create_index! force: true
    UserDetail.__elasticsearch__.refresh_index!

    User.import
  end
end
