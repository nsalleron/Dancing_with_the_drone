//
//  ViewManuel.m
//  Jack Sparrot
//
//  Created by Nicolas Salleron on 02/02/2017.
//
//

#import "ViewManuel.h"
#import "ViewControllerManuel.h"

@implementation ViewManuel



- (id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if(self){
        
        /* Boutons */
        _btnChangementMode = [[UIButton alloc] init];
        _btnStatioDecoAttr  = [[UIButton alloc] init];
        _btnHome  = [[UIButton alloc] init];
        _btnDimensions = [[UIButton alloc] init];
        
        [_btnDimensions setTitle:@"btnDimensions" forState:UIControlStateNormal];
        [_btnChangementMode setTitle:@"btnChangementDeMode" forState:UIControlStateNormal];
        [_btnStatioDecoAttr  setTitle:@"btnStatioDecoAttr" forState:UIControlStateNormal];
        [_btnHome setTitle:@"btnHome" forState:UIControlStateNormal];
       
        [_btnDimensions setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_btnChangementMode setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_btnStatioDecoAttr  setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_btnHome setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        
        [[_btnStatioDecoAttr layer] setBorderWidth:1.0f];
        [[_btnStatioDecoAttr layer] setBorderColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor];
        [[_btnStatioDecoAttr layer] setCornerRadius:8.0f];
        [[_btnStatioDecoAttr layer] setBorderWidth:2.0f];
        
        [[_btnChangementMode layer] setBorderWidth:1.0f];
        [[_btnChangementMode layer] setBorderColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor];
        [[_btnChangementMode layer] setCornerRadius:8.0f];
        [[_btnChangementMode layer] setBorderWidth:2.0f];
        
        [[_btnHome layer] setBorderWidth:1.0f];
        [[_btnHome layer] setBorderColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor];
        [[_btnHome layer] setCornerRadius:8.0f];
        [[_btnHome layer] setBorderWidth:2.0f];
        
        [[_btnDimensions layer] setBorderWidth:1.0f];
        [[_btnDimensions layer] setBorderColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor];
        [[_btnDimensions layer] setCornerRadius:8.0f];
        [[_btnDimensions layer] setBorderWidth:2.0f];
        
        [_btnDimensions addTarget:self.superview action:@selector(goToDimensionChoice:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [self addSubview:_btnChangementMode];
        [self addSubview:_btnStatioDecoAttr];
        [self addSubview:_btnHome];
        [self addSubview:_btnDimensions];
        
        [self updateView:frame.size];
    }
    
    return self;
}

- (void)updateView:(CGSize)format{
    
    NSLog(@"Width : %f Height : %f ",format.width,format.height);
    _tailleIcones = format.height/4;
    
    
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
    {
        /* Mise en place des labels */
        [_btnDimensions setFrame:CGRectMake(0,0,format.width,32+_tailleIcones/2)];
        
        [_btnChangementMode setFrame:CGRectMake(0,32+_tailleIcones/2,format.width, _tailleIcones/2+_tailleIcones+_tailleIcones/2)];
        
        [_btnStatioDecoAttr setFrame:CGRectMake(0,32+_tailleIcones*2+_tailleIcones/2, format.width/2,_tailleIcones+6)];
        
        [_btnHome setFrame:CGRectMake(format.width/2,32+_tailleIcones*2+_tailleIcones/2,format.width/2, _tailleIcones +6)];
        
    }else{
        
        /* Mise en place des labels */
        [_btnDimensions setFrame:CGRectMake(0,0,format.width,32+_tailleIcones/2)];
        
        [_btnChangementMode setFrame:CGRectMake(0,32+_tailleIcones/2,format.width, _tailleIcones/2+_tailleIcones)];
        
        [_btnStatioDecoAttr setFrame:CGRectMake(0,32+_tailleIcones+_tailleIcones, format.width,_tailleIcones)];
        
        [_btnHome setFrame:CGRectMake(0,32+_tailleIcones*2+_tailleIcones,format.width, _tailleIcones/2+6)];
    }
    
    
}

-(void) drawRect:(CGRect)rect{
    [self updateView:rect.size];
}


@end
