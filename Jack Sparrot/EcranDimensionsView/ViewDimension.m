//
//  ViewDimension.m
//  Jack Sparrot
//
//  Created by Nicolas Salleron on 28/02/2017.
//
//

#import "ViewDimension.h"
#import "ViewDimensionViewController.h"

@implementation ViewDimension

- (id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if(self){
        NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight];
        [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
        
        /* Boutons */
        _btn1D = [[UIButton alloc] init];
        _btn2D  = [[UIButton alloc] init];
        _btn3D  = [[UIButton alloc] init];
   
        
        [_btn1D setTitle:@"1D" forState:UIControlStateNormal];
        [_btn2D setTitle:@"2D" forState:UIControlStateNormal];
        [_btn3D setTitle:@"3D" forState:UIControlStateNormal];
        
        [_btn1D setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_btn2D setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_btn3D setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [[_btn1D layer] setBorderWidth:1.0f];
        [[_btn1D layer] setBorderColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor];
        [[_btn1D layer] setCornerRadius:8.0f];
        [[_btn1D layer] setBorderWidth:2.0f];
        
        [[_btn2D layer] setBorderWidth:1.0f];
        [[_btn2D layer] setBorderColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor];
        [[_btn2D layer] setCornerRadius:8.0f];
        [[_btn2D layer] setBorderWidth:2.0f];
        
        [[_btn3D layer] setBorderWidth:1.0f];
        [[_btn3D layer] setBorderColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor];
        [[_btn3D layer] setCornerRadius:8.0f];
        [[_btn3D layer] setBorderWidth:2.0f];
        
        [_btn1D addTarget:self.superview action:@selector(endDimensionChoice:) forControlEvents:UIControlEventTouchUpInside];
        [_btn2D addTarget:self.superview action:@selector(endDimensionChoice:) forControlEvents:UIControlEventTouchUpInside];
        [_btn3D addTarget:self.superview action:@selector(endDimensionChoice:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_btn1D];
        [self addSubview:_btn2D];
        [self addSubview:_btn3D];

        
    }
    
    return self;
}

- (void)updateView:(CGSize)format{
    
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
    {
        NSLog(@"Landscape");
        /* Mise en place des labels */
        [_btn1D setFrame:CGRectMake(0,0,format.width/3,format.height)];
        
        [_btn2D setFrame:CGRectMake(format.width/3,0,format.width/3,format.height)];
        
        [_btn3D setFrame:CGRectMake(2*format.width/3,0,format.width/3,format.height)];
        
    }   
    
    
}


-(void) drawRect:(CGRect)rect{
    [self updateView:rect.size];
}


@end
