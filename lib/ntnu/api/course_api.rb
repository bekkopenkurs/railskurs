require 'uri'
require 'json'
require 'net/http'

module NTNU
  module API
    class IllegalCourseCodeException < StandardError; end
    class CourseNotFoundException < StandardError; end
    class CouldNotParseCourseException < StandardError; end

    COURSES_URI = "http://www.ime.ntnu.no/api/course"
    COURSE_CODE_REGEX = /^[a-z]{3}\d{4}$/i

    class CourseClient
      def CourseClient.get(code)
        data = do_http(Request.new(code))
        Parser.new(data)
      end

      private

      def CourseClient.do_http(request)
        Net::HTTP.new(request.uri.host, request.uri.port).start do |http|
          http.request(Net::HTTP::Get.new(request.uri.path))
        end.body
      end
    end

    protected

    class Request
      attr_accessor :uri
      def initialize(code)
        raise IllegalCourseCodeException.new("Illegal course code format ('ABC1234')") unless code =~ COURSE_CODE_REGEX
        @uri  = URI.parse("#{COURSES_URI}/#{code}")
      end
    end

    class Parser
      attr_accessor :json, :raw, :course

      def initialize(data)
        @raw = data
        @json = JSON.parse(data)
        @course = parse_course
      end

      protected

      def parse_course
        course = @json['course']
        raise CourseNotFoundException if course.empty?
        require 'course'
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

