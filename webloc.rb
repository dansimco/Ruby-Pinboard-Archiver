# Basic Ruby code to read and write ".webloc" files (as used on OS X)
# Reads both "old" Safari style and newer plist style
# Writes "old" style only
# Works on Ruby 1.9.2 and 1.8.7

require 'plist'

class Webloc
  attr_accessor :url

  def initialize(url)
    @url = url
  end

  def self.load(filename)
    data = File.read(filename)
    data = data.force_encoding('binary') rescue data
    
    if data !~ /\<plist/
      offset = (data =~ /SURL_/)
      length = data[offset + 6]
      length = length.ord rescue length
      url = data[offset + 7,length]  
    else
      url = Plist::parse_xml(filename)['URL'] rescue nil
    end
    
    raise ArgumentError unless url
    new(url)
  end

  def data
    @data = "\x62\x70\x6C\x69\x73\x74\x30\x30\xD1\x01\x02\x53\x55\x52\x4C\x5F\x10"
    @data += @url.length.chr
    @data += @url
    @data += "\x08\x0B\x0F\x00\x00\x00\x00\x00\x00\x01\x01\x00\x00\x00\x00\x00\x00\x00\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
    @data += (@url.length + 18).chr
  end
  
  def save(filename)
    File.open(filename, 'w:binary') { |f| f.print data }
  end
end

# To READ a webloc file:
#puts Webloc.load(ARGV.first).url

# To CREATE a webloc file:
#Webloc.new('http://peterc.org/').save('peterc.webloc')
