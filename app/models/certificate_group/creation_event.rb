class CertificateGroup::CreationEvent < CertificateGroupEvent
  def build_certificate_group
    CertificateGroup.new
  end

  def certificate_not_persisted
    if self.certificate_group.persisted?
      self.errors.add(:certificate_group, "already exists")
    end
  end

  def apply(certificate_group)
    certificate_group.created_at = self.created_at
    certificate_group
  end
end
