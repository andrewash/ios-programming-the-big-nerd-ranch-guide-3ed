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
    [[UIColor lightGrayColor] setStroke];
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
    
    // Create a string
    NSString *text = @"You will soon get laid.";
    
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
    
    // Set the shadow of hte context with these parameters,
    //  all subsequent drawings will be shadowed
    CGContextSetShadowWithColor(ctx, offset, 2.0, colour);
    
    // Draw the string
    [text drawInRect:textRect
            withFont:font];
}


@end
