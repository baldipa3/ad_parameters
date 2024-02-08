require 'pry'
require_relative '../lib/ad_parameters'
require_relative '../ad_parameters.pb'

RSpec.describe AdParameters do
  subject { AdParameters.new(xml) }
  let(:xml) {'tmp/example.xml'}
  let(:creatives) do
    [
      FYBER::UserConfiguration::Creative.new(id: 'Video-4', price: 0.99),
      FYBER::UserConfiguration::Creative.new(id: 'Video-1', price: 6.46),
      FYBER::UserConfiguration::Creative.new(id: 'Video-7', price: 16.65)
    ]
  end

  describe '#initialize' do
    context 'when creatives' do
      let(:creatives_seq) { FYBER::UserConfiguration::CreativeSeq.new(creative: creatives) }

      it 'has a sequence of creatives' do
        expect(subject.creatives).to eq(creatives_seq)
      end
    end

    context 'when placements' do
      let(:placement_1) { FYBER::UserConfiguration::Placement.new( id: 'plc-3', creative: creatives) }
      let(:placement_2) { FYBER::UserConfiguration::Placement.new(id: 'plc-2', creative: creatives.drop(1)) }
      let(:placement_3) { FYBER::UserConfiguration::Placement.new(id: 'plc-1', creative: creatives.drop(1)) }
      let(:placements_seq) { FYBER::UserConfiguration::PlacementSeq.new(placement: [placement_1, placement_2, placement_3]) }
      
      it 'has a sequence of placements' do
        expect(subject.placements).to eq(placements_seq)
      end
    end
  end
end