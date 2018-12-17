/**
 * PlaceDetailsAnnotation.m
 *
 * @package Makent
 * @subpackage Controller
 * @category Calendar
 * @author Trioangle Product Team
 * @version - Stable 1.0
 * @link http://trioangle.com
 */

#import "PlaceDetailsAnnotation.h"
#import "GoogleKeys.h"

@interface PlaceDetailsAnnotation()

@property (nonatomic, strong, readwrite) NSDictionary *placeDetails;

@end

@implementation PlaceDetailsAnnotation

@synthesize placeDetails = _placeDetails;


- (id)initWithPlaceDetails:(NSDictionary *)placeDetails {
    if (self = [super init]) {
        self.placeDetails = placeDetails;
    }
    return self;
}

- (NSString *)title {
    return [self.placeDetails objectForKey:RESPONSE_KEY_NAME];
}

- (NSString *)subtitle {
    return [self.placeDetails objectForKey:RESPONSE_KEY_FORMATTED_ADDRESS];
}

- (CLLocationCoordinate2D)coordinate {
    NSDictionary *placeGeometry = [self.placeDetails objectForKey:RESPONSE_KEY_GEOMETRY];
    NSDictionary *locationDetails = [placeGeometry objectForKey:RESPONSE_KEY_LOCATION];
    NSNumber *lat = [locationDetails objectForKey:RESPONSE_KEY_LATITUDE];
    NSNumber *lng = [locationDetails objectForKey:RESPONSE_KEY_LONGITUDE];
    return CLLocationCoordinate2DMake([lat doubleValue], [lng doubleValue]);
    
}

@end
