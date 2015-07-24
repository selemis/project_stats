def value_for(lines, keyword)
  lines.each do |line|
    return line.split('|').map { |s| s.strip }[3] if line.include?(keyword)
  end
  return 0
end

def value_for_spec(lines, keyword)
  lines.each do |line|
    return line.split(' ').map { |s| s.strip }[2] if line.include?(keyword)
  end
  return 0
end

def value_for_coverage(lines, keyword)
  lines.each do |line|
      if line.include?(keyword)
        words = line.split(' ').map { |s| s.strip }
        return words[7], words[9] 
      end
  end
  return 0, 0
end



desc 'Call stats'
task :call_stats do
  project = ENV['PROJECT'] || 'homekeeping_stats'
   
  Dir.chdir project 
 
 
  o = 0 # Number of files
  n = 0 # Number of lines of code
  m = 0 # Number of lines of comments
#  files = Dir.glob('**/*.rb')
  files = FileList['app/**/*.rb', 'lib/**/*.rb']
  
  files.each do |f|
    next if FileTest.directory?(f)
    o += 1
    i = 0
    lines = []
    File.new(f).each_line do |line|
      if line.strip[0] == '#'
        m += 1
        next
      end
      lines << line
      i += 1
    end
    n += i
  end
  
  puts "#{o.to_s} files."
  puts "#{n.to_s} lines of code."
  puts "#{(n.to_f/o.to_f).round(2)} LOC/file."
  puts "#{m.to_s} lines of comments."
  comments = m
  number_of_files = o
    #PROJECT='homekeeping_stats'

  git_hash =`git log -1 --pretty=%h`
  git_commit_message_hash =`git log -1 --pretty=%s`

  sh 'rake stats > ../stats.txt'
  sh 'rspec spec > ../specs.txt || true'
  begin
      sh 'rake spec:coverage > ../coverage.txt'
  rescue => e
  end

  lines = IO.readlines('../stats.txt')

  model_loc = value_for(lines, 'Models')
  controller_loc =  value_for(lines, 'Controllers')
  helpers_loc =  value_for(lines, 'Helpers')
  javascripts_loc =  value_for(lines, 'Javascripts')
  mailers_loc = value_for(lines, 'Mailers')
  libraries_loc = value_for(lines, 'Libraries')
  feature_specs_loc = value_for(lines, 'Feature specs')
  model_specs_loc = value_for(lines, 'Model specs')
  controller_specs_loc = value_for(lines, 'Controller specs')

  spec_lines = IO.readlines('../specs.txt')
  spec_time = value_for_spec(spec_lines, 'Finished in')

  coverage_lines = IO.readlines('../coverage.txt')
  coverage = value_for_coverage(coverage_lines, 'Coverage report generated for RSpec')

  File.open('../file_data.csv', 'a') do |f|
    f.puts "#{git_hash.chomp},#{comments},#{libraries_loc},#{model_loc.to_i + controller_loc.to_i + helpers_loc.to_i + javascripts_loc.to_i + mailers_loc.to_i},#{feature_specs_loc.to_i + model_specs_loc.to_i + controller_specs_loc.to_i},#{spec_time},#{number_of_files},#{git_commit_message_hash.chomp}"
  end

  File.open('../coverage_data.csv', 'a') do |f|
    f.puts "#{git_hash.chomp},#{coverage[0].to_i},#{coverage[1].to_i}" 
  end

end
