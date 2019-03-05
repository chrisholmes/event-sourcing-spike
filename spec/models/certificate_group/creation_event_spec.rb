require 'rails_helper'

RSpec.describe CertificateGroup::CreationEvent, type: :model do
  include_examples "is a creation event", CertificateGroup::CreationEvent, {}
end
