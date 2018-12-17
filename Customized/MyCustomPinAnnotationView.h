/**
 * MyCustomPinAnnotationView.h
 *
 * @package Makent
 * @subpackage Controller
 * @category Calendar
 * @author Trioangle Product Team
 * @version - Stable 1.0
 * @link http://trioangle.com
 */

#import <MapKit/MapKit.h>
#import "MyCustomPointAnnotation.h"

@protocol uploadDelegate

-(void)uploadDidfinish:(int)tag;

@end


@interface MyCustomPinAnnotationView : MKAnnotationView
{
    NSInteger selectedIndex;
}
@property NSString *price;
@property UIColor *color;

@property (nonatomic,strong) id <uploadDelegate> upDelegate;
- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation;

@end
