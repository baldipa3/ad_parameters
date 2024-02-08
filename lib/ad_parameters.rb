require 'pry'
require_relative '../ad_parameters.pb'
require_relative './xml_parser'

class AdParameters
  attr_reader :parameters, :creatives, :placements

  include FYBER::UserConfiguration

  def initialize(xml)
    @parameters =  XmlParser.new(xml).parse_file
    @creatives = build_creatives
    @placements = build_placements
  end

  def print_protobuf
    puts "PlacementsSeq protobuf"
    placements.placement.each do |placement|
      puts '', '*' * 22
      puts "Placement id: #{placement.id}"
      puts '*' * 22
      placement.creative.each do |creative|
        puts "Creative id: #{creative.id}"
        puts "Creative price: #{creative.price} €"
        puts '-' * 22
      end
      puts
    end
  end

  private

  def build_creatives
    sorted_creatives = parameters[:creatives].sort_by { |creative| creative[:price] }
    creatives = sorted_creatives.map do |creative| 
      Creative.new(id: creative[:id], price: creative[:price]) 
    end

    CreativeSeq.new(creative: creatives)
  end

  def build_placements
    sorted_placements = parameters[:placements].sort_by { |placement| placement[:floor] }
    placements = sorted_placements.map do |placement| 
      creatives = associate_creatives(placement[:floor])

      Placement.new(id: placement[:id], creative: creatives) 
    end

    PlacementSeq.new(placement: placements)
  end

  def associate_creatives(floor)
    creatives.creative.select { |creative| creative.price >= floor }
  end
end