require 'nokogiri'
require 'pry'
require_relative './errors'
require_relative './currency_rate'

class XmlParser
  include CurrencyRate
  attr_reader :raw_xml

  Parameters = Struct.new(:creative, :placements)

  def initialize(raw_xml)
    @raw_xml =  raw_xml
  end

  def parse_file
    doc = File.read(raw_xml) { |f| Nokogiri::XML::Node.new('root', f) }
    parsed_doc = Nokogiri::XML::DocumentFragment.parse(doc)
    
    valid_xml?(parsed_doc)

    build_parameters(parsed_doc)
  end

private

  def valid_xml?(parsed_doc)
    if parsed_doc.css('Creative').empty? || parsed_doc.css('Placement').empty?
      raise Errors::MissingTagError
    else 
      true
    end
  end

  def build_parameters(parsed_doc)
    {
      creatives: fetch_creatives(parsed_doc.css('Creative')),
      placements: fetch_placements(parsed_doc.css('Placement'))
    }
  end

  def fetch_creatives(creatives)
    creatives.map do |creative|
      {
        id: creative[:id],
        price: fix_currency(creative[:price].to_f, creative[:currency]),
        currency: 'EUR'
      }
    end
  end

  def fetch_placements(placements)
    placements.map do |placement|
      {
        id: placement[:id],
        floor: fix_currency(placement[:floor].to_f, placement[:currency]),
        currency: 'EUR'
      }
    end
  end

  def fix_currency(amount, currency)
    case currency
    when 'USD'
      (amount / USD_TO_EUR).round 2
    when 'SEK'
      (amount / SEK_TO_EUR).round 2
    when 'TYR'
      (amount / TYR_TO_EUR).round 2
    else
      amount.round 2
    end
  end
end