require 'set'
require 'date'

class DateDetector
  @@dDELIMITERS = [ /\s+/, /\//, /\-/, /\./ ]
  @@REGEX_DATE_MAP = {
    #zero padded day/month
    /^[1-12]{2}(\/)[1-30]{2}(\/)\d{2}\s*/ => "%m/%d/%y",
    /^[1-12]{2}(\/)[1-30]{2}(\/)\d{4}\s*/ => "%m/%d/%Y",
    /^[1-30]{2}(\/)[1-12]{2}(\/)\d{2}\s*/ => "%d/%m/%y",
    /^[1-30]{2}(\/)[1-12]{2}(\/)\d{4}\s*/ => "%d/%m/%Y",

    /^\d{2}(\/)[1-30]{2}(\/)[1-12]{2}\s*/ => "%y/%d/%m",
    /^\d{4}(\/)[1-30]{2}(\/)[1-12]{2}\s*/ => "%Y/%d/%m",
    /^\d{2}(\/)[1-12]{2}(\/)[1-30]{2}\s*/ => "%y/%m/%d",
    /^\d{4}(\/)[1-12]{2}(\/)[1-30]{2}\s*/ => "%Y/%m/%d",

    /^[1-12]{2}(\/)[a-zA-Z]{3}(\/)\d{2}\s*/ => "%d/%b/%y",
    /^[1-12]{2}(\/)[a-zA-Z]{3}(\/)\d{4}\s*/ => "%d/%b/%Y",
    /^[a-zA-Z]{3}(\/)[1-12]{2}(\/)\d{2}\s*/ => "%b/%d/%y",
    /^[a-zA-Z]{3}(\/)[1-12]{2}(\/)\d{4}\s*/ => "%b/%d/%Y",

    #unpadded days/months
    /^[1-12]{1,2}(\/)[1-30]{1,2}(\/)\d{2}\s*/ => "%-m/%-d/%y",
    /^[1-12]{1,2}(\/)[1-30]{1,2}(\/)\d{4}\s*/ => "%-m/%-d/%Y",
    /^[1-30]{1,2}(\/)[1-12]{1,2}(\/)\d{2}\s*/ => "%-d/%-m/%y",
    /^[1-30]{1,2}(\/)[1-12]{1,2}(\/)\d{4}\s*/ => "%-d/%-m/%Y",

    /^\d{2}(\/)[1-30]{1,2}(\/)[1-12]{1,2}\s*/ => "%y/%-d/%-m",
    /^\d{4}(\/)[1-30]{1,2}(\/)[1-12]{1,2}\s*/ => "%Y/%-d/%-m",
    /^\d{2}(\/)[1-12]{1,2}(\/)[1-30]{1,2}\s*/ => "%y/%-m/%-d",
    /^\d{4}(\/)[1-12]{1,2}(\/)[1-30]{1,2}\s*/ => "%Y/%-m/%-d",

    #unpadded day and month spelled ex. Sep
    /^[1-12]{1,2}(\/)[a-zA-Z]{3}(\/)\d{2}\s*/ => "%-d/%b/%y",
    /^[1-12]{1,2}(\/)[a-zA-Z]{3}(\/)\d{4}\s*/ => "%-d/%b/%Y",
    /^[a-zA-Z]{3}(\/)[1-12]{1,2}(\/)\d{2}\s*/ => "%b/%-d/%y",
    /^[a-zA-Z]{3}(\/)[1-12]{1,2}(\/)\d{4}\s*/ => "%b/%-d/%Y",
  }


  def initialize
    @possible_formats = Set.new()
    @@REGEX_DATE_MAP.each do |regex,format|
      @possible_formats.add(format);
    end
  end

  def does_match(regex, str)
    (str.match regex) != nil
  end

  def get_date_format(str)
    @@REGEX_DATE_MAP.each do |regex,format|
      if !does_match(regex, str)
        @possible_formats.delete(format)
      end
    end
    @possible_formats
  end

end
#1/3/12
#16-Sep-12
#25.08.2011
#Feb 12 2010  6:02AM
#2011-05-14 22:16:00 -0400
#13/08/2009
#3/3/12
#20121111
dd = DateDetector.new()
results = dd.get_date_format("1/3/12")