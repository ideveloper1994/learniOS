/**
 * MyCustomPointAnnotation.h
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

@interface MyCustomPointAnnotation : MKPointAnnotation

@property NSString *price;
@property UIColor *color;

@end
