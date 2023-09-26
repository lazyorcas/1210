# frozen_string_literal: true

require "application_system_test_case"

class MeetupsTest < ApplicationSystemTestCase
  # setup do
  #   @meetup = meetups(:one)
  # end

  # test "visiting the index" do
  #   visit meetups_url(@meetup.date)
  #   assert_selector "h1", text: "Meetups"
  # end

  # test "should create meetup" do
  #   visit meetups_url(@meetup.date)
  #   click_on "New meetup"

  #   fill_in "Date", with: @meetup.date
  #   fill_in "Description", with: @meetup.description
  #   fill_in "End time", with: @meetup.end_time
  #   fill_in "Start time", with: @meetup.start_time
  #   fill_in "Title", with: @meetup.title
  #   fill_in "User", with: @meetup.organizer_id
  #   click_on "Create Meetup"

  #   assert_text "Meetup was successfully created"
  #   click_on "Back"
  # end

  # test "should update Meetup" do
  #   visit meetup_url(@meetup)
  #   click_on "Edit this meetup", match: :first

  #   fill_in "Date", with: @meetup.date
  #   fill_in "Description", with: @meetup.description
  #   fill_in "End time", with: @meetup.end_time
  #   fill_in "Start time", with: @meetup.start_time
  #   fill_in "Title", with: @meetup.title
  #   fill_in "User", with: @meetup.organizer_id
  #   click_on "Update Meetup"

  #   assert_text "Meetup was successfully updated"
  #   click_on "Back"
  # end

  # test "should destroy Meetup" do
  #   visit meetup_url(@meetup)
  #   click_on "Destroy this meetup", match: :first

  #   assert_text "Meetup was successfully destroyed"
  # end
end
