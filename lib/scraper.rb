require 'open-uri'
require 'nokogiri'
require 'pry'

class Scraper

  attr_accessor :name, :location, :profile_url

  def self.scrape_index_page(index_url)
    scraped_students = []
    html = open(index_url)
    doc = Nokogiri::HTML(html)
    doc.css(".student-card").each do |student|
      individual_student = {
        name: student.css("h4").text,
        location: student.css("p").text,
        profile_url: "#{student.attr('href')}"
      }
      scraped_students << individual_student
    end
    scraped_students
  end

  def self.scrape_profile_page(profile_url)
    html = open(profile_url)
    doc = Nokogiri::HTML(html)
    student_info = {}
    student_info[:profile_quote] = doc.css(".profile-quote").text
    student_info[:bio] = doc.css(".bio-content p").text

    doc.css(".social-icon-container a").each do |link|
      if link["href"].include?("twitter")
        student_info[:twitter] = link["href"]
      elsif link["href"].include?("linkedin")
        student_info[:linkedin] = link["href"]
      elsif link["href"].include?("github")
        student_info[:github] = link["href"]
      else link["href"].include?("blog")
        student_info[:blog] = link["href"]
      end
    end
    student_info
  end

end
