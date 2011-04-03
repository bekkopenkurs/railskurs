#encoding: utf-8
require "rspec"
require 'spec_helper'

require 'ntnu/api/client'
require 'course'

module NTNU
  module API
    describe Request do
      subject { NTNU::API::Request.new('TDT4220') }

      it "should require valid code" do
        expect { NTNU::API::Request.new('TDTX0000') }.to raise_exception(NTNU::API::IllegalCourseCodeException)
      end

      it "should generate request uri from code" do
        subject.uri.host.should eq "www.ime.ntnu.no"
        subject.uri.port.should eq 80
        subject.uri.path.should eq "/api/course/TDT4220"
      end

    end

    @integration
    describe CourseClient do
      subject { CourseClient.get_json('TDT4220') }

      it "should retrieve a rubified JSON tree" do
        subject.should be_a Hash
      end

    end

  end
end
