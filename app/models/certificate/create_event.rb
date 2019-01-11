class Certificate::CreateEvent < CertificateEvent
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

  def use
    self.data ||= {}
    self.data['certificate_type']
  end

  def use=(type)
    self.data ||= {}
    self.data['certificate_type'] = type
  end

  def value
    self.data ||= {}
    self.data['value']
  end

  def value=(type)
    self.data ||= {}
    self.data['value'] = type
  end

  def owner
    @owner
  end

  def owner=(owner)
    @owner = owner
    self.owner_id = owner.id
  end

  def owner_id=(type)
    self.data ||= {}
    self.data['owner_id'] = type
  end
end
