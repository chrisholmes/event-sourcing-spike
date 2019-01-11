class Certificate < Aggregate
  aggregates :certificate_events
  belongs_to :owner, class_name: 'CertificateGroup'
  validates_presence_of :use, :value, :owner

  def self.creation_event_class
    Certificate::CreateEvent
  end
end
