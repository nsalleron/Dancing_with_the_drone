//
//  ViewManuel.m
//  Jack Sparrot
//
//  Created by Gregoire Gasc on 07/03/2017.
//
//

#import <Foundation/Foundation.h>
#import "ViewAide.h"
#import "ViewControllerAide.h"


@implementation ViewAide

- (id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if(self){
        
        /* Boutons */
        _btnChangementAxes = [[UIButton alloc] init];
        _btnChangementMode = [[UIButton alloc] init];
        _btnChangementCouleur = [[UIButton alloc] init];
        _btnRetourAccueil = [[UIButton alloc] init];
       
        
        [_btnChangementAxes setTitle:@"1D" forState:UIControlStateNormal];
        [_btnChangementMode setTitle:@"2D" forState:UIControlStateNormal];
        [_btnChangementCouleur setTitle:@"3D" forState:UIControlStateNormal];
        [_btnRetourAccueil setTitle:@"Axe X" forState:UIControlStateNormal];
       
        
        [_btnChangementAxes setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_btnChangementMode setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_btnChangementCouleur setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_btnRetourAccueil setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        
        [[_btnChangementAxes layer] setBorderWidth:1.0f];
        [[_btnChangementAxes layer] setBorderColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor];
        [[_btnChangementAxes layer] setCornerRadius:1.0f];
        [[_btnChangementAxes layer] setBorderWidth:1.0f];
        
        [[_btnChangementMode layer] setBorderWidth:1.0f];
        [[_btnChangementMode layer] setBorderColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor];
        [[_btnChangementMode layer] setCornerRadius:1.0f];
        [[_btnChangementMode layer] setBorderWidth:1.0f];
        
        [[_btnChangementCouleur layer] setBorderWidth:1.0f];
        [[_btnChangementCouleur layer] setBorderColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor];
        [[_btnChangementCouleur layer] setCornerRadius:1.0f];
        [[_btnChangementCouleur layer] setBorderWidth:1.0f];
        
        [[_btnRetourAccueil layer] setBorderWidth:1.0f];
        [[_btnRetourAccueil layer] setBorderColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor];
        [[_btnRetourAccueil layer] setCornerRadius:1.0f];
        [[_btnRetourAccueil layer] setBorderWidth:1.0f];
        

        
        [_btnChangementAxes addTarget:self.superview action:@selector(goToColorChoice:) forControlEvents:UIControlEventTouchUpInside];
        [_btnChangementMode addTarget:self.superview action:@selector(goToColorChoice:) forControlEvents:UIControlEventTouchUpInside];
        [_btnChangementCouleur addTarget:self.superview action:@selector(goToColorChoice:) forControlEvents:UIControlEventTouchUpInside];
        [_btnRetourAccueil addTarget:self.superview action:@selector(goToColorChoice:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [self addSubview:_btnChangementAxes];
        [self addSubview:_btnChangementMode];
        [self addSubview:_btnChangementCouleur];
        [self addSubview:_btnRetourAccueil];
        
    }
    
    return self;
}


- (void)updateView:(CGSize)format{
    
    NSLog(@"Width : %f Height : %f ",format.width,format.height);
    
    /*Mise en place des boutons et labels */
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
    {
        _tailleIcones = (format.height-32)/6;
        
        [_btnChangementAxes setFrame:CGRectMake(0, 32+4*_tailleIcones, format.width/3, _tailleIcones)];
        [_btnChangementMode setFrame:CGRectMake(format.width/3, 32+4*_tailleIcones, format.width/3, _tailleIcones)];
        [_btnChangementCouleur setFrame:CGRectMake(2*format.width/3, 32+4*_tailleIcones, format.width/3, _tailleIcones)];
        
        [_btnRetourAccueil setFrame:CGRectMake(format.width/6, 32+5*_tailleIcones, format.width/3, _tailleIcones)];
        
    }else{
        _tailleIcones = (format.height-64)/6;
        
        [_btnChangementAxes setFrame:CGRectMake(format.width/2, 64+3*_tailleIcones, format.width/2, _tailleIcones)];
        [_btnChangementMode setFrame:CGRectMake(format.width/2, 64+4*_tailleIcones, format.width/2, _tailleIcones)];
        [_btnChangementCouleur setFrame:CGRectMake(format.width/2, 64+5*_tailleIcones, format.width/2, _tailleIcones)];
        [_btnRetourAccueil setFrame:CGRectMake(0, 64+4*_tailleIcones, format.width/2, _tailleIcones)];
        
    }
    
    
}

-(void) drawRect:(CGRect)rect{
    [self updateView:rect.size];
}

@end
