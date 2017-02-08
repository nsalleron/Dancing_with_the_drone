//
//  ViewManuel.m
//  Jack Sparrot
//
//  Created by Nicolas Salleron on 02/02/2017.
//
//

#import "ViewManuel.h"

@implementation ViewManuel

- (id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if(self){
        
        /* Label */
        _label = [[UILabel alloc] init];
        [_label setText:@"Manuel"];
        [self addSubview:_label];
        
        _btnRotateAvant = [[UIButton alloc] init];
        _btnRotateArriere  = [[UIButton alloc] init];
        _btnRotateGauche  = [[UIButton alloc] init];
        _btnRotateDroit  = [[UIButton alloc] init];
        
        [_btnRotateAvant setTitle:@"btnRtAvant" forState:UIControlStateNormal];
        [_btnRotateArriere  setTitle:@"btnRtArriere" forState:UIControlStateNormal];
        [_btnRotateGauche setTitle:@"btnRtGauche" forState:UIControlStateNormal];
        [_btnRotateDroit  setTitle:@"btnRtDroit" forState:UIControlStateNormal];
        
        [_btnRotateAvant setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_btnRotateArriere  setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_btnRotateGauche setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_btnRotateDroit  setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [[_btnRotateArriere layer] setBorderWidth:1.0f];
        [[_btnRotateArriere layer] setBorderColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor];
        [[_btnRotateArriere layer] setCornerRadius:8.0f];
        [[_btnRotateArriere layer] setBorderWidth:2.0f];
        
        [[_btnRotateAvant layer] setBorderWidth:1.0f];
        [[_btnRotateAvant layer] setBorderColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor];
        [[_btnRotateAvant layer] setCornerRadius:8.0f];
        [[_btnRotateAvant layer] setBorderWidth:2.0f];
        
        [[_btnRotateGauche layer] setBorderWidth:1.0f];
        [[_btnRotateGauche layer] setBorderColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor];
        [[_btnRotateGauche layer] setCornerRadius:8.0f];
        [[_btnRotateGauche layer] setBorderWidth:2.0f];
        
        [[_btnRotateDroit layer] setBorderWidth:1.0f];
        [[_btnRotateDroit layer] setBorderColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor];
        [[_btnRotateDroit layer] setCornerRadius:8.0f];
        [[_btnRotateDroit layer] setBorderWidth:2.0f];
        
        
        [self addSubview:_btnRotateAvant];
        [self addSubview:_btnRotateArriere];
        [self addSubview:_btnRotateDroit];
        [self addSubview:_btnRotateGauche];
        //Exemple de selector
        //[_btnDrone addTarget:self.superview action:@selector(goToDroneControl:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return self;
}

- (void)updateView:(CGSize)format{
    
    NSLog(@"Width : %f Height : %f ",format.width,format.height);
    _tailleIcones = format.height/3 - 30;
    
    
    /* Mise en place des labels */
    [_label setFrame:CGRectMake(0,0,_tailleIcones,_tailleIcones)];
    
    [_btnRotateAvant setFrame:CGRectMake(format.width/2,
                                         format.height/3,
                                         _tailleIcones/2, _tailleIcones/2)];
    
    [_btnRotateDroit setFrame:CGRectMake(format.width/2 + _tailleIcones/2,
                                         format.height/3 +_tailleIcones/2,
                                         _tailleIcones/2, _tailleIcones/2)];
    
    [_btnRotateGauche setFrame:CGRectMake(format.width/2 - _tailleIcones/2,
                                         format.height/3 +_tailleIcones/2,
                                         _tailleIcones/2, _tailleIcones/2)];
    
    [_btnRotateArriere setFrame:CGRectMake(format.width/2,
                                          format.height/3 +_tailleIcones,
                                          _tailleIcones/2, _tailleIcones/2)];
    
    
    
}

-(void) drawRect:(CGRect)rect{
    [self updateView:rect.size];
}


@end
