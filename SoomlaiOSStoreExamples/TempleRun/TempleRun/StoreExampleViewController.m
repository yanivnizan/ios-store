/*
 * Copyright (C) 2012 Soomla Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "StoreExampleViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "StorefrontController.h"
#import "EventHandling.h"

@interface StoreExampleViewController (){
    BOOL dragging;
    BOOL onDropZone;
}
@end

@implementation StoreExampleViewController

@synthesize titleLabel, infoLabel, logoImageView, leftView, rightView, rightBg;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [titleLabel setFont:[UIFont fontWithName:@"GoodDog" size:50]];
    [infoLabel setFont:[UIFont fontWithName:@"GoodDog" size:20]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closingStore:) name:EVENT_CLOSING_STORE object:nil];
    
    rightView.layer.cornerRadius = 7;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

- (void)closingStore:(NSNotification*)notification{
    [rightBg setImage:[UIImage imageNamed:@"right_bg.png"]];
    [leftView addSubview:logoImageView];
    [leftView bringSubviewToFront:logoImageView];
    logoImageView.frame = CGRectMake(0, 0, logoImageView.frame.size.width, logoImageView.frame.size.height);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([touches count] == 1) {
        // one finger
        CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
        if ([self isPoint:touchPoint OnView:leftView]){
            dragging = YES;
            logoImageView.center = [[touches anyObject] locationInView:leftView];
            [self.view bringSubviewToFront:leftView];
            [self.view bringSubviewToFront:logoImageView];
        }
    }
}

- (BOOL)isPoint:(CGPoint)point OnView:(UIView*)view{
    return point.x > view.frame.origin.x &&
    point.x < view.frame.origin.x + view.frame.size.width &&
    point.y > view.frame.origin.y &&
    point.y < view.frame.origin.y + view.frame.size.height;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (dragging){
        logoImageView.center = [[touches anyObject] locationInView:leftView];
        CGPoint touchPoint = [[touches anyObject] locationInView:self.view];

        BOOL pointOnView = [self isPoint:touchPoint OnView:rightView];
        if (pointOnView && !onDropZone)
        {
            onDropZone = YES;
            [rightBg setImage:[UIImage imageNamed:@"right_bg_hover.png"]];
        }
        else if (!pointOnView && onDropZone){
            onDropZone = NO;
            [rightBg setImage:[UIImage imageNamed:@"right_bg.png"]];
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    dragging = NO;
    CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
    if ([self isPoint:touchPoint OnView:rightView])
    {
        [rightView addSubview:logoImageView];
        [rightView bringSubviewToFront:logoImageView];
        logoImageView.frame = CGRectMake(0, 0, logoImageView.frame.size.width, logoImageView.frame.size.height);
        
        /** Opening storefront **/
        
        NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"temple" ofType:@"json"];
        NSString *json = [NSString stringWithContentsOfFile:jsonPath encoding:NSUTF8StringEncoding error:nil];
        
        [[StorefrontController getInstance] openStoreWithParentViewController:self andStorefrontInfoJSON:json];
    }
    else{
        logoImageView.frame = CGRectMake(0,0,
                                       logoImageView.frame.size.width,
                                       logoImageView.frame.size.height);
    }
}

@end
