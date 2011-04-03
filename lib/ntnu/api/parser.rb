require 'course'

module NTNU
  module API
    class CourseNotFoundException < StandardError; end
    class CouldNotParseCourseException < StandardError; end

    # Parses a NTNU Courses API JSON format to Application domain
    # Takes input: Ruby Hash (from JSON)
    class CourseParser
      def initialize(json)
        @course_json = json
      end

      def parse
        course = @course_json['course']
        raise CourseNotFoundException.new("No such course found") if course.empty?
        begin
          Course.new ({
              :code => value_of(course, 'code'),
              :name => value_of(course, 'englishName'),
              :credit => value_of(course, 'credit'),
              :assessments => value_of(course, 'assessment').size,
              :mandatory_activities => value_of(course, 'mandatoryActivity').size,
              :teacher => parse_coordinator(course)
          })
        rescue
          raise CouldNotParseCourseException
        end
      end

      protected

      def value_of(elem, field)
        raise CouldNotParseCourseException.new("Missing field: #{field}") unless elem.has_key? field
        elem[field]
      end

      def parse_coordinator(course)
        educational_role = value_of(course, 'educationalRole').select { |e| e['code'] =~ /Coordinator/ }.first
        person = value_of(educational_role, 'person')
        "#{value_of(person, 'firstName')} #{value_of(person, 'lastName')}"
      end

    end

  end
end