//
//  NJLoadScene.m
//  NinjaJump
//
//  Created by Wang Yichao on 23/3/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import "NJLoadScene.h"

@interface NJLoadScene ()

@end

@implementation NJLoadScene {
    bool loadAnimationFlag;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    loadAnimationFlag = YES;
    self.navigationController.navigationBarHidden = YES;
    if (loadAnimationFlag) {
        [self shineLogo];
        [self incrementLoadbar];
    } else{
        [self performSegueWithIdentifier: @"SegueToMainScene"
                                  sender: self];
    }
}


- (void)shineLogo{
    [UIView animateWithDuration:1.0f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         [UIView setAnimationRepeatCount:3];
                         _light.alpha = 1.0f;
                         _light.alpha = 0.0f;
                         
                     }
                     completion:^(BOOL finished) {
                         [self performSegueWithIdentifier: @"SegueToMainScene"
                                                   sender: self];
                     }];
}

- (void)shinningAnimationStopped:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context{
    [self performSegueWithIdentifier: @"SegueToMainScene"
                              sender: self];
}

- (void) incrementLoadbar{
    // Create a mask layer and the frame to determine what will be visible in the view.
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    CGRect maskRect = CGRectMake(-800, 0, 1000, 768);
    CGPathRef path = CGPathCreateWithRect(maskRect, NULL);
    maskLayer.path = path;
    // Release the path since it's not covered by ARC.
    CGPathRelease(path);
    _loadingBar.layer.mask = maskLayer;

    CGPoint newPos = CGPointMake(1000, 0);
    [self moveLayer: maskLayer to:newPos];
    
}

-(void)moveLayer:(CALayer*)layer to:(CGPoint)point{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.fromValue = [layer valueForKey:@"position"];
    animation.toValue = [NSValue valueWithCGPoint:point];
    animation.duration = 4.0;
    layer.position = point;
    [layer addAnimation:animation forKey:@"position"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
