require 'rails_helper'

RSpec.describe Certificate::CreateEvent, type: :model do
  let(:good_owner) {
    CertificateGroup.create
  }

  it "represents the creation of a certificate" do
    event = Certificate::CreateEvent.create!(use: "signing", value: "FOOBARBAZ", owner: good_owner)
    expect(event).to be_persisted
    expect(event.certificate).to be_persisted
  end

  it 'cannot be attached to a certificate that already exists' do
    first_event = Certificate::CreateEvent.create(use: "signing", value: "FOOBARBAZ", owner: good_owner)
    expect(first_event).to be_persisted
    certificate = first_event.certificate 
    expect(certificate).to be_persisted

    second_event = Certificate::CreateEvent.create(use: "signing", value: "FOOBARBAZ", certificate: certificate, owner: good_owner)
    expect(second_event).to_not be_valid
    expect(second_event).to_not be_persisted
    expect(second_event.errors[:certificate]).to eql ["already exists"]
  end

  context "#owner" do
    let(:non_persisted_owner) {
      double(:owner, present?: true, persisted?: true)
    }
    it 'must have an owner' do
      event = Certificate::CreateEvent.create(use: "signing", value: "FOOBARBAZ")
      expect(event).to_not be_valid
      expect(event.errors[:owner]).to eql ["can't be blank"]
    end
    
    it 'must have a persisted owner' do
      event = Certificate::CreateEvent.create(use: "signing", value: "FOOBARBAZ", owner: RelyingParty.new)
      expect(event).to_not be_valid
      expect(event.errors[:owner]).to eql ["must exist"]
    end
  end

  context '#value' do
    it 'must be present' do
      event = Certificate::CreateEvent.create(use: "signing", owner: good_owner)
      expect(event).to_not be_valid
      expect(event.errors[:value]).to eql ["can't be blank"]
    end
  end

  context '#use' do
    it 'must be present' do
      event = Certificate::CreateEvent.create(value: "signing", owner: good_owner)
      expect(event).to_not be_valid
      expect(event.errors[:use]).to eql ["can't be blank"]
    end

    it 'must be signing or encryption' do
      first_event = Certificate::CreateEvent.create(use: 'signing', value: 'signing', owner: good_owner)
      expect(first_event).to be_valid

      second_event = Certificate::CreateEvent.create(use: 'encryption', value: 'signing', owner: good_owner)
      expect(second_event).to be_valid

      third_event = Certificate::CreateEvent.create(use: 'banana', value: 'signing', owner: good_owner)
      expect(third_event).to_not be_valid

      blank_event = Certificate::CreateEvent.create(use: '', value: 'signing', owner: good_owner)
      expect(blank_event).to_not be_valid
    end
  end
end
