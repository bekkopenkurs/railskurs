#encoding: utf-8
require 'rspec'
require 'spec_helper'

require 'json'
require 'ntnu/api/parser'

module NTNU
  module API
    describe CourseParser do

      it "should handle requests for invalid courses" do
        nonexisting_course = JSON.parse('{ "course": [], "request": { "courseCode": "tdt5110" }}')
        expect do
          NTNU::API::CourseParser.new(nonexisting_course).parse
        end.to raise_exception(NTNU::API::CourseNotFoundException)
      end

      it "should handle incomplete responses" do
        incomplete_response = JSON.parse('{ "course": { "code": 123, "englishName": 0 }}')
        expect do
          NTNU::API::CourseParser.new(incomplete_response).parse
        end.to raise_exception(NTNU::API::CouldNotParseCourseException)
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
        CourseParser.new(JSON.parse(data))
      end

      it "should parse JSON response into a Course" do
        subject.parse.should be_a Course
      end

      it "should parse a Course object" do
        subject.parse.code.should eq "TDT4220"
        subject.parse.name.should eq "Computer Systems Performance Evaluation"
        subject.parse.credit.should eq 7.5
        subject.parse.assessments.should eq 2
        subject.parse.mandatory_activities.should eq 1
        subject.parse.teacher.should eq "Gunnar Brataas"
      end
    end
  end
end