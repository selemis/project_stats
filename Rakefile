require 'rake'
require 'gruff'
require 'csv'

task :default => :all

desc 'Draw all types of graphs'
task :all => [:draw_loc_graph,
              :draw_spec_runtime_graph,
              :draw_spec_to_prod_ratio_graph,
              :draw_coverage_ratio_graph,
              :draw_coverage]

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


task :read_csv do
  @data = CSV.read('file_data.csv', headers: true)
end

task :read_coverage_csv do
  @coverage = CSV.read('coverage_data.csv', headers: true)
end


