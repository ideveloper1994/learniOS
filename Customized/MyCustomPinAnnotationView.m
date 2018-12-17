/**
 * MyCustomPinAnnotationView.m
 *
 * @package Makent
 * @subpackage Controller
 * @category Calendar
 * @author Trioangle Product Team
 * @version - Stable 1.0
 * @link http://trioangle.com
 */

#import "MyCustomPinAnnotationView.h"

@implementation MyCustomPinAnnotationView

- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation
{
    // The re-use identifier is always nil because these custom pins may be visually different from one another
    self = [super initWithAnnotation:annotation
                     reuseIdentifier:nil];
    
    // Fetch all necessary data from the point object
    MyCustomPointAnnotation* myCustomPointAnnotation = (MyCustomPointAnnotation*) annotation;
    
    
    self.price = myCustomPointAnnotation.price;
    NSArray *arr = [self.price componentsSeparatedByString:@"-"];
    // Callout settings - if you want a callout bubble
    self.canShowCallout = YES;
    self.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    self.image = [UIImage imageNamed:@"map_price.png"];
    
    UIButton* label = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 59, 30)];
//    label.textAlignment = NSTextAlignmentCenter;
    label.titleLabel.textColor =  [UIColor blackColor];
    [label setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [label setTitle:[self.price componentsSeparatedByString:@"-"].firstObject forState:UIControlStateNormal];
    label.titleLabel.text = [self.price componentsSeparatedByString:@"-"].firstObject;
    label.titleLabel.font = [UIFont fontWithName:@"CircularAirPro-Book" size:12];
    [label addTarget:self action:@selector(onButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    NSString *str = arr[1];
    label.tag = str.integerValue;

    if ([arr[2] isEqualToString:@"Yes"])
    {
        UILabel *instantbook = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 59, 30)];
        instantbook.textColor =  [UIColor colorWithRed:255.0/255.0 green:180.0/255.0 blue:0.0/255.0 alpha:1.0];
        instantbook.text = @"G";
        instantbook.textAlignment = NSTextAlignmentRight;
        instantbook.font = [UIFont fontWithName:@"makent1" size:12];
        [self addSubview:instantbook];
    }
//    "G"
//    label.titleLabel.textColor = (selectedIndex == [self.price componentsSeparatedByString:@"-"].lastObject.integerValue) ?  [UIColor whiteColor] : [UIColor blackColor];
//    [label setTitleColor:(selectedIndex == [self.price componentsSeparatedByString:@"-"].lastObject.integerValue) ?  [UIColor whiteColor] : [UIColor blackColor] forState:UIControlStateNormal];

    
    [self addSubview:label];

    
    return self;
}

-(void)onButtonTapped:(UIButton *)sender
{
    selectedIndex = sender.tag;
    [self.upDelegate uploadDidfinish:sender.tag];
}


- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent*)event
{
    UIView* hitView = [super hitTest:point withEvent:event];
    if (hitView != nil)
    {
        [self.superview bringSubviewToFront:self];
    }
    return hitView;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event
{
    CGRect rect = self.bounds;
    BOOL isInside = CGRectContainsPoint(rect, point);
    if(!isInside)
    {
        for (UIView *view in self.subviews)
        {
            isInside = CGRectContainsPoint(view.frame, point);
            if(isInside)
                break;
        }
    }
    return isInside;
}

@end
