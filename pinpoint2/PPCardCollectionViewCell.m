//
//  PPCardCollectionViewCell.m
//  pinpoint2
//
//  Created by Philip Hardwick on 26/06/2014.
//  Copyright (c) 2014 Philip Hardwick. All rights reserved.
//

#import "PPCardCollectionViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation PPCardCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)configureCard {
    NSString *baseUrlPath = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:baseUrlPath];
    [self.webView loadHTMLString:self.card.html baseURL:baseURL];
    //[self.webView.scrollView setScrollEnabled:NO];
    [self.webViewLoadingIndicator startAnimating];
    [self setUpCardLook];
}

- (void)setUpCardLook {
    [[self contentView] setBackgroundColor:[UIColor whiteColor]];
    [self setBackgroundColor:[UIColor clearColor]];
    CALayer *contentViewlayer = [[self contentView] layer];
    CALayer *celllayer = [self layer];
    [contentViewlayer setMasksToBounds:YES];
    [contentViewlayer setCornerRadius:2.0f];
    [contentViewlayer setRasterizationScale:[[UIScreen mainScreen] scale]];
    [contentViewlayer setShouldRasterize:YES];
    [celllayer setShadowColor:[[UIColor blackColor] CGColor]];
    [celllayer setShadowOffset:CGSizeMake(0.0f, 0.0f)];
    [celllayer setShadowRadius:6.0f];
    [celllayer setShadowOpacity:0.3f];
    [celllayer setShadowPath:[[UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:2.0f] CGPath]];
}

- (void)undoDelete {
    [self setDeleted:NO];
    CGAffineTransform transform = CGAffineTransformIdentity;
    [[self contentView] setTransform:transform];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.webViewLoadingIndicator stopAnimating];
    [self.webViewLoadingIndicator setHidden:YES];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        // Create a pan gesture recognizer with self set as the delegate and add it the cell
        _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizerDidChange:)];
        [_panGestureRecognizer setDelegate:self];
        [self addGestureRecognizer:_panGestureRecognizer];
        
        // Don't clip to bounds since we want the content view to be visible outside the bounds of the cell
        [self setClipsToBounds:NO];
        
        // For debugging purposes only: set the color of the content view
    }
    return self;
}

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)panGestureRecognizer {
    CGPoint velocity = [panGestureRecognizer velocityInView:self];
    return fabs(velocity.x) > fabs(velocity.y);
}

- (void)panGestureRecognizerDidChange:(UIPanGestureRecognizer *)panGestureRecognizer {
    if ([self isDeleted]) {
        // The cell should be deleted, leave the state of the cell as it is
        NSLog(@"cell deleted");
        return;
    }
    
    // Percent holds a float value between -1 and 1 that indicates how much the user moved his finger relative to the width of the cell
    CGFloat percent = [panGestureRecognizer translationInView:self].x / [self frame].size.width;
    
    switch ([panGestureRecognizer state]) {
        case UIGestureRecognizerStateChanged: {
            // Create the 'throw animation' and base its current state on the percent
            CGAffineTransform moveTransform = CGAffineTransformMakeTranslation(percent * [self frame].size.width, 0.f);
            CGAffineTransform rotateTransform = CGAffineTransformMakeRotation(percent * M_PI / 20.f);
            CGAffineTransform transform = CGAffineTransformConcat(moveTransform, rotateTransform) ;
            
            // Apply the transformation to the content view
            [self setTransform:transform];
            
            break;
        }
            
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            // Delete the current cell if the absolute value of the percent is above O.7 or the absolute value of the velocity of the gesture is above 600
            if (fabsf(percent) > 0.7f || fabsf([panGestureRecognizer velocityInView:self].x) > 600.f) {
                // The direction is -1 if the gesture is going left and 1 if it's going right
                CGFloat direction = percent < 0.f ? -1.f : 1.f;
                // Multiply the direction to make sure the content view will be removed entirely from the screen
                direction *= 2.0f;
                
                // Create the transform based on the direction of the gesture
                CGAffineTransform moveTransform = CGAffineTransformMakeTranslation(direction * [self frame].size.width , 0.f);
                CGAffineTransform rotateTransform = CGAffineTransformMakeRotation(direction * M_PI / 20.f);
                CGAffineTransform transform = CGAffineTransformConcat(moveTransform, rotateTransform);
                
                // Calculate the duration of the animation based on the velocity of the pan gesture recognizer and normalize abnormal high and low values
                CGFloat duration = fabsf(1000.f / [panGestureRecognizer velocityInView:self].x);
                duration = duration > 2.f  ? duration = 2.f  : duration;
                //duration = duration < 0.2f ? duration = 0.2f : duration;
                
                // Animate the 'throwing away' of the cell and update the collection view once it's completed
                [UIView animateWithDuration:duration
                                 animations:^(){
                                     [self setTransform:transform];
                                 }
                                 completion:^(BOOL finished){
                                     [self setDeleted:YES];
                                     if (direction < 0.0f) {
                                         [self.cardActionDelegate cardWasSwipedLeft:self];
                                     } else {
                                         [self.cardActionDelegate cardWasSwipedRight:self];
                                     }
                                 }];
                
            } else {
                // The cell shouldn't be deleted: animate the content view back to its original position
                [UIView animateWithDuration:.3f animations:^(){
                    [self setTransform:CGAffineTransformIdentity];
                }];
            }
            
            break;
        }
            
        default: {
            NSLog(@"Other case: %ld",[panGestureRecognizer state]);
            break;
        }
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    // Return YES to make sure the pan gesture recognizer doesn't interfere with the gesture recognizer of the collection view
    return YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
