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
        NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight];
        [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
        
        /* Boutons */
        _btnChangementMode = [[UIButton alloc] init];
        _btnStatioDecoAttr  = [[UIButton alloc] init];
        _btnHome  = [[UIButton alloc] init];
        _btnDimensions = [[UIButton alloc] init];
        
        [_btnDimensions setTitle:@"1D" forState:UIControlStateNormal];
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
        
        /* Gestion des évènements */
        [_btnDimensions addTarget:self.superview action:@selector(goToDimensionChoice:) forControlEvents:UIControlEventTouchUpInside];
        [_btnStatioDecoAttr addTarget:self.superview action:@selector(changeSatio:) forControlEvents:UIControlEventTouchUpInside];
         [_btnChangementMode addTarget:self.superview action:@selector(changeAxe:) forControlEvents:UIControlEventTouchUpInside];
        
        /* Gestion Pression longue btnStatioDecoAttr/Dimensions/Home */
        _longPressDecoAttr = [[UILongPressGestureRecognizer alloc] init];
        [_longPressDecoAttr addTarget:self action:@selector(changeDecoAttr:)];
        [_longPressDecoAttr setMinimumPressDuration:1];
        [_btnStatioDecoAttr addGestureRecognizer:_longPressDecoAttr];
        
        _longPressDim = [[UILongPressGestureRecognizer alloc] init];
        [_longPressDim addTarget:self action:@selector(exit:)];
        [_longPressDim setMinimumPressDuration:2];
        [_btnDimensions addGestureRecognizer:_longPressDim];
        
        _longPressHome = [[UILongPressGestureRecognizer alloc] init];
        [_longPressHome addTarget:self action:@selector(homeFunction:)];
        [_longPressHome setMinimumPressDuration:1];
        [_btnHome addGestureRecognizer:_longPressHome];
        
        
        
        [self addSubview:_btnChangementMode];
        [self addSubview:_btnStatioDecoAttr];
        [self addSubview:_btnHome];
        [self addSubview:_btnDimensions];
        
        
    }
    
    return self;
}

- (void) setViewController:(ViewControllerManuel *) me{
    self.vc = me;
}

- (void)updateView:(CGSize)format{
    
    _tailleIcones = format.height/4;
    [_btnChangementMode setHidden:FALSE];

    /* Mise en place des labels */
    [_btnDimensions setFrame:CGRectMake(0,0,format.width,_tailleIcones)];
    [_btnChangementMode setFrame:CGRectMake(0,_tailleIcones,format.width, 2*_tailleIcones)];
    [_btnStatioDecoAttr setFrame:CGRectMake(0,_tailleIcones*2+_tailleIcones, format.width/2,_tailleIcones)];
    [_btnHome setFrame:CGRectMake(format.width/2,_tailleIcones*2+_tailleIcones,format.width/2, _tailleIcones)];
    
}

- (void)update2D3D:(CGSize)format{
    
    _tailleIcones = format.height/4;
    
    [_btnChangementMode setHidden:TRUE];
    /* Mise en place des labels */
    [_btnDimensions setFrame:CGRectMake(0,0,format.width,_tailleIcones)];
    [_btnStatioDecoAttr setFrame:CGRectMake(0,_tailleIcones, format.width/2,3*_tailleIcones)];
    [_btnHome setFrame:CGRectMake(format.width/2,_tailleIcones,format.width/2, 3*_tailleIcones)];
    
}



- (void) updateBtnDimensions:(NSString*) item{
    [_btnDimensions setTitle:item forState:UIControlStateNormal];
}
- (void) updateBtnChangementMode:(NSString *)item{
    [_btnChangementMode setTitle:item forState:UIControlStateNormal];
}
- (void) updateBtnStatioDecoAttr:(NSString*) item{
    [_btnStatioDecoAttr setTitle:item forState:UIControlStateNormal];
}

-(void) drawRect:(CGRect)rect{
    [self updateView:rect.size];
}

- (void) changeDecoAttr:(UILongPressGestureRecognizer*)gesture{
    if ( gesture.state == UIGestureRecognizerStateBegan) {
        //Update du View Controller
        [_vc changeDecoAttr:gesture];
    }

}

- (void) exit:(UILongPressGestureRecognizer*)gesture{
    if ( gesture.state == UIGestureRecognizerStateBegan) {
        //Update du View Controller
        [_vc quitView:gesture];
    }
}
- (void) homeFunction:(UILongPressGestureRecognizer*)gesture{
    if ( gesture.state == UIGestureRecognizerStateBegan) {
        //Update du View Controller
        [_vc homeFunction:gesture];
    }
}


@end
