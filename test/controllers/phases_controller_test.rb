# frozen_string_literal: true

require 'test_helper'

class PhasesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @phase = phases(:one)
  end

  test 'should get index' do
    get phases_url
    assert_response :success
  end

  test 'should get new' do
    get new_phase_url
    assert_response :success
  end

  test 'should create phase' do
    assert_difference('Phase.count') do
      post phases_url, params: { phase: { assignee: @phase.assignee, due_date: @phase.due_date, lead_id: @phase.lead_id, phase_type: @phase.phase_type, start_date: @phase.start_date } }
    end

    assert_redirected_to phase_url(Phase.last)
  end

  test 'should show phase' do
    get phase_url(@phase)
    assert_response :success
  end

  test 'should get edit' do
    get edit_phase_url(@phase)
    assert_response :success
  end

  test 'should update phase' do
    patch phase_url(@phase), params: { phase: { assignee: @phase.assignee, due_date: @phase.due_date, lead_id: @phase.lead_id, phase_type: @phase.phase_type, start_date: @phase.start_date } }
    assert_redirected_to phase_url(@phase)
  end

  test 'should destroy phase' do
    assert_difference('Phase.count', -1) do
      delete phase_url(@phase)
    end

    assert_redirected_to phases_url
  end
end
