class Certificate::CreateEvent < Event
  aggregated_with :certificate
  data_attributes :use, :value
  aggregate_belongs_to :owner

  validate :certificate_not_persisted, on: :create
  validate :owner_exists
  validates_presence_of :value, :use, :owner
  validates :use, inclusion: { in: %w{ signing encryption } }, allow_blank: true

  def build_certificate
    Certificate.new
  end

  def certificate_not_persisted
    if self.certificate.persisted?
      self.errors.add(:certificate, "already exists")
    end
  end

  def owner_exists
    if self.owner.present? && !self.owner.persisted?
      self.errors.add(:owner, "must exist")
    end
  end

  def apply(certificate)
    certificate.use = self.use
    certificate.value = self.value
    certificate.owner = self.owner
    certificate.created_at = self.created_at
    certificate
  end

end
