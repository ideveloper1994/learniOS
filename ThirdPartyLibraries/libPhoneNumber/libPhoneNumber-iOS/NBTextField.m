//
//  NBTextField.m
//  Doxper
//
//  Created by devloper65 on 12/3/16.
//  Copyright © 2016 Manoj. All rights reserved.
//

#import "NBTextField.h"

@implementation NBTextField
{
    NBPhoneNumberUtil *phoneNumberUtility;
    NBAsYouTypeFormatter *phoneNumberFormatter;
    BOOL shouldCheckValidationForInputText;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {        
    }
    return self;
}
-(void)applyRegioncode:(NSString *)regioCode{
    phoneNumberUtility = [[NBPhoneNumberUtil alloc]init];
    phoneNumberFormatter = [[NBAsYouTypeFormatter alloc]init];
    [self registerForNotification];
    phoneNumberFormatter = [[NBAsYouTypeFormatter alloc]initWithRegionCode:regioCode];
}
-(void)registerForNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(numberTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
}
-(void)numberTextDidChange:(NSNotification *) notification{
    shouldCheckValidationForInputText = YES;
    NSString *numbersOnly = [phoneNumberUtility normalize:self.text];
    self.text = [phoneNumberFormatter inputStringAndRememberPosition:numbersOnly];
    if(phoneNumberFormatter.isSuccessfulFormatting == NO && shouldCheckValidationForInputText)
    {
        [self shakeIt];
    }
}
-(void)placeholderStyle {
    if(self.placeholder.length) {
        self.attributedPlaceholder = [[NSAttributedString alloc]
                                      initWithString:
                                      self.placeholder
                                      attributes:@{NSForegroundColorAttributeName: [UIColor redColor]}];
    }
}
-(void)shakeIt{
   // CGFloat offset = self.bounds.size.width / 30;
    CABasicAnimation *animation = [[CABasicAnimation alloc]init];
    animation.keyPath = @"position";
    animation.duration = 0.07;
    animation.repeatCount = 2;
    animation.autoreverses = YES;
    animation.fromValue = [NSNumber numberWithFloat:749.0f / 2];
    animation.toValue = [NSNumber numberWithFloat:749.0f];
    [self.layer addAnimation:animation forKey:@"position"];
}
@end
