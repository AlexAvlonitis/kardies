namespace :personalities do
  desc "This task re-populates the table personalities"

  task :recreate => :environment do
    puts 'Re-creating personalities table'
    Personality.destroy_all

    personalities = YAML.load_file("config/personalities.yml")['personalities']

    personalities.each do |personality|
      Personality.create(
        code: personality.first,
        detail: personality.last
      )
    end
    puts 'Done!'
  rescue StandardError => e
    puts e
  end
end
