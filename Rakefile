require 'rake'
require 'gruff'
require 'csv'
require 'erb'

task :default => :all


class DataRow < Struct.new(:hash, :commit_message, :spec_runtime, :application_lines, :library_lines, :spec_lines, :comment_lines, :covered_lines, :total_lines, :number_of_files)
end

desc 'Draw all types of graphs'
task :all => [:draw_loc_graph,
              :draw_spec_runtime_graph,
              :draw_spec_to_prod_ratio_graph,
              :draw_coverage_ratio_graph,
              :draw_coverage,
              :draw_number_of_files]

desc "Draw 'lines of code' graph"
task :draw_loc_graph => :read_csv do

  comment_values = []
  library_lines_values = []
  application_lines_values = []
  spec_lines_values = []
  production_lines_values = []

  @data.each do |row|
    comment_values << row['Comments Count'].to_f
    library_lines_values << row['Library Lines'].to_f
    application_lines_values << row['Application Lines'].to_f
    spec_lines_values << row['Spec Lines'].to_f
    production_lines_values << (row['Application Lines'].to_f + row['Library Lines'].to_f)
  end

  graph = Gruff::Line.new
  graph.title = 'Lines of code'
  graph.center_labels_over_point
  graph.marker_font_size = 12
  graph.line_width = 2
  graph.dot_radius = 3

  graph.data(:comments, comment_values)
  graph.data('Library Lines', library_lines_values)
  graph.data('Application Lines', application_lines_values)
  graph.data('Spec Lines', spec_lines_values)
  graph.data('Production Lines', production_lines_values)
  graph.write('loc.png')

end

desc "Draw 'spec runtime' graph"
task :draw_spec_runtime_graph => :read_csv do

  spec_run_times = []
  @data.each do |row|
    spec_run_times << row['Spec Runtime'].to_f
  end

  graph = Gruff::Line.new
  graph.title = 'Specs Run Time'
  graph.center_labels_over_point
  graph.marker_font_size = 12
  graph.line_width = 2
  graph.dot_radius = 3
  graph.data('Spec run time', spec_run_times)
  graph.write('spec_run_time.png')

end

desc "Draw 'spec to prod ratio' graph"
task :draw_spec_to_prod_ratio_graph => :read_csv do

  spec_to_prod_ratio = []
  @data.each do |row|
    denom = row['Library Lines'].to_i + row['Application Lines'].to_i
    val = denom != 0.0 ? (row['Spec Lines'].to_f / denom) : 0
    spec_to_prod_ratio << val
  end

  graph = Gruff::Line.new
  graph.title = 'Spec/Prod'
  graph.center_labels_over_point
  graph.marker_font_size = 12
  graph.line_width = 2
  graph.dot_radius = 3
  graph.data('Spec to prod', spec_to_prod_ratio)
  graph.write('spec_to_prod_ratio.png')

end

desc "Draw 'coverage ratio' graph"
task :draw_coverage_ratio_graph => :read_coverage_csv do

  coverage_ratio = []
  @coverage.each do |row|
    val = row['Total Lines'].to_i != 0 ? (row['Covered Lines'].to_f / row['Total Lines'].to_f) : 0
    coverage_ratio << val
  end

  graph = Gruff::Line.new
  graph.title = 'Covered/Total Lines'
  graph.center_labels_over_point
  graph.marker_font_size = 12
  graph.line_width = 2
  graph.dot_radius = 3
  graph.data('Covered/Total', coverage_ratio)
  graph.write('coverage_ratio.png')

end

desc "Draw 'coverage' graph"
task :draw_coverage => :read_coverage_csv do

  covered_lines = []
  total_lines = []
  @coverage.each do |row|
    covered_lines << row['Covered Lines'].to_i
    total_lines << row['Total Lines'].to_i
  end

  graph = Gruff::Line.new
  graph.title = 'Coverage'
  graph.center_labels_over_point
  graph.marker_font_size = 12
  graph.line_width = 2
  graph.dot_radius = 3
  graph.data('Covered Lines', covered_lines)
  graph.data('Total Lines', total_lines)
  graph.write('coverage.png')
end

task :draw_number_of_files => :read_csv do
  number_of_files = []

  @data.each do |row|
    val = row['Number of Files']
    number_of_files << val.to_i
  end

  graph = Gruff::Bar.new
  graph.title = 'Number of Files'
  graph.center_labels_over_point
  graph.marker_font_size = 12
  # graph.line_width = 2
  # graph.dot_radius = 3
  graph.data('Number of Files', number_of_files)
  graph.write('number_of_files.png')
end

def get_template
  file = File.open('index.html.erb', 'rb')
  file.read
end

def render
  @table = []
  data_rows = []

  @data.each do |row|
    dr = DataRow.new
    dr.hash= row['Hash']
    dr.commit_message= row['Commit Message']
    dr.spec_runtime= row['Spec Runtime']
    dr.application_lines= row['Application Lines']
    dr.library_lines= row['Library Lines']
    dr.spec_lines= row['Spec Lines']
    dr.comment_lines= row['Comments Count']
    dr.number_of_files = row['Number of Files']
    # (:hash, :commit_message, :spec_runtime, :application_lines, :library_lines, :spec_lines, :comment_lines, :covered_lines, :total_lines, :number_of_files)
    data_rows << dr
  end

  @coverage.each do |row|
    dr = data_rows.select { |data_row| data_row.hash == row['Hash'] }.first
    dr.covered_lines = row['Covered Lines']
    dr.total_lines = row['Total Lines']
  end

  data_rows.each do |dr|
    @table << [dr.hash, dr.commit_message, dr.spec_runtime, dr.application_lines, dr.library_lines, dr.spec_lines, dr.comment_lines, dr.number_of_files, dr.covered_lines, dr.total_lines]
  end

  ERB.new(get_template).result(binding)
end

def save(file, content)
  File.open(file, 'w+') do |f|
    f.write(content)
  end
end

task :render_project_page => :all do
  html = render
  save('index.html', html)
end


task :read_csv do
  @data = CSV.read('file_data.csv', headers: true)
end

task :read_coverage_csv do
  @coverage = CSV.read('coverage_data.csv', headers: true)
end


