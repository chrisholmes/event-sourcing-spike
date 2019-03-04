require 'rails_helper'

RSpec.feature "edit a certificate group", type: :feature do
  it 'can create a certificate group' do
    visit show_certificates_path
    click_on 'Create'
    id = CertificateGroup.last.id
    expect(current_path).to eql show_certificate_group_path(id)
    visit show_certificates_path
    expect(page).to have_content id.to_s
    expect(page).to have_link 'View', href: show_certificate_group_path(id)
  end

  it 'add certificates to a certificate group' do
    group = CertificateGroup.create
    # certificate = Certificate.create(owner: group, value: 'Banana', use: 'signing')
    visit show_certificate_group_path(group.id)
    choose 'Signing'
    fill_in 'Value', with: 'Banana'
    click_on 'Create Certificate'
    expect(current_path).to eql show_certificate_group_path(group.id)
    expect(page).to have_content("Usage: signing Value: Banana")
  end
end
