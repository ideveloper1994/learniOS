/**
 * GooglePlacesDataLoaderDelegate.h
 *
 * @package Makent
 * @subpackage Controller
 * @category Calendar
 * @author Trioangle Product Team
 * @version - Stable 1.0
 * @link http://trioangle.com
 */

#import <Foundation/Foundation.h>

/**
 Delegate for GooglePlacesDataLoader. Handles callbacks related to JSON processing and error handling.
*/

@class GooglePlacesDataLoader;
@protocol GooglePlacesDataLoaderDelegate

/**
 Callback method for handling JSON data returned from a Google Places Autocomplete API request.
 
 @param loader The data loader object
 @param predictions The 'predictions' JSON array returned as part of the [Google Places Autocomplete API](https://developers.google.com/maps/documentation/places/autocomplete) response object.
*/

- (void)googlePlacesDataLoader:(GooglePlacesDataLoader *)loader didLoadAutocompletePredictions:(NSArray *)predictions;

/**
 Callback method for handling JSON data returned from a Google Place Details API request.
 
 @param loader The data loader object
 @param placeDetails The 'result' JSON object returned as part of the [Google Place Search API](https://developers.google.com/maps/documentation/places/autocomplete) place details response object.
 @param htmlAttributions A set of attributions about this listing which must be displayed to the user.
 */

- (void)googlePlacesDataLoader:(GooglePlacesDataLoader *)loader didLoadPlaceDetails:(NSDictionary *)placeDetails withAttributions:(NSString *)htmlAttributions;

/**
 Callback method for handling an error returned from a Google Places Autocomplete API request.
 
 @param loader The data loader object.
 @param error The error object. If the error is a Google Places error (as opposed to an HTTP error or otherwise) it will have a GOOGLE_PLACES_ERROR_DOMAIN and the error code will be the contents of the 'status' key, as described in the 'status codes' section of the [Google Places Autocomplete API](https://developers.google.com/maps/documentation/places/autocomplete) documentation.
*/

- (void)googlePlacesDataLoader:(GooglePlacesDataLoader *)loader autocompletePredictionsDidFailToLoad:(NSError *)error;

/**
 Callback method for handling an error returned from a Google Place Details API request.
 
 @param loader The data loader object.
 @param error The error object. If the error is a Google Places error (as opposed to an HTTP error or otherwise) it will have a GOOGLE_PLACES_ERROR_DOMAIN and the error code will be the contents of the 'status' key, as described in the 'status codes' section of the [Google Place Search API](https://developers.google.com/maps/documentation/places/) documentation.
*/

- (void)googlePlacesDataLoader:(GooglePlacesDataLoader *)loader placeDetailsDidFailToLoad:(NSError *)error;

@end
