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
    C4Movie *g;
    C4Movie *d;
    C4Sample *audioOne, *audioTwo;
    BOOL canMoveOverlayMovie;
}

@synthesize a, mask;

-(void)setup {
    
    audioOne = [C4Sample sampleNamed:@"redsea.m4a"];
    [audioOne prepareToPlay];
    [audioOne play];
    audioOne.loops = YES;
    
    canMoveOverlayMovie = NO;
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
    longPress.minimumPressDuration = 0.5f;
    [self.canvas addGestureRecognizer:longPress];
    
    self.a = [C4Movie alloc];
    
    b = [C4Movie movieNamed:@"RedSeaBefore1080.mov"];
    b.alpha = 0.8;
    b.height = 768;
    b.transform = CGAffineTransformMakeRotation(HALF_PI);
    b.userInteractionEnabled = NO;
    b.loops = YES;
    b.origin = CGPointZero;
    [self.canvas addMovie:b];
    
    NSArray *imageNames = [NSArray arrayWithObjects:
                           @"testmask.png",
                           @"2.png",
                           @"3.png",
                           @"4.png",
                           @"5.png",
                           @"6.png",
                           @"7.png",
                           @"8.png",
                           @"9.png",
                           @"10.png",
                           @"9.png",
                           @"8.png",
                           @"7.png",
                           @"6.png",
                           @"5.png",
                           @"4.png",
                           @"3.png",
                           @"2.png",
                           @"1.png",
                           nil];
    self.mask = [C4Image animatedImageWithNames:imageNames];
    [self.mask play];
    
    self.mask.origin = CGPointMake(0, 0);
    self.mask.userInteractionEnabled = NO;
    
    d = [C4Movie movieNamed:@"Ocean6.mp4"];
    //d.height = 768;
    d.height = 2000;
    d.transform = CGAffineTransformMakeRotation(HALF_PI);
    d.userInteractionEnabled = NO;
    d.loops = YES;
    d.center = CGPointMake(0,0);
    //d.origin = CGPointZero;
    [self.canvas addMovie:d];
    d.alpha = 0.1;
    
    g = [C4Movie movieNamed:@"RedSeaBeforeglitch1080.mov"];
    g.height = 768;
    g.transform = CGAffineTransformMakeRotation(HALF_PI);
    g.userInteractionEnabled = NO;
    g.loops = YES;
    g.origin = CGPointZero;
    [self.canvas addMovie:g];
    g.alpha = 0.0;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    g.alpha = 0.5;
    
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
    //if(location.y < 512) 
        //self.a = [self.a initWithMovieName:@"waterfall2.mp4"];
    //else 
        //self.a = [self.a initWithMovieName:@"waterfall2.mp4"];
    
    self.a = [self.a initWithMovieName:@"pan1080.mov"];
    a.alpha = 1.0;
    
    self.a.height = 768;
    self.a.transform = CGAffineTransformMakeRotation(HALF_PI);
    self.a.userInteractionEnabled = NO;
    self.a.loops = YES;
    //location.y -= 750;
    location.y -= 1024;
    location.x = 0;
    self.a.origin = location;
    
    self.a.layer.mask = self.mask.layer;
    [self.canvas addMovie:self.a];
    canMoveOverlayMovie = YES;
    
    audioTwo = [C4Sample sampleNamed:@"loud.m4a"];
    [audioTwo prepareToPlay];
    [audioTwo play];
    audioTwo.loops = NO;
    audioTwo.volume = 1.0;
    
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
            audioTwo.volume = 0.0;
            g.alpha = 0;
            [self removeMovie];
            [self.a performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:1.0f];
            break;
        default:
            break;
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    canMoveOverlayMovie = NO;
    audioTwo.volume = 0.0;
    g.alpha = 0;
    [self removeMovie];
}

-(void)removeMovie {
    canMoveOverlayMovie = NO;
    [self.a performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:1.0f];
}

@end
