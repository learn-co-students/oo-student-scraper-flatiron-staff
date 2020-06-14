require 'open-uri'
require 'pry'
require 'nokogiri'

class Scraper
  attr_accessor :students

  def self.scrape_index_page(index_url)
    doc = Nokogiri::HTML(open(index_url))
    @students = []
    student_tiles_array = doc.css("div.student-card")
    student_tiles_array.each do |student| 
      this_student = {}  
      this_student[:name] = student.css("h4.student-name").text
      this_student[:location] = student.css("p.student-location").text
      this_student[:profile_url] = student.css("a")[0]["href"]
      @students << this_student
    end 
    @students
  end 
  
  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(open(profile_url))
    @profiles = {}
    social_links_array = doc.css("div.social-icon-container").css("a")
    social_links_array.each do |link| 
      if link["href"].include? "twitter"
        @profiles[:twitter] = link["href"] 
      elsif  link["href"].include? "linkedin"
        @profiles[:linkedin] = link["href"]  
      elsif  link["href"].include? "github"
        @profiles[:github] = link["href"]  
      else 
        @profiles[:blog] = link["href"]
      end 
    end 
    @profiles[:profile_quote] = doc.css("div.profile-quote").text
    @profiles[:bio] = doc.css("div.description-holder").css("p").text
    @profiles
  end

end

