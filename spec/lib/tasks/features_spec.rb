require 'spec/spec_helper'

describe "Features-related rake tasks" do
  fixtures :affiliates, :features
  before do
    @rake = Rake::Application.new
    Rake.application = @rake
    Rake.application.rake_require "lib/tasks/features"
    Rake::Task.define_task(:environment)
  end

  describe "usasearch:features" do
    describe "usasearch:features:record_feature_usage" do
      before do
        @task_name = "usasearch:features:record_feature_usage"
      end

      it "should have 'environment' as a prereq" do
        @rake[@task_name].prerequisites.should include("environment")
      end

      context "when not given a data file or feature internal name" do
        it "should print out an error message" do
          Rails.logger.should_receive(:error)
          @rake[@task_name].invoke
        end
      end

      context "when given a data file and feature internal name" do
        before do
          AffiliateFeatureAddition.delete_all
          @a1 = affiliates(:basic_affiliate)
          @a2 = affiliates(:power_affiliate)
          @f1 = features(:disco)
          @a1.features << @f1
          @input_file_name = ::Rails.root.to_s + "/affiliate_feature_addition.txt"
          File.open(@input_file_name, 'w+') do |file|
            file.puts(@a1.id)
            file.puts(@a2.id)
          end
        end

        it "should create AffiliateFeatureAdditions for new affiliate IDs for that feature, ignoring dupes" do
          @f1.affiliates.size.should == 1
          @f1.affiliates.first.should == @a1
          @rake[@task_name].invoke(@f1.internal_name, @input_file_name)
          @f1.affiliates.size.should == 2
          @f1.affiliates.last.should == @a2
        end

        after do
          File.delete(@input_file_name)
        end
      end
    end
  end
end