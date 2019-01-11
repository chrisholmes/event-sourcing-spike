class CertificateGroup < Aggregate
  aggregates :certificate_group_events
  has_many :certificates, foreign_key: :owner_id
  def self.creation_event_class
    CertificateGroup::CreationEvent
  end
end
