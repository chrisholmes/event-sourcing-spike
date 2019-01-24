require 'rails_helper'
require 'models/event_spec'

RSpec.describe CertificateGroup::CreationEvent, type: :model do
  include_examples "is a creation event", CertificateGroup::CreationEvent, {}
end
