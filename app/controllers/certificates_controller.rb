class CertificatesController < ApplicationController
  def index
    @certificate_groups = CertificateGroup.all
    render :index
  end

  def create_group
    group = CertificateGroup.create
    redirect_to show_certificate_group_path(group.id)
  end

  def show
    @group = CertificateGroup.includes(:certificates).find(params.fetch(:id))
    render :show
  end

  def create_certificate
    @group = CertificateGroup.find(params.fetch(:id))
    event = Certificate::CreateEvent.create(params.permit(certificate: [:use, :value]).slice(:certificate)[:certificate].merge(owner: @group))
    if event.persisted? && event.certificate.persisted?
      redirect_to show_certificate_group_path(@group.id)
    else
      render :create_certificate_error
    end
  end
end
