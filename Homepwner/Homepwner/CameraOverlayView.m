//
//  CameraOverlayView.m  -- Ch. 12, GOLD CHALLENGE
//  Homepwner

#import "CameraOverlayView.h"

@implementation CameraOverlayView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // clear background
        [self setBackgroundColor:[UIColor clearColor]];
        [self setOverlayColour:[UIColor lightGrayColor]];
    }
    return self;
}

// Draw a set of crosshairs & circle in middle of hte image capture area
- (void)drawRect:(CGRect)dirtyRect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect bounds = [self bounds];
    
    // Figure out the centre of the bounds rectangle
    CGPoint centre;
    centre.x = bounds.origin.x + bounds.size.width / 2.0;
    centre.y = bounds.origin.y + bounds.size.height / 2.0;
    

    float radiusOfCrosshair = hypot(bounds.size.width, bounds.size.height) / 4;
    
    // Set attributes of this shape/path
        // warning: changing these attributes anytime before CGContextStrokePath() will modify all strokes drawn in this path!
    [[self overlayColour] setStroke];
    CGContextSetLineWidth(ctx, 3);
    
    // Draw the crosshairs as 1 horizontal line
    CGContextMoveToPoint(ctx, centre.x - radiusOfCrosshair, centre.y);
    CGContextAddLineToPoint(ctx, centre.x + radiusOfCrosshair, centre.y);
    // ... and 1 vertical line, intersecting at the centre
    CGContextMoveToPoint(ctx, centre.x, centre.y - radiusOfCrosshair);
    CGContextAddLineToPoint(ctx, centre.x, centre.y + radiusOfCrosshair);
    
    // and a circle (thanks to my neighbour for the good visual idea)
    CGContextMoveToPoint(ctx, centre.x, centre.y);
    CGContextAddArc(ctx, centre.x, centre.y, radiusOfCrosshair, 0.0, M_PI * 2.0, YES);
    // Perform drawing instruction; removes path
    CGContextStrokePath(ctx);
    //====================================================================================
}

// Ensure UIView is redrawn when the overlayColour changes (not really needed in this case)
- (void)setOverlayColour:(UIColor *)clr
{
    _overlayColour = clr;
    [self setNeedsDisplay];
}


@end
