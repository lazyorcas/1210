# frozen_string_literal: true

require "test_helper"

class MeetupsControllerTest < ActionDispatch::IntegrationTest
  # setup do
  #   @meetup = meetups(:one)
  # end

  # test "should get index" do
  #   get meetups_url(@meetup.date)
  #   assert_response :success
  # end

  # test "should get new" do
  #   get new_meetup_url(@meetup.date)
  #   assert_response :success
  # end

  # test "should create meetup" do
  #   assert_difference("Meetup.count") do
  #     post meetups_url(date: @meetup.date),
  #       params: {
  #         meetup: {
  #           description: @meetup.description,
  #           end_time: @meetup.end_time,
  #           start_time: @meetup.start_time,
  #           title: @meetup.title,
  #           organizer_id: @meetup.organizer_id,
  #         },
  #       }
  #   end

  #   assert_redirected_to meetup_url(Meetup.last)
  # end

  # test "should show meetup" do
  #   get meetup_url(@meetup)
  #   assert_response :success
  # end

  # test "should get edit" do
  #   get edit_meetup_url(@meetup)
  #   assert_response :success
  # end

  # test "should update meetup" do
  #   patch meetup_url(@meetup),
  #     params: {
  #       meetup: {
  #         date: @meetup.date,
  #         description: @meetup.description,
  #         end_time: @meetup.end_time,
  #         start_time: @meetup.start_time,
  #         title: @meetup.title,
  #         organizer_id: @meetup.organizer_id,
  #       },
  #     }
  #   assert_redirected_to meetup_url(@meetup)
  # end

  # test "should destroy meetup" do
  #   assert_difference("Meetup.count", -1) do
  #     delete meetup_url(@meetup)
  #   end

  #   assert_redirected_to meetups_url(@meetup.date)
  # end
end
