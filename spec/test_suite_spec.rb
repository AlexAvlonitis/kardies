# frozen_string_literal: true

require "spec_helper"
require "active_support/core_ext/string/inflections"

RSpec.describe "TestSuite" do
  Dir["{app}/**/*.rb", "engines/**/{app}/**/*.rb"].each do |filename|
    context filename do
      subject { filename }

      let(:testfile) do
        filename
            .sub("app", "spec")
            .sub(".rb", "_spec.rb")
      end

      it "fails when file has no tests" do
        next if testfile =~ /models\/.+_spec.rb/ # Very few models require testing, so not to create "it exists"...
        next if testfile =~ /mailers\/.+_spec.rb/ # Ignore mailers
        next if testfile =~ /serializers\/.+_spec.rb/ # Ignore serializers
        next if testfile =~ /policies\/.+_spec.rb/ # Ignore policies
        next if testfile =~ /channels\/.+_spec.rb/ # Ignore channels


        expect(File.exist?(testfile)).to be_truthy, "File `#{testfile}` must exist"
        class_name = File.basename(filename, ".rb").camelcase
        File.open(testfile, :encoding => "utf-8") do |file|
          expect(file.read.downcase).to match(class_name.downcase)
        end
      end
    end
  end
end
