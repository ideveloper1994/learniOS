//
//  NBTextField.h
//  Doxper
//
//  Created by devloper65 on 12/3/16.
//  Copyright © 2016 Manoj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "libPhoneNumberiOS.h"

@interface NBTextField : UITextField
-(void)placeholderStyle;
-(void)applyRegioncode:(NSString *)regioCode;
@end
