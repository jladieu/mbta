puts "SILENCE! #{Rails.root.to_s}"

Rails.backtrace_cleaner.add_filter { |line| line.gsub(Rails.root.to_s, '') }  # Remove the absolute path of your application's root directory
Rails.backtrace_cleaner.add_filter { |line| line.gsub(Gem.path[0], '') }  # Remove the absolute path of the Ruby gems directory
Rails.backtrace_cleaner.add_filter { |line| line.gsub(/[\d]+:in `.*'/, '') }  # Remove line numbers and method names

# Add additional filters here if needed

# Add your own custom filters if necessary
Rails.backtrace_cleaner.add_filter { |line| line }

# Remove any lines that still contain the absolute path of your application's root directory
Rails.backtrace_cleaner.add_silencer { |line| line.include?(Rails.root.to_s) }
