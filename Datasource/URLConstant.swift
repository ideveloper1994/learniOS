//
//  URLConstant.swift
//  Arheb
//
//  Created on 5/30/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import Foundation

//struct ServiceURL {

//MARK: LIVE SERVER URL
let baseUrl = "http://makent.trioangle.com/api/"
//let baseUrl = "http://46.101.220.196/api/"
let webServerUrl = "http://makent.trioangle.com/"

//MARK: Demo Server URL
//let ServerUrl = "http://demo.trioangle.com/Arheb/api/"
//let WebServerUrl = "http://demo.trioangle.com/Arheb/"

//MARK:- LIST OF API NAMES WITH ENDPOINT

//MARK:- API NAME FOR TRAVEL

let  API_SIGNUP           = "register"//"signup"
let  API_LOGIN            = "login"
let  API_EMAILVALIDATION  = "email-validation"//"emailvalidation"
let  API_FORGOTPASSWORD   = "forgot-password"//"forgotpassword"
let  API_EXPLORE          = "explore"
let  API_ROOM_DETAIL      = "rooms"
let  API_MAPS_LIST        = "maps"
let  API_HOUSE_RULES      = "house_rules"
let  API_AMENITIES_LIST   = "amenities_list"
let  API_REVIEW_LIST      = "review_detail"
let  API_CALENDAR_AVAILABEL      = "calendar_availability"
let  API_ROOM_AVAILABLE_STATUS   = "calendar_availability_status"
let  API_GET_RESERVATION = "reservation_list"
let  API_CANCEL_RESERVATION = "host_cancel_reservation"
let  API_DECLINE_RESERVATION = "decline"
let  API_ADD_ROOM_PRICE  = "add_rooms_price"
let  API_UPDATE_ROOM_CURRENCY = "update_room_currency"
let  API_CURRENCY_LIST = "currency_list"
let  API_UPDATE_POLICY = "update_policy"
let  API_UPDATE_BOOKING_TYPE = "update_booking_type"
let  API_CALENDER_ROOMS_LIST  = "rooms_list_calendar"
let  API_BLOCK_DATES = "new_update_calendar"
let  API_PRE_APPROVAL_OR_DECLINE = "pre_approve"
let  API_CHANGE_CURRENCY = "currency_change"
let  API_GET_LISTING = "listing"
let  API_EDIT_PROFILE = "edit_profile"
let  API_UPLOAD_PROFILE_IMAGE = "upload_profile_image"
let  API_VIEW_PROFILE = "view_profile"
let  API_ADD_PAYOUT_DETAILS = "add_payout_perference"
let  API_GET_PAYOUT_LIST = "payout_details"
let  API_DELETE_PAYOUT = "payout_delete"
let  API_MAKE_DEFAULT_PAYOUT = "payout_makedefault"
let  API_PAYOUT_CHANGES = "payout_changes"
let  API_ADD_NEW_ROOM = "new_add_room"
let  API_PRE_ACCEPT = "accept"
let  API_UPLOAD_ROOM_IMAGE = "room_image_upload"
let  API_UPDATE_ROOM_DESC = "update_description"
let  API_UPDATE_HOUSE_RULES = "update_house_rules"
let  API_UPDATE_TITLE = "update_title_description"
let  API_GET_ROOM_DESC = "get_room_description"
let  API_UPDATE_ROOM_LOCATION = "update_location"
let  API_UPDATE_LONG_TERM_PRICE = "update_Long_term_prices"
let  API_ROOMS_BEDS_LIST = "listing_rooms_beds"
let  API_UPDATE_SELECTED_AMENITIES = "update_amenities"
let  API_CONVERSATION_LIST = "conversation_list"
let  API_SENDMESSAGE = "send_message"
let  API_VIEW_OTHER_PROFILE = "user_profile_details"
let  API_INBOX_RESERVATION = "inbox_reservation"
let  API_DISABLE_LISTING = "disable_listing"
let  API_PRE_PAYMENT = "pre_payment"
let  API_COUNTRY_LIST = "country_list"
let  API_BOOK_NOW = "book_now"
let  API_PAY_NOW = "pay_now"
let  API_REMOVE_ROOM_IMAGE = "remove_uploaded_image"
//MARK:- Explore
let API_EXPLORE_LIST = "explorepage"

