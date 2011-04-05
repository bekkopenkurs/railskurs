require 'uri'
require 'json'
require 'net/http'

module NTNU
  module API
    class IllegalCourseCodeException < StandardError; end

    COURSES_URI = "http://www.ime.ntnu.no/api/course"
    COURSE_CODE_REGEX = /^[a-z]{3}\d{4}$/i

    class CourseClient
      def CourseClient.get_json(code)
        JSON.parse(do_http(Request.new(code)))
      end

      def CourseClient.get_course(code)
        json = JSON.parse(do_http(Request.new(code)))
        require 'ntnu/api/parser'
        CourseParser.new(json).parse
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

  end
end

