namespace :assets do
  task sync: :environment do
    `aws s3 sync public/assets s3://bg-image-converter/assets`
  end
end

# Rake::Task['assets:precompile'].enhance(['assets:sync'])
