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
       
        
        [_btnChangementAxes setTitle:@"Changement des axes" forState:UIControlStateNormal];
        [_btnChangementMode setTitle:@"Changement de mode" forState:UIControlStateNormal];
        [_btnChangementCouleur setTitle:@"Changement de couleurs" forState:UIControlStateNormal];
        [_btnRetourAccueil setTitle:@"Retour Accueil" forState:UIControlStateNormal];
       
        
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
        

        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Wundeclared-selector"
        [_btnChangementAxes addTarget:self.superview action:@selector(launchVideo:) forControlEvents:UIControlEventTouchUpInside];
        [_btnChangementMode addTarget:self.superview action:@selector(launchVideo:) forControlEvents:UIControlEventTouchUpInside];
        [_btnChangementCouleur addTarget:self.superview action:@selector(launchVideo:) forControlEvents:UIControlEventTouchUpInside];
        [_btnRetourAccueil addTarget:self.superview action:@selector(launchVideo:) forControlEvents:UIControlEventTouchUpInside];
        #pragma clang diagnostic pop
        
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
        
        
        [_btnChangementAxes setFrame:CGRectMake(10, 32+10, format.width - 20 , _tailleIcones*1.2)];
        [_btnChangementMode setFrame:CGRectMake(10, 32+20+_tailleIcones*1.2, format.width - 20, _tailleIcones*1.2)];
        [_btnChangementCouleur setFrame:CGRectMake(10, 32+ 30 +2*_tailleIcones*1.2, format.width - 20, _tailleIcones*1.2)];
        [_btnRetourAccueil setFrame:CGRectMake(10, 32+40+3*_tailleIcones*1.2, format.width -20 , _tailleIcones*1.2)];
        
    }else{
        _tailleIcones = (format.height-64)/6;
        
        [_btnChangementAxes setFrame:CGRectMake(10, 64+10, format.width - 20 , _tailleIcones)];
        [_btnChangementMode setFrame:CGRectMake(10, 64+20+_tailleIcones, format.width - 20, _tailleIcones)];
        [_btnChangementCouleur setFrame:CGRectMake(10, 64+ 30 +2*_tailleIcones, format.width - 20, _tailleIcones)];
        [_btnRetourAccueil setFrame:CGRectMake(10, 64+40+3*_tailleIcones, format.width -20 , _tailleIcones)];
        
    }
    
    
}

-(void) drawRect:(CGRect)rect{
    [self updateView:rect.size];
}

@end
