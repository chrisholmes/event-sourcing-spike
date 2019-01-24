class CertificateGroup::CreationEvent < Event
  aggregated_with :group
  validate :group_not_persisted, on: :create

  def build_group
    CertificateGroup.new
  end

  def group_not_persisted
    if self.group.persisted?
      self.errors.add(:group, "already exists")
    end
  end

  def apply(certificate_group)
    certificate_group.created_at = self.created_at
    certificate_group
  end
end
