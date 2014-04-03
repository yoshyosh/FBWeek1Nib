//
//  NewsfeedViewController.m
//  FBWeek1Nib
//
//  Created by Joseph Anderson on 4/1/14.
//  Copyright (c) 2014 yoshyosh. All rights reserved.
//

#import "NewsfeedViewController.h"

@interface NewsfeedViewController ()

@property (strong, nonatomic) IBOutlet UIView *postBackgroundView;
@property (strong, nonatomic) IBOutlet UITextField *commentTextField;
@property (strong, nonatomic) IBOutlet UILabel *peopleWhoLikedLabel;
@property (strong, nonatomic) IBOutlet TTTAttributedLabel *postBodyText;

-(void)willShowKeyboard:(NSNotification *)notification;
-(void)willHideKeyboard:(NSNotification *)notification;

@end

@implementation NewsfeedViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willShowKeyboard:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willHideKeyboard:) name:UIKeyboardWillHideNotification object:nil];
        
    }
    return self;
}

- (void)willShowKeyboard:(NSNotification *)notification{
    NSDictionary *userInfo = [notification userInfo];
    
    CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    NSLog(@"Height: %f Width: %f", kbSize.height, kbSize.width);
    
    NSNumber *durationValue = userInfo[UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration = durationValue.doubleValue;
    NSNumber *curveValue = userInfo[UIKeyboardAnimationCurveUserInfoKey];
    UIViewAnimationCurve animationCurve = curveValue.intValue;
    
    [UIView animateWithDuration:animationDuration delay:0.0 options:(animationCurve << 16) animations:^{self.commentTextField.frame = CGRectMake(-10, self.view.frame.size.height - kbSize.height - self.commentTextField.frame.size.height, self.commentTextField.frame.size.width, self.commentTextField.frame.size.height);
    } completion:nil];
    NSLog(@"Textfield height: %f Frame height: %f", self.commentTextField.frame.size.height, self.view.frame.size.height);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Post";
    self.view.backgroundColor = [[UIColor alloc] initWithRed:211.0/255.0 green:214.0/255.0 blue:219.0/255.0 alpha:1.0];
    self.postBackgroundView.backgroundColor = [UIColor whiteColor];
    self.postBackgroundView.layer.cornerRadius = 2;
    
    //Set bold for people who liked, need to make the range dynamic though
    NSString *text = self.peopleWhoLikedLabel.text;
    
    if ([self.peopleWhoLikedLabel respondsToSelector:@selector(setAttributedText:)]) {
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text];
        [attributedText setAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]} range:NSMakeRange(0, 5)];
        self.peopleWhoLikedLabel.attributedText = attributedText;
    } else {
        self.peopleWhoLikedLabel.text = text;
    }
    
    TTTAttributedLabel *label = self.postBodyText;
    label.font = [UIFont systemFontOfSize:14.0];
    label.textColor = [UIColor blackColor];
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.numberOfLines = 4;
    label.enabledTextCheckingTypes = NSTextCheckingTypeLink;
    label.delegate = self;
    
    NSRange range = [label.text rangeOfString:@"http://bit.ly/1jV9zM8"];
    [label addLinkToURL:[NSURL URLWithString:@"http://bit.ly/1jV9zM8"] withRange:range];
    
//    [label setText:postBodyText afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
//        NSRange boldRange = [[mutableAttributedString string] rangeOfString:@"Casey Storm" options:NSCaseInsensitiveSearch];
//        
//        UIFont *boldSystemFont = [UIFont boldSystemFontOfSize:14.0];
//        CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)boldSystemFont.fontName, boldSystemFont.pointSize, NULL);
//        if (font) {
//            [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:boldRange];
//            CFRelease(font);
//        }
//        return mutableAttributedString;
//    }];
//    self.postBodyText.text = label.text;
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
