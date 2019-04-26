require 'nokogiri'
require 'open-uri'

class MoshCourses::MoshScraper
    def initialize()
        @_baseUrl = "https://codewithmosh.com"
        @_allCUrl = "https://codewithmosh.com/p/all-access"
        @doc = Nokogiri::HTML(open(@_allCUrl).read) #https://codewithmosh.com/p/all-access
    end

    def getCourses
        allCourses = @doc.css("div[data-course-url]")
        tab = allCourses.map do |course|            
            ash = {}
            ash[:url] = course['data-course-url']
            ash[:title] = course.css("div.course-listing-title").text
            ash[:subtitle] = course.css("div.course-listing-subtitle").text
            ash[:price] = course.css("div.course-price").text
            ash[:img_url] = course.css("img.course-box-image").attr('src').value
            ash[:author] = {}
            ash[:author][:profile_url] = course.css("img.img-circle").attr('src').value
            ash[:author][:name] = course.css("div.course-author-name").text            
            ash[:description] = getCourseDescription(course['data-course-url'])
            ash
        end
    end

    def getCourseDescription(_url)
        MoshCourses::CourseScraper.new(@_baseUrl + _url).getSections
    end
end