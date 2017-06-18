require 'rspec'
require 'my_google_drive'

describe MyGoogleDrive do
  it 'has OOB_URI constant' do
    expect(described_class::OOB_URI).to be_a String
  end

  it 'has APPLICATION_NAME constant' do
    expect(described_class::APPLICATION_NAME).to be_a String
  end

  it 'has SCOPE constant as AUTH_DRIVE url' do
    expect(described_class::SCOPE).to eq 'https://www.googleapis.com/auth/drive'
  end
end
