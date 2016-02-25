desc 'Sync data from internal Freckle projects to external'
task :sync_freckle => :environment do
  FreckleProject.internal.each do |internal_project|
    puts "Processing #{internal_project.name}"
    external_name = internal_project.name.gsub('_internal', '')
    puts "\tCopying to #{external_name}"
    destination_project = FreckleProject.by_name(external_name)
    if destination_project
      puts "\tDestination project found"
      internal_project.entries(:today).each do |entry|
        if destination_project.entries(:today).any? do |existing_entry|
          existing_entry.source_url == entry.url
        end
          puts "\t\tEntry already exists, skipping"
        else
          puts "\t\tCopying entry #{entry.description}"
          entry.copy_to(destination_project)
        end
      end
    else
      puts "\tProject #{external_name} is not found"
    end
  end
end
