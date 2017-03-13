//
//  ViewCouleurs.m
//  Jack Sparrot
//
//  Created by Nicolas Salleron on 28/02/2017.
//
//

#import <Foundation/Foundation.h>
#import "ViewCouleurs.h"
#import "ViewCouleursController.h"

@implementation ViewCouleurs

- (id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if(self){
        
        /* Boutons */
        _btnCouleur0 = [[UIButton alloc] init];
        [_btnCouleur0 setTitle:@"Coul0" forState:UIControlStateNormal];
        [_btnCouleur0 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [[_btnCouleur0 layer] setCornerRadius:8.0f];
        
        _btnCouleur1 = [[UIButton alloc] init];
        [_btnCouleur1 setTitle:@"Coul0" forState:UIControlStateNormal];
        [_btnCouleur1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [[_btnCouleur1 layer] setCornerRadius:8.0f];
        
    
        

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        [_btnCouleur0 addTarget:self.superview action:@selector(endDimensionChoice:) forControlEvents:UIControlEventTouchUpInside];
        [_btnCouleur1 addTarget:self.superview action:@selector(endDimensionChoice:) forControlEvents:UIControlEventTouchUpInside];
    
#pragma clang diagnostic pop
        
        [self addSubview:_btnCouleur0];
        [self addSubview:_btnCouleur1];
        
        
    }
    
    return self;
}

- (void)updateView:(CGSize)format{
    
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
    {
        [_btnCouleur0 setFrame:CGRectMake(0, 0, 30, 30)];
        [_btnCouleur1 setFrame:CGRectMake(0, 0, 30, 30)];
                                          
        
        
    }else{ //Vertical
        
    }
    
    
}


-(void) drawRect:(CGRect)rect{
    [self updateView:rect.size];
}


@end
