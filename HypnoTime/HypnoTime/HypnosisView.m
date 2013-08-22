//
//  HypnosisView.m
//  Hypnosister
//
//  Created by aash on 2013-02-25.
//  Copyright (c) 2013 Zen Mensch Apps. All rights reserved.
//

#import "HypnosisView.h"

@implementation HypnosisView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // All HypnosisViews start with a clear background color
        [self setBackgroundColor:[UIColor clearColor]];
        [self setCircleColour:[UIColor lightGrayColor]];
        
        // Create the new layer object
        boxLayer = [[CALayer alloc] init];
        
        // Give it a size
        [boxLayer setBounds:CGRectMake(0.0, 0.0, 85.0, 85.0)];
        
        // Give it a location
        [boxLayer setPosition:CGPointMake(160.0, 100.0)];
        
        // Make half-transparent red the background color for the layer
        UIColor *reddish = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.5];
        
        // Get a CGColor object with the same color values
        CGColorRef cgReddish = [reddish CGColor];
        [boxLayer setBackgroundColor:cgReddish];
        
        // Create a UIImage
        UIImage *layerImage = [UIImage imageNamed:@"Hypno.png"];
        
        // Get the underlying CGImage
        CGImageRef image = [layerImage CGImage];
        
        // Put the CGImage on the layer
        [boxLayer setContents:(__bridge id)image];  // tricky to remember!
        
        // Inset the image a bit on each side
        [boxLayer setContentsRect:CGRectMake(-0.1, -0.1, 1.2, 1.2)];
        
        // Let the image resize (without changing the aspect ratio) to fill the contentRect
        [boxLayer setContentsGravity:kCAGravityResizeAspect];
        
        // Make it a sublayer of the view's layer
        [[self layer] addSublayer:boxLayer];
    }
    
    return self;
}

- (void)drawRect:(CGRect)dirtyRect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect bounds = [self bounds];
    
    // Figure out the centre of the bounds rectangle
    CGPoint centre;
    centre.x = bounds.origin.x + bounds.size.width / 2.0;
    centre.y = bounds.origin.y + bounds.size.height / 2.0;
    
    // The radius of the circle should be nearly as big as the view
    float maxRadius = hypot(bounds.size.width, bounds.size.height) / 2.0;
    
    // The thickness of the line should be 10 points wide
    CGContextSetLineWidth(ctx, 10);
    
    // The color of the line should be gray (red/gren/blue = 0.6, alpha = 1.0)
    [[self circleColour] setStroke];
    
    // [[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1.0] setStroke];
    // CGContextSetRGBStrokeColor(ctx, 0.6, 0.6, 0.6, 1.0);
    // ^^^ note to self: a good example of how Objective-C's message-selector syntax actually makes things clearer
    //      vs. functions. You can see the names of each parameter (red, green, etc.), not just the values I happen to be passing.
    //      those values could represent anything! Objective-C is more clear! Yay!  (OBJ: Is it too verbose?? Time will tell.)
    
    // Draw concentric circles from the outside in
    for (float currentRadius = maxRadius; currentRadius > 0; currentRadius -= 20)
    {
        // Add a path to the context
        CGContextAddArc(ctx, centre.x, centre.y, currentRadius, 0.0, M_PI * 2.0, YES);
        
        // Perform drawing instruction; removes path
        CGContextStrokePath(ctx);
    }
    
    //------------------------------------------------------------------------------------
    // Assignment #2, Q3 (Ch. 6, Silver Challenge)
    //   saves (aspects of) current context as a "graphics state" before we start drawing text
    //     b/c before drawing text we set a shadow, which affects all future paths within that context
    CGContextSaveGState(ctx);
    //====================================================================================
    
    // Create a string
    NSString *text = @"You are getting sleepy.";
    
    // Get a font to draw it in
    UIFont *font = [UIFont boldSystemFontOfSize:28];
    
    CGRect textRect;
    
    // How big is this string when drawn in this font?
    textRect.size = [text sizeWithFont:font];
    
    // Let's put that string in the centre of the view
    textRect.origin.x = centre.x - textRect.size.width / 2.0;
    textRect.origin.y = centre.y - textRect.size.height / 2.0;
    
    // Set the fill colour of the current context to black
    [[UIColor blackColor] setFill];
    
    // The shadow will move 4 points to the right, and 3 points down from the text
    CGSize offset = CGSizeMake(4, 3);
    
    // The shadow will be dark gray in color
    CGColorRef colour = [[UIColor darkGrayColor] CGColor];
    
    // Set the shadow of the context with these parameters,
    //  all subsequent drawings will be shadowed
    CGContextSetShadowWithColor(ctx, offset, 2.0, colour);
    
    // Draw the string
    [text drawInRect:textRect
            withFont:font];
    
    //------------------------------------------------------------------------------------
    // Assignment #2, Q3 (Ch. 6, Silver Challenge)
    //   define a path to represent "crosshairs", in centre of view. Looks like a + symbol, in green, with no shadow.
    //   must be drawn on top of text
    float radiusOfCrosshair = (bounds.size.width / 4.0) / 2.0;
    
    // Restore the most recently saved "graphics state" over the current context; Text must be drawn beforehand.
    CGContextRestoreGState(ctx);
    
    // Set attributes of this shape/path
    colour = [[UIColor greenColor] CGColor];
    CGContextSetStrokeColorWithColor(ctx, colour);
    CGContextSetLineWidth(ctx, 5);
    

    // Draw the crosshairs as 1 horizontal line
    CGContextMoveToPoint(ctx, centre.x - radiusOfCrosshair, centre.y);
    CGContextAddLineToPoint(ctx, centre.x + radiusOfCrosshair, centre.y);
    // ... and 1 vertical line, intersecting at the centre
    CGContextMoveToPoint(ctx, centre.x, centre.y - radiusOfCrosshair);
    CGContextAddLineToPoint(ctx, centre.x, centre.y + radiusOfCrosshair);
    
    // Perform drawing instruction; removes path
    CGContextStrokePath(ctx);
    //====================================================================================
}

// FYI - a responder object must explicitly state that it is willing to become the first responder.
- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake) {
        NSLog(@"Device started shaking!");
        [self setCircleColour:[UIColor redColor]];
    }
}

// boxLayer will move to wherever the user starts to touch, in a smooth animation.
- (void)touchesBegan:(NSSet *)touches
           withEvent:(UIEvent *)event
{
    UITouch *t = [touches anyObject];
    CGPoint p = [t locationInView:self];
    [boxLayer setPosition:p];
}

- (void)touchesMoved:(NSSet *)touches
           withEvent:(UIEvent *)event
{
    UITouch *t = [touches anyObject];
    CGPoint p = [t locationInView:self];
    [CATransaction begin];
    [CATransaction setDisableActions:YES];  // while moving your finger around the screen, previous animations (For previous positions of your finger) are cancelled. Only the most recent animation will run to completion.
    [boxLayer setPosition:p];
    [CATransaction commit];
}

- (void)setCircleColour:(UIColor *)clr
{
    _circleColour = clr;
    [self setNeedsDisplay];
}
@end
