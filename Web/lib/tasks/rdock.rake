require 'rdoc/task'

RDoc::Task.new :rdoc do |rdoc|
  rdoc.main = "README.rdoc"

  rdoc.rdoc_files.include("README.rdoc")
  #change above to fit needs

  rdoc.title = "NextLec Documentation"
  rdoc.options << "--all"
end