#encoding: utf-8
require "rspec"
require 'spec_helper'

require 'ntnu/api/course_api'
require 'course'

module NTNU
  module API
    describe Parser do

      it "should handle requests for invalid courses" do
        expect do
          NTNU::API::Parser.new('{ "course": [], "request": { "courseCode": "tdt5110" }}')
        end.to raise_exception(NTNU::API::CourseNotFoundException)
      end

      it "should handle incomplete responses" do
        expect do
          NTNU::API::Parser.new('{ "course": { "code": 123, "englishName": 0 }}')
        end.to raise_exception(NTNU::API::CouldNotParseCourseException)
      end

      it "should handle non JSON responses" do
        expect do
          NTNU::API::Parser.new('{ "course": { "code":1, 2, ,3 }')
        end.to raise_exception(JSON::ParserError)
      end
      
      subject do
        data = <<-EOS
          {
            "course": {
              "code": "TDT4220",
              "name": "Ytelsesvurdering",
              "englishName": "Computer Systems Performance Evaluation",
              "versionCode": "1",
              "credit": 7.5,
              "creditTypeCode": "SP",
              "gradeRule": "30",
              "gradeRuleText": "Bokstavkarakterer",
              "assessment": [
                {"code": "MAPPE-1","codeName": "Mappeevaluering" },
                {"code": "MAPPE-2","codeName": "Mappeevaluering" }
              ],
              "mandatoryActivity": [
                { "number": 1, "name": "\u00d8vinger" }
              ],
              "educationalRole": [
                {
                  "code": "Coordinator",
                  "person": {
                    "firstName": "Gunnar",
                    "lastName": "Brataas",
                    "email": "gunnar.brataas@idi.ntnu.no"
                  }
                }
              ]
            }
          }
        EOS
        Parser.new(data)
      end

      it "should parse JSON response into Hash" do
        subject.json.should be_a Hash
        subject.json['course']['code'].should eq "TDT4220"
      end

      it "should parse JSON UTF-8 literals" do
        mandatory_activities = subject.json['course']['mandatoryActivity']
        mandatory_activities.size.should eq 1
        subject.json['course']['mandatoryActivity'].first['name'].should eq "Øvinger"
      end

      it "should parse a Course object" do
        subject.course.code.should eq "TDT4220"
        subject.course.name.should eq "Computer Systems Performance Evaluation"
        subject.course.credit.should eq 7.5
        subject.course.assessments.should eq 2
        subject.course.mandatory_activities.should eq 1
        subject.course.teacher.should eq "Gunnar Brataas"
      end

    end

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
      subject { CourseClient.get('TDT4220') }

      it "should retrieve" do
        subject.json.should be_a Hash
        subject.course.should be_a Course
      end

    end

  end
end
