# frozen_string_literal: true

require 'application_system_test_case'

class LeadsTest < ApplicationSystemTestCase
  setup do
    @lead = leads(:one)
  end

  test 'visiting the index' do
    visit leads_url
    assert_selector 'h1', text: 'Leads'
  end

  test 'creating a Lead' do
    visit leads_url
    click_on 'New Lead'

    fill_in 'Client contact', with: @lead.client_contact
    fill_in 'Client email', with: @lead.client_email
    fill_in 'Client name', with: @lead.client_name
    fill_in 'Is sale', with: @lead.is_sale
    fill_in 'Platform used', with: @lead.platform_used
    fill_in 'Project name', with: @lead.project_name
    click_on 'Create Lead'

    assert_text 'Lead was successfully created'
    click_on 'Back'
  end

  test 'updating a Lead' do
    visit leads_url
    click_on 'Edit', match: :first

    fill_in 'Client contact', with: @lead.client_contact
    fill_in 'Client email', with: @lead.client_email
    fill_in 'Client name', with: @lead.client_name
    fill_in 'Is sale', with: @lead.is_sale
    fill_in 'Platform used', with: @lead.platform_used
    fill_in 'Project name', with: @lead.project_name
    click_on 'Update Lead'

    assert_text 'Lead was successfully updated'
    click_on 'Back'
  end

  test 'destroying a Lead' do
    visit leads_url
    page.accept_confirm do
      click_on 'Destroy', match: :first
    end

    assert_text 'Lead was successfully destroyed'
  end
end
