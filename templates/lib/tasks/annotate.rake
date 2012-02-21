task :add_rspec_annotation_support do
  SourceAnnotationExtractor.class_eval do
    def self.enumerate(tag, options = {})
      extractor = new(tag)
      extractor.display(extractor.find(%w(app config lib script test spec)), options)
    end
  end
end

%w(notes notes:todo notes:fixme notes:optimize).each do |task|
  Rake::Task[task].enhance([:add_rspec_annotation_support])
end
