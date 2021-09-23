require 'spec_helper'

describe IsbmAdaptor::Duration do
  context 'when invalid arguments' do
    it 'raises an ArgumentError with invalid symbols' do
      expect { IsbmAdaptor::Duration.new(invalid_symbol: 1) }.to raise_error ArgumentError
    end

    it 'raises an ArgumentError with negative values' do
      expect { IsbmAdaptor::Duration.new(years: -1) }.to raise_error ArgumentError
    end
  end

  context 'when valid arguments' do
    it 'supports single date values' do
      expect(IsbmAdaptor::Duration.new(years: 2).to_s).to eq 'P2Y'
      expect(IsbmAdaptor::Duration.new(months: 2).to_s).to eq 'P2M'
      expect(IsbmAdaptor::Duration.new(days: 2).to_s).to eq 'P2D'
    end

    it 'passes through 0 date values' do
      expect(IsbmAdaptor::Duration.new(years: 0).to_s).to eq 'P0Y'
      expect(IsbmAdaptor::Duration.new(months: 0).to_s).to eq 'P0M'
      expect(IsbmAdaptor::Duration.new(days: 0).to_s).to eq 'P0D'
    end

    it 'supports multiple date values' do
      expect(IsbmAdaptor::Duration.new(years: 1, months: 2).to_s).to eq 'P1Y2M'
      expect(IsbmAdaptor::Duration.new(years: 1, months: 2, days: 3).to_s).to eq 'P1Y2M3D'
    end

    it 'supports single time values' do
      expect(IsbmAdaptor::Duration.new(hours: 2).to_s).to eq 'PT2H'
      expect(IsbmAdaptor::Duration.new(minutes: 2).to_s).to eq 'PT2M'
      expect(IsbmAdaptor::Duration.new(seconds: 2).to_s).to eq 'PT2S'
    end

    it 'passes through 0 time values' do
      expect(IsbmAdaptor::Duration.new(hours: 0).to_s).to eq 'PT0H'
      expect(IsbmAdaptor::Duration.new(minutes: 0).to_s).to eq 'PT0M'
      expect(IsbmAdaptor::Duration.new(seconds: 0).to_s).to eq 'PT0S'
    end

    it 'supports multiple time values' do
      expect(IsbmAdaptor::Duration.new(hours: 1, minutes: 2).to_s).to eq 'PT1H2M'
      expect(IsbmAdaptor::Duration.new(hours: 1, minutes: 2, seconds: 3).to_s).to eq 'PT1H2M3S'
    end

    it 'supports combined date and time values' do
      expect(IsbmAdaptor::Duration.new(years: 1, hours: 2).to_s).to eq 'P1YT2H'
      expect(IsbmAdaptor::Duration.new(months: 1, minutes: 2).to_s).to eq 'P1MT2M'
      expect(IsbmAdaptor::Duration.new(years: 1, months: 2, days: 3, hours: 4, minutes: 5, seconds: 6).to_s).to eq 'P1Y2M3DT4H5M6S'
    end

    it 'supports more values exceeding carry over points' do
      expect(IsbmAdaptor::Duration.new(months: 13, days: 400, hours: 25, minutes: 61, seconds: 62).to_s).to eq 'P13M400DT25H61M62S'
    end

    it 'supports fractional values' do
      expect(IsbmAdaptor::Duration.new(minutes: 0.5).to_s).to eq 'PT0.5M'
    end

    let(:hash) { {days: 1, minutes: 2} }

    it 'outputs to hash' do
      expect(IsbmAdaptor::Duration.new(hash).to_hash).to eq hash
    end
  end
end
