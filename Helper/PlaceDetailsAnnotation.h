/**
 * PlaceDetailsAnnotation.h
 *
 * @package Makent
 * @subpackage Controller
 * @category Calendar
 * @author Trioangle Product Team
 * @version - Stable 1.0
 * @link http://trioangle.com
 */

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface PlaceDetailsAnnotation : NSObject <MKAnnotation>

@property (nonatomic, strong, readonly) NSDictionary *placeDetails;


- (id)initWithPlaceDetails:(NSDictionary *)placeDetails;


@end
