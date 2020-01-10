require 'coveralls'

class AllButFilepathFilter < SimpleCov::Filter
  # Return true unless given source's filename exactly matches string
  # configured when initialized with `AllButFilepathFilter.new('filename')`.
  def matches?(source_file)
    source_file.project_filename != filter_argument
  end
end

SimpleCov.start do
  formatter = SimpleCov::Formatter::MultiFormatter.new([
    Coveralls::SimpleCov::Formatter,
    SimpleCov::Formatter::HTMLFormatter,
  ])

  add_group 'poorman', 'poorman$'
  add_filter AllButFilepathFilter.new('/poorman')
end
