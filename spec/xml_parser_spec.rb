require_relative '../lib/xml_parser'
require_relative '../lib/currency_rate'

RSpec.describe XmlParser do
  context 'when data is complete' do
    let(:xml) {'tmp/example.xml'}
    let(:parser) { XmlParser.new(xml) }

      context 'when creatives' do
        let(:expected_creatives) do
          [
            {
              id: 'Video-1',
              price: 6.4567.round(2),
              currency: 'EUR'
            },
            {
              id: 'Video-4',
              price: (1.1234 / CurrencyRate::USD_TO_EUR).round(2),
              currency: 'EUR'
            },
            {
              id: 'Video-7',
              price: (55.123 / CurrencyRate::SEK_TO_EUR).round(2),
              currency: 'EUR'
            },
          ]
        end

        it 'returns the creatives attributes' do
          expect(parser.parse_file[:creatives]).to eq expected_creatives
        end
      end

      context 'when placements' do
        let(:expected_placements) do
          [
            {
              id: 'plc-1',
              floor: 1.3456.round(2),
              currency: 'EUR'
            },
            {
              id: 'plc-2',
              floor: (4.234 / CurrencyRate::SEK_TO_EUR).round(2),
              currency: 'EUR'
            },
            {
              id: 'plc-3',
              floor: (8.343 / CurrencyRate::TYR_TO_EUR).round(2),
              currency: 'EUR'
            },
          ]
        end

        it 'returns the placements attributes' do
          expect(parser.parse_file[:placements]).to eq expected_placements
        end
      end
  end

  context 'when data is incomplete' do
    let(:xml) {'tmp/example_no_tag.xml'}
    let(:parser) { XmlParser.new(xml) }
    let(:message) { 'Creative or Placement tag is missing.' }

    it 'raises an error with a missing header message' do
      expect { parser.parse_file }.to raise_error(Errors::MissingTagError, message)
    end
  end
end