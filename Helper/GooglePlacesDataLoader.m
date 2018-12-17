/**
 * GooglePlacesDataLoader.m
 *
 * @package Makent
 * @subpackage Controller
 * @category Calendar
 * @author Trioangle Product Team
 * @version - Stable 1.0
 * @link http://trioangle.com
 */

#import "GooglePlacesDataLoader.h"
#import "GoogleKeys.h"
#import <CoreLocation/CoreLocation.h>

@interface GooglePlacesDataLoader()

@property (nonatomic, strong) NSOperationQueue *requestQueue;

@end

@implementation GooglePlacesDataLoader

@synthesize requestQueue = _requestQueue;
@synthesize delegate = _delegate;

- (id) init {
    if (self = [super init]) {
        self.requestQueue = [[NSOperationQueue alloc] init];
    }
    return self;
}

- (id)initWithDelegate:(id<GooglePlacesDataLoaderDelegate>)delegate {
    if (self = [self init]) {
        self.delegate = delegate;
    }
    return self;
}

-(NSString*)getMapService{
    return GOOGLE_MAP_API_URL;
}

-(NSString*)getMapDetailService{
    return GOOGLE_MAP_DETAILS_URL;
}


- (void)sendAutocompleteRequestWithSearchString:(NSString *)searchString andLocation:(CLLocation *)location {
    
    if (!searchString) return;
    
    NSString *paramsComponent;
    
//    if (location) { // getting nearest place search
//        paramsComponent = [NSString stringWithFormat:@"?input=%@&sensor=%@&key=%@&location=%f,%f&radius=%@",
//                           searchString,
//                           @"true",
//                           GOOGLE_PLACES_API_KEY,
//                           location.coordinate.latitude,
//                           location.coordinate.longitude,
//                           PARAMETRE_RADIUS];
//    } else {
        paramsComponent = [NSString stringWithFormat:@"?input=%@&sensor=%@&key=%@",
                           searchString,
                           @"true",
                           GOOGLE_PLACES_API_KEY
                           ];
//    }
    /*location.coordinate.latitude,
     location.coordinate.longitude
     */
   
    NSURL *url = [NSURL URLWithString:[[[self getMapService] stringByAppendingString:paramsComponent] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    void(^completionHandler)(NSURLResponse *, NSData *, NSError *) = ^(NSURLResponse *response, NSData *responseData, NSError *responseError) {
        
        if (responseError) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate googlePlacesDataLoader:self placeDetailsDidFailToLoad:responseError];
            });
            return;
        }
        
      //  NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
         id jsonResponse = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"jsonResponse = %@",jsonResponse);
        NSString *status = [jsonResponse objectForKey:RESPONSE_KEY_STATUS];
        
        if ([status isEqualToString:RESPONSE_STATUS_OK]) {
            NSArray *predictions = [jsonResponse objectForKey:RESPONSE_KEY_PREDICTIONS];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate googlePlacesDataLoader:self didLoadAutocompletePredictions:predictions];
            });
        } else {
            //successful response but problem with the input format
            NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:status, NSLocalizedDescriptionKey, nil];
            NSError *error = [NSError errorWithDomain:GOOGLE_PLACES_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate googlePlacesDataLoader:self autocompletePredictionsDidFailToLoad:error];
            });
        }
    };
    
    [NSURLConnection sendAsynchronousRequest:request queue:self.requestQueue completionHandler:completionHandler];
}

- (void)sendDetailRequestWithReferenceID:(NSString *)referenceID {
    
    NSString *paramsComponent = [NSString stringWithFormat:@"?key=%@&reference=%@&sensor=%@", GOOGLE_PLACES_API_KEY, referenceID, @"true"];
    
   
    NSURL *url = [NSURL URLWithString:[[[self getMapDetailService] stringByAppendingString:paramsComponent] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    void(^completionHandler)(NSURLResponse *, NSData *, NSError *) =  ^(NSURLResponse *response, NSData *responseData, NSError *responseError) {
        
        if (responseError) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate googlePlacesDataLoader:self placeDetailsDidFailToLoad:responseError];
            });
            return;
        }
        
       id jsonResponse = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        NSString *status = [jsonResponse objectForKey:RESPONSE_KEY_STATUS];
        
        if ([status isEqualToString:RESPONSE_STATUS_OK]) {
            NSDictionary *placeDetails = [jsonResponse objectForKey:RESPONSE_KEY_RESULT];
            NSString *attributions = [jsonResponse objectForKey:RESPONSE_KEY_ATTRIBUTIONS];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate googlePlacesDataLoader:self didLoadPlaceDetails:placeDetails withAttributions:attributions];
            });
        } else {
            //successful response but problem with the input format
            NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:status, NSLocalizedDescriptionKey, nil];
            NSError *error = [NSError errorWithDomain:GOOGLE_PLACES_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate googlePlacesDataLoader:self placeDetailsDidFailToLoad:error];
            });
        }

    };

    [NSURLConnection sendAsynchronousRequest:request queue:self.requestQueue completionHandler:completionHandler];
}


- (void)cancelAllRequests {
    [self.requestQueue cancelAllOperations];
}

@end