let API_CONTACT_HOST             = "contact_request"
let API_ADD_TO_WISHLIST          = "add_wishlists"
let API_GET_WISHLIST             = "get_wishlist" //get_wishlist
let API_GET_PARTICULAR_WISHLIST  = "get_particular_wishlist"
let API_DELETE_WISHLIST          = "delete_wishlist"
let API_CHANGE_PRIVACY_WISHLIST  = "edit_wishlist"
let API_TRIPS_TYPE = "trips_type"
let API_TRIPS_DETAILS = "trips_details"
let API_UPDATE_LONG_TERM_PRICES = "update_Long_term_prices"

struct PostKey{
    static let postType = "PostType"
    static let imageData = "ImageData"
    static let image = "Image"
    static let filename = "FileName"
}

struct GetKey{
    static let getType = "GetType"
    static let location = "Location"
    static let instagram = "Instagram"
}

//MARK:- API PARAMETER KEY
struct Signup{
    static let emailId = "email"
    static let password = "password"
    static let dob = "dob"
    static let googleId = "gpid"
    static let facebookId = "fbid"
    static let firstName = "first_name"
    static let lastName = "last_name"
    static let profilePic = "profile_pic"
    static let phone = "phone"
    static let location = "user_location"
    static let school = "school"
    static let work = "work"
    static let aboutMe = "about_me"
    static let gender = "gender"
    static let urlThumb = "user_thumb_url"
}
struct Messages{
    static let reservationID = "reservation_id"
    static let hostUserID =  "host_user_id"
    static let message = "message"
    static let messageType = "message_type"
    static let roomId = "room_id"
    static let messageTypeStatic = "5"
}

struct UpdateLongTerms{
    static let roomId = "room_id"
    static let weeklyPrice = "weekly_price"
    static let monthlyPrice = "monthly_price"
    static let cleaningFee = "cleaning_fee"
    static let additionalGuest = "additional_guests"
    static let forEachGuest = "for_each_guest"
    static let securityDeposite = "security_deposit"
    static let weekendPricing = "weekend_pricing"
}

struct RoomBed{
    static let roomId = "room_id"
    static let bathrooms = "bathrooms"
    static let roomType = "room_type"
    static let personCapacity = "person_capacity"
    static let bedRooms = "bedrooms"
    static let beds = "beds"
    static let propertyType = "property_type"
}

//MARK:- Web Page URL
let  URL_HELPS_SUPPORT = "help"
let  URL_WHY_HOST = "why_host"
let  URL_TERMS_OF_SERVICE = "terms_of_service"


struct InstagramKey{
   static let clientId = "cb188e31648d4a37a8bb90e3261541af"
   static let clientSecret = "2684464f6d344b37849d4f48a1dc94d8"
   static let redirectUrl = "https://www.instagram.com/"
   static let scope = "public_content"
}

let CACELATION_POLICY_FLEXIBLE = "<html><h3><font  face=\"verdana\"  color=\"#484848\">Flexible: Full refund 1 day prior to arrival, except fees</h3><ul><li>Cleaning fees are always refunded if the guest did not check in.</li><br><li>The Makent service fee is non-refundable.</li><br><li>If there is a complaint from either party, notice must be given to Makent within 24 hours of check-in.</li><br><li>Makent will mediate when necessary, and has the final say in all disputes.</li><br><li>A reservation is officially canceled when the guest clicks the cancellation button on the cancellation confirmation page, which they can find in Dashboard &gt; Your Trips &gt; Change or Cancel.</li><br><li>Cancellation policies may be superseded by the Guest Refund Policy, safety cancellations, or extenuating circumstances. Please review these exceptions.</li><br><li>Applicable taxes will be retained and remitted.</li><br></ul><p>For a full refund, cancellation must be made a full 24 hours prior to listing’s local check in time (or 3:00 PM if not specified) on the day of check in.  For example, if check-in is on Friday, cancel by Thursday of that week before check in time.</p></div><div class=\"col-md-4\"><p>If the guest cancels less than 24 hours before check-in, the first night is non-refundable.</p></div><div class=\"col-md-4\"><p>If the guest arrives and decides to leave early, the nights not spent 24 hours after the official cancellation are 100% refunded.</p></div></html>"


