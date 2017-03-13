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

- (void) colors{
    
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"1D"];
    
    if (colorData != nil) {
        
        self.color1D = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
        colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"2D"];
        if (colorData != nil) {
            self.color2D = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
        }
        colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"3D"];
        if (colorData != nil) {
            self.color3D = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
        }
    }else{ // Mise en place des couleurs par défaut.
        
        self.color1D = [[UIColor alloc] initWithRed:26/255.0 green:188/255.0 blue:156/255.0 alpha:1.0];
        self.color2D = [[UIColor alloc] initWithRed:46/255.0 green:204/255.0 blue:113/255.0 alpha:1.0];
        self.color3D = [[UIColor alloc] initWithRed:52/255.0 green:152/255.0 blue:219/255.0 alpha:1.0];
    }
    
    /* Mise en place des couleurs par défaut + changement couleur texte */
    CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha =0.0;
    [_color1D getRed:&red green:&green blue:&blue alpha:&alpha];
    if((red*255+green*255+blue*255) < 380){ //Somble
        [_btn1D setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    [_btn1D setBackgroundColor:_color1D];
    [_color2D getRed:&red green:&green blue:&blue alpha:&alpha];
    if((red*255+green*255+blue*255) < 380){ //Somble
        [_btn2D setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    [_btn2D setBackgroundColor:_color2D];
    [_color3D getRed:&red green:&green blue:&blue alpha:&alpha];
    if((red*255+green*255+blue*255) < 380){ //Somble
        [_btn3D setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    [_btn3D setBackgroundColor:_color3D];
}

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
        [[_btn1D layer] setCornerRadius:1.0f];
        [[_btn1D layer] setBorderWidth:1.0f];
        
        [[_btn2D layer] setBorderWidth:1.0f];
        [[_btn2D layer] setBorderColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor];
        [[_btn2D layer] setCornerRadius:1.0f];
        [[_btn2D layer] setBorderWidth:1.0f];
        
        [[_btn3D layer] setBorderWidth:1.0f];
        [[_btn3D layer] setBorderColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor];
        [[_btn3D layer] setCornerRadius:1.0f];
        [[_btn3D layer] setBorderWidth:1.0f];
        
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Wundeclared-selector"
        [_btn1D addTarget:self.superview action:@selector(endDimensionChoice:) forControlEvents:UIControlEventTouchUpInside];
        [_btn2D addTarget:self.superview action:@selector(endDimensionChoice:) forControlEvents:UIControlEventTouchUpInside];
        [_btn3D addTarget:self.superview action:@selector(endDimensionChoice:) forControlEvents:UIControlEventTouchUpInside];
        #pragma clang diagnostic pop
        
        [self colors];
        
        [self addSubview:_btn1D];
        [self addSubview:_btn2D];
        [self addSubview:_btn3D];

        
    }
    
    return self;
}

- (void)updateView:(CGSize)format{
    
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
    {
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
