//
//  C4WorkSpace.m
//  animatedVideoMask
//
//  Created by Travis Kirton on 12-05-24.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "C4WorkSpace.h"

@interface C4WorkSpace ()
-(void)createOverlayMovie:(CGPoint)location;
-(void)handleLongPressGesture:(id)sender;
-(void)removeMovie;
@property (readwrite, strong) C4Movie *a;
@property (readwrite, strong) C4Image *mask;

@end

@implementation C4WorkSpace {
    C4Movie *b;
    BOOL canMoveOverlayMovie;
}

@synthesize a, mask;

-(void)setup {
    canMoveOverlayMovie = NO;
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
    longPress.minimumPressDuration = 2.0f;
    [self.canvas addGestureRecognizer:longPress];
    
    self.a = [C4Movie alloc];
    
    b = [C4Movie movieNamed:@"RedSeaBefore1080.mov"];
    b.height = 768;
    b.transform = CGAffineTransformMakeRotation(HALF_PI);
    b.userInteractionEnabled = NO;
    b.loops = YES;
    b.origin = CGPointZero;
    [self.canvas addMovie:b];
    
    NSArray *imageNames = [NSArray arrayWithObjects:
                           @"mask01.png",
                           @"mask02.png",
                           @"mask03.png",
                           @"mask04.png",
                           @"mask05.png",
                           @"mask06.png",
                           @"mask07.png",
                           @"mask08.png",
                           @"mask09.png",
                           @"mask10.png",
                           @"mask09.png",
                           @"mask08.png",
                           @"mask07.png",
                           @"mask06.png",
                           @"mask05.png",
                           @"mask04.png",
                           @"mask03.png",
                           @"mask02.png",
                           @"mask01.png",
                           nil];
    self.mask = [C4Image animatedImageWithNames:imageNames];
    [self.mask play];
    
    self.mask.origin = CGPointMake(0, 0);
    self.mask.userInteractionEnabled = NO;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //    a.animationDuration = 0.05;
    //    CGPoint newOrigin = [[touches anyObject] locationInView:self.canvas];
    //    newOrigin.x = 0;
    //    newOrigin.y -= 1024;
    //    if(newOrigin.y < -1024) newOrigin.y = -1024;
    //    
    //    a.animationDuration = 1.0;
    //    b.animationDuration = 1.0f;
    //    a.origin = newOrigin;
    //    b.origin = newOrigin;
    
    //    newOrigin.x -= 1024;
    //    mask.origin = newOrigin;
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    //    if(canMoveOverlayMovie) {
    //    CGPoint newOrigin = [[touches anyObject] locationInView:self.canvas];
    //    newOrigin.y = 768-1*newOrigin.x;
    //    newOrigin.x = 0;
    ////    newOrigin.x -= 1024;
    //    mask.origin = newOrigin;
    //    }
}

-(void)createOverlayMovie:(CGPoint)location {
    //    self.a = [C4Movie movieNamed:@"RedSeaBeforeglitch1080.mov"];
    C4Log(@"(%4.2f,%4.2f)",location.x,location.y);
    if(location.y < 512) 
        self.a = [self.a initWithMovieName:@"RedSeaBefore1080.mov"];
    else 
        self.a = [self.a initWithMovieName:@"RedSeaBeforeglitch1080.mov"];
    self.a.height = 768;
    self.a.transform = CGAffineTransformMakeRotation(HALF_PI);
    self.a.userInteractionEnabled = NO;
    self.a.loops = YES;
    location.y -= 1024;
    location.x = 0;
    self.a.origin = location;
    
    self.a.layer.mask = self.mask.layer;
    [self.canvas addMovie:self.a];
    canMoveOverlayMovie = YES;
}

-(void)handleLongPressGesture:(id)sender {
    UILongPressGestureRecognizer *lp = (UILongPressGestureRecognizer *)sender;
    CGPoint p;
    switch (lp.state) {
        case UIGestureRecognizerStateBegan:
            [self createOverlayMovie:[lp locationInView:self.canvas]];
            C4Log(@"start");
            break;
        case UIGestureRecognizerStateChanged:
            if(canMoveOverlayMovie == YES) {
                p = [lp locationInView:self.canvas];
                p.y = 768-1*p.x;
                p.x = 0;
                mask.origin = p;
            }
            break;
        case UIGestureRecognizerStateEnded:
            C4Log(@"ended");
            [self removeMovie];
            break;
        default:
            break;
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    canMoveOverlayMovie = NO;
}

-(void)removeMovie {
    canMoveOverlayMovie = NO;
    [self.a performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:1.0f];
}

@end
