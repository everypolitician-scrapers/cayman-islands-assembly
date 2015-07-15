#!/bin/env ruby
# encoding: utf-8

require 'scraperwiki'
require 'nokogiri'
require 'open-uri'
require 'cgi'
require 'json'
require 'date'
require 'colorize'

require 'pry'
require 'open-uri/cached'
OpenURI::Cache.cache_path = '.cache'

def noko_for(url)
  Nokogiri::HTML(open(url).read) 
end

def date_from(str)
  return if str.to_s.empty?
  Date.parse(str)
end

def scrape_list(url)
  noko = noko_for(url)
  noko.xpath('.//ul[.//p[@class="member"]]').each do |ul|
    mp = ul.css('p.member').first
    fullname = mp.css('a').text
    name, suffix = fullname.split(',', 2)
    prefix, name = name.split(' ', 2)

    data = { 
      name: name.strip,
      honorific_prefix: prefix.strip,
      honorific_suffix: suffix.to_s.strip,
      image: ul.css('img/@src').first.text,
      constituency: mp.text[/ember for (.*)/, 1].strip,
      party: ul.xpath('./preceding::h4[1]').text.strip,
      # term: term_from(tds[0].text.strip),
      # source: url,
    }
    puts data
    # ScraperWiki.save_sqlite([:id, :term], mem)
  end
end

scrape_list('http://www.legislativeassembly.ky/portal/page?_pageid=4242,7282402&_dad=portal&_schema=PORTAL')
