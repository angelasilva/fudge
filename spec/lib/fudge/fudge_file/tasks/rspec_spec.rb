require 'spec_helper'

describe Fudge::FudgeFile::Tasks::Rspec do
  it { should be_registered_as :rspec }

  describe :run do
    it "should run rspec with the path of spec/ by default" do
      subject.should_receive('`').with('rspec spec/')

      subject.run
    end

    it "should allow configuring of the directory to run specs for" do
      subject = described_class.new(:path => 'foo/ bar/')
      subject.should_receive('`').with('rspec foo/ bar/')

      subject.run
    end

    describe "coverage checking" do
      it "should succeed if coverage is greater than specified" do
        subject = described_class.new(:coverage => 90)

        subject.should_receive('`').and_return('100.0%) covered')

        subject.run.should be_true
      end

      it "should fail if coverage is less than given" do
        subject = described_class.new(:coverage => 90)

        subject.should_receive('`').and_return('80.4%) covered')

        subject.run.should be_false
      end

      it "should pass if coverage is the same as given" do
        subject = described_class.new(:coverage => 100)

        subject.should_receive('`').and_return('100.0%) covered')

        subject.run.should be_true
      end

      it "should fail if no coverage output was found" do
        subject = described_class.new(:coverage => 100)

        subject.should_receive('`').and_return('')

        subject.run.should be_false
      end
    end
  end
end