let CACELATION_POLICY_MODERATE = "<html><h3><font  face=\"verdana\"  color=\"#484848\">Moderate: Full refund 5 days prior to arrival, except fees</h3><ul><li>Cleaning fees are always refunded if the guest did not check in.</li><br><li>The Makent service fee is non-refundable.</li><br><li>If there is a complaint from either party, notice must be given to Makent within 24 hours of check-in.</li><br><li>Makent will mediate when necessary, and has the final say in all disputes.</li><br><li>A reservation is officially canceled when the guest clicks the cancellation button on the cancellation confirmation page, which they can find in Dashboard &gt; Your Trips &gt; Change or Cancel.</li><br><li>Cancellation policies may be superseded by the Guest Refund Policy, safety cancellations, or extenuating circumstances. Please review these exceptions.</li><br><li>Applicable taxes will be retained and remitted.</li></ul><p>For a full refund, cancellation must be made five full days prior to listing’s local check in time (or 3:00 PM if not specified) on the day of check in.  For example, if check-in is on Friday, cancel by the previous Sunday before check in time.</p></div><div class=\"col-md-4\"><p>If the guest cancels less than 5 days in advance, the first night is non-refundable but the remaining nights will be 50% refunded.</p></div><div class=\"col-md-4\"><p>If the guest arrives and decides to leave early, the nights not spent 24 hours after the cancellation occurs are 50% refunded.</p></div></html>"

let CACELATION_POLICY_STRICT = "<html><h3><font  face=\"verdana\"  color=\"#484848\">Strict: 50% refund up until 1 week prior to arrival, except fees</h3><ul><li>Cleaning fees are always refunded if the guest did not check in.</li><li>The Makent service fee is non-refundable.</li><li>If there is a complaint from either party, notice must be given to Makent within 24 hours of check-in.</li><li>Makent will mediate when necessary, and has the final say in all disputes.</li><li>A reservation is officially canceled when the guest clicks the cancellation button on the cancellation confirmation page, which they can find in Dashboard &gt; Your Trips &gt; Change or Cancel.</li><li>Cancellation policies may be superseded by the Guest Refund Policy, safety cancellations, or extenuating circumstances. Please review these exceptions.</li><li>Applicable taxes will be retained and remitted.</li></ul><p>For a 50% refund, cancellation must be made seven full days prior to listing’s local check in time (or 3:00 PM if not specified) on the day of check in, otherwise no refund. For example, if check-in is on Friday, cancel by Friday of the previous week before check in time.</p></div><div class=\"col-md-4\"><p>If the guest cancels less than 7 days in advance, the nights not spent are not refunded.</p></div><div class=\"col-md-4\"><p>If the guest arrives and decides to leave early, the nights not spent are not refunded.</p></div></html>"

//MARK: New features
let API_GOVERNMMENT_TYPE = "government_id_types"
let API_VERIFY_GOVERNMMENT_TYPE = "verify_government_id"
let API_REMOVE_PHONE_NUMBER = "remove_phone_number"
let API_VERIFY_PHONE_NUMBER = "verify_phone_number"
let API_UPDATE_PHONE_NUMBER = "update_phone_number"
let API_GET_PHONE_NUMBER = "get_phone_numbers"

