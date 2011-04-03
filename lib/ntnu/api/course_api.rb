require 'uri'
require 'json'
require 'net/http'

module NTNU
  module API
    class CourseNotFoundException < StandardError; end
    class CouldNotParseCourseException < StandardError; end

    COURSES_URI = "http://www.ime.ntnu.no/api/course"

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
      attr_accessor :code, :uri
      def initialize(code)
        @code = code.downcase
        @uri  = URI.parse("#{COURSES_URI}/#{@code}")
      end
    end

    class Parser
      attr_accessor :json, :raw, :course

      def initialize(data)
        @raw = data
        @json = JSON.parse(data)
        @course = parse_course
      end

      private

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
            :teacher => parse_teacher
        })
        rescue
          raise CouldNotParseCourseException
        end
      end
      
      def value_of(elem, field)
        raise CouldNotParseCourseException.new("Missing field: #{field}") unless elem.has_key? field
        elem[field]
      end

      def parse_teacher
        person = @json['course']['educationalRole'].first['person'] || { 'firstName' => '', 'lastName' => '' }
        "#{person['firstName']} #{person['lastName']}"
      end
    end

  end
end

