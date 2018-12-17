/**
 * GoogleKeys.h
 *
 * @package Makent
 * @subpackage Controller
 * @category Calendar
 * @author Trioangle Product Team
 * @version - Stable 1.0
 * @link http://trioangle.com
 */

#import <Foundation/Foundation.h>

static NSString * const GOOGLE_MAP_API_URL              = @"https://maps.googleapis.com/maps/api/place/autocomplete/json";
static NSString * const GOOGLE_MAP_DETAILS_URL          = @"https://maps.googleapis.com/maps/api/place/details/json";
static NSInteger const kGoogleAPINSErrorCode            = 42;
static NSString * const GOOGLE_PLACES_API_KEY           = @"AIzaSyAYVHgDeSBCitv0p-pxkJBMAVWemoa5Pkk";
static NSString * const PARAMETRE_RADIUS                = @"10000";

static NSString * const RESPONSE_KEY_STATUS             = @"status";
static NSString * const RESPONSE_STATUS_OK              = @"OK";
static NSString * const RESPONSE_KEY_PREDICTIONS        = @"predictions";
static NSString * const RESPONSE_KEY_DESCRIPTION        = @"description";
static NSString * const RESPONSE_KEY_REFERENCE          = @"reference";
static NSString * const RESPONSE_KEY_RESULT             = @"result";
static NSString * const RESPONSE_KEY_ATTRIBUTIONS       = @"html_attributions";
static NSString * const RESPONSE_KEY_NAME               = @"name";
static NSString * const RESPONSE_KEY_LOCATION           = @"location";
static NSString * const RESPONSE_KEY_GEOMETRY           = @"geometry";
static NSString * const RESPONSE_KEY_LATITUDE           = @"lat";
static NSString * const RESPONSE_KEY_LONGITUDE          = @"lng";
static NSString * const RESPONSE_KEY_VICINITY           = @"vicinity";
static NSString * const RESPONSE_KEY_FORMATTED_ADDRESS  = @"formatted_address";
static NSString * const GOOGLE_PLACES_ERROR_DOMAIN      = @"ADGooglePlacesErrorDomain";
static NSString * const ADDRESS_COMPONENTS              = @"address_components";
static NSString * const ADDRESS_TYPES                   = @"types";


