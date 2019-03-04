require 'rails_helper'

RSpec.describe Certificate, type: :model do
  let(:good_owner) {
    CertificateGroup.create
  }

  it "represents the creation of a certificate" do
    certificate = Certificate.create(use: "signing", value: "FOOBARBAZ", owner: good_owner)
    expect(certificate).to be_persisted
    expect(certificate.events.first).to be_persisted
  end
end
