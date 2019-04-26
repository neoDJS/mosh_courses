class MoshCourses::CourseScraper
    def initialize(_url)
        @doc = Nokogiri::HTML(open(_url).read)
    end

    def getSections
        allSections = @doc.css("div.course-section")
        tab = allSections.map do |section|
            rawTitle = section.css("div.section-title").text
            startI = section.css("div.section-title > span").text.length
            endI = rawTitle.index(section.css("div.section-title > div").text)

            items = section.css("ul.section-list > li.section-item > a.item")
            # rawTitle.slice(startI..endI).strip #startI..endI
            ash = {}
            ash[:title] =  rawTitle.slice(startI..endI).strip
            ash[:items] = items.map do |item|
                rawLabel = item.text
                startI2 = item.css("span.lecture-icon, div").text.length + 22
                endI2 = rawLabel.length
                ash2 = {}
                ash2[:label] = rawLabel.slice(startI2..endI2).strip.gsub(/[\n](\s)*/, " ")
                ash2[:url] = item['href']
                ash2
            end
            ash
        end
    end
end