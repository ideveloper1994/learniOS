/**
 * GooglePlacesDataLoader.h
 *
 * @package Makent
 * @subpackage Controller
 * @category Calendar
 * @author Trioangle Product Team
 * @version - Stable 1.0
 * @link http://trioangle.com
 */

#import <Foundation/Foundation.h>
#import "GooglePlacesDataLoaderDelegate.h"

/**
 An asynchronous loader class for obtaining JSON data from the Google Places API. Uses a GooglePlacesDataLoaderDelegate for response and error handling.
*/

@class CLLocation;

@interface GooglePlacesDataLoader : NSObject

/**
 Delegate class for JSON response and error handling.
*/

@property (nonatomic, weak) id <GooglePlacesDataLoaderDelegate> delegate;

/**
 Constructor.
*/
- (id)initWithDelegate:(id<GooglePlacesDataLoaderDelegate>)delegate;

/**
 Sends a request to the [Google Places Autocomplete API](https://developers.google.com/maps/documentation/places/autocomplete).
 
 @param searchString The string used to generate autocomplete results.
 @param location The location used as the origin point of the search, used by Google to provide location biasing. If nil, no location biasing is provided.
 
 @see [GooglePlacesDataLoaderDelegate googlePlacesDataLoader:didLoadAutocompletePredictions:]
*/

- (void)sendAutocompleteRequestWithSearchString:(NSString *)searchString 
                                    andLocation:(CLLocation *)location;

/**
 Sends a place details request to the [Google Place API](https://developers.google.com/maps/documentation/places/).
 
 The reference ID is returned as part of the GooglePlacesDataLoaderDelegate 's didLoadAutocompletePredictions callback.
 
 @param referenceID The (non-stable) reference ID passed as input to the place details request
 
 @see [GooglePlacesDataLoaderDelegate googlePlacesDataLoader:didLoadPlaceDetails:withAttributions:]
*/

- (void)sendDetailRequestWithReferenceID:(NSString *)referenceID;

/**
 Cancels all pending requests in the data loader's request queue.
*/

- (void)cancelAllRequests;

@end
