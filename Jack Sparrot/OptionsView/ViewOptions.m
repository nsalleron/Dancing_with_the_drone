//
//  ViewManuel.m
//  Jack Sparrot
//
//  Created by Gregoire Gasc on 07/03/2017.
//
//

#import <Foundation/Foundation.h>
#import "ViewOptions.h"
#import "ViewControllerOptions.h"


@implementation ViewOptions

- (id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if(self){
        
        /* Boutons */
        _btnColor1D = [[UIButton alloc] init];
        _btnColor2D = [[UIButton alloc] init];
        _btnColor3D = [[UIButton alloc] init];
        _btnColorAxeX = [[UIButton alloc] init];
        _btnColorAxeY = [[UIButton alloc] init];
        
        [_btnColor1D setTitle:@"1D" forState:UIControlStateNormal];
        [_btnColor2D setTitle:@"2D" forState:UIControlStateNormal];
        [_btnColor3D setTitle:@"3D" forState:UIControlStateNormal];
        [_btnColorAxeX setTitle:@"Axe X" forState:UIControlStateNormal];
        [_btnColorAxeY setTitle:@"Axe Y" forState:UIControlStateNormal];
        
        [_btnColor1D setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_btnColor2D setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_btnColor3D setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_btnColorAxeX setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_btnColorAxeY setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [[_btnColor1D layer] setBorderWidth:1.0f];
        [[_btnColor1D layer] setBorderColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor];
        [[_btnColor1D layer] setCornerRadius:8.0f];
        [[_btnColor1D layer] setBorderWidth:2.0f];
        
        [[_btnColor2D layer] setBorderWidth:1.0f];
        [[_btnColor2D layer] setBorderColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor];
        [[_btnColor2D layer] setCornerRadius:8.0f];
        [[_btnColor2D layer] setBorderWidth:2.0f];
        
        [[_btnColor3D layer] setBorderWidth:1.0f];
        [[_btnColor3D layer] setBorderColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor];
        [[_btnColor3D layer] setCornerRadius:8.0f];
        [[_btnColor3D layer] setBorderWidth:2.0f];
        
        [[_btnColorAxeX layer] setBorderWidth:1.0f];
        [[_btnColorAxeX layer] setBorderColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor];
        [[_btnColorAxeX layer] setCornerRadius:8.0f];
        [[_btnColorAxeX layer] setBorderWidth:2.0f];
        
        [[_btnColorAxeY layer] setBorderWidth:1.0f];
        [[_btnColorAxeY layer] setBorderColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor];
        [[_btnColorAxeY layer] setCornerRadius:8.0f];
        [[_btnColorAxeY layer] setBorderWidth:2.0f];
        
        [_btnColor1D addTarget:self.superview action:@selector(goToColorChoice:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_btnColor1D];
        [self addSubview:_btnColor2D];
        [self addSubview:_btnColor3D];
        [self addSubview:_btnColorAxeX];
        [self addSubview:_btnColorAxeY];
        
        /*Switch*/
        _swhInOut = [[UISwitch alloc] init];
        [self addSubview:_swhInOut];
        
        /*Labels*/
        _lblHauteurMax = [[UILabel alloc] init];
        _lblCoeffAccel = [[UILabel alloc] init];
        _lblCouleurDim = [[UILabel alloc] init];
        _lblModeIntExt = [[UILabel alloc] init];
        
        [_lblHauteurMax setText:@"Hauteur max. (m) :"];
        [_lblCoeffAccel setText:@"Coeff. acceleration :"];
        [_lblCouleurDim setText:@"Couleurs boutons :"];
        [_lblModeIntExt setText:@"Mode intérieur :"];
        
        [self addSubview:_lblHauteurMax];
        [self addSubview:_lblCoeffAccel];
        [self addSubview:_lblCouleurDim];
        [self addSubview:_lblModeIntExt];
        
        /*TextFields*/
        _txtHauteurMax = [[UITextField alloc] init];
        _txtCoeffAccel = [[UITextField alloc] init];
        
        [[_txtHauteurMax layer] setBackgroundColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0].CGColor];
        [[_txtHauteurMax layer] setBorderWidth:1.0f];
        [[_txtHauteurMax layer] setBorderColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor];
        
        [[_txtCoeffAccel layer] setBackgroundColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0].CGColor];
        [[_txtCoeffAccel layer] setBorderWidth:1.0f];
        [[_txtCoeffAccel layer] setBorderColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor];
        
        [self addSubview:_txtHauteurMax];
        [self addSubview:_txtCoeffAccel];
    }
    
    return self;
}


- (void)updateView:(CGSize)format{
    
    NSLog(@"Width : %f Height : %f ",format.width,format.height);
    
    /*Mise en place des boutons et labels */
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
    {
        _tailleIcones = (format.height-32)/6;
        
        [_lblModeIntExt setFrame:CGRectMake(format.width/6, 32, format.width/3, _tailleIcones)];
        [_swhInOut setFrame:CGRectMake(format.width/6+format.width/3, 32+_tailleIcones/3, format.width/3, _tailleIcones)];
        
        [_lblHauteurMax setFrame:CGRectMake(format.width/6, 32+_tailleIcones, format.width/3, _tailleIcones)];
        [_txtHauteurMax setFrame:CGRectMake(format.width/6+format.width/3, 32+_tailleIcones+2, format.width/3, _tailleIcones-4)];
        
        [_lblCoeffAccel setFrame:CGRectMake(format.width/6, 32+2*_tailleIcones, format.width/3, _tailleIcones)];
        [_txtCoeffAccel setFrame:CGRectMake(format.width/6+format.width/3, 32+2*_tailleIcones+2, format.width/3, _tailleIcones-4)];
        
        [_lblCouleurDim setFrame:CGRectMake(format.width/6, 32+3*_tailleIcones, format.width/3, _tailleIcones)];
        
        [_btnColor1D setFrame:CGRectMake(0, 32+4*_tailleIcones, format.width/3, _tailleIcones)];
        [_btnColor2D setFrame:CGRectMake(format.width/3, 32+4*_tailleIcones, format.width/3, _tailleIcones)];
        [_btnColor3D setFrame:CGRectMake(2*format.width/3, 32+4*_tailleIcones, format.width/3, _tailleIcones)];
        
        [_btnColorAxeX setFrame:CGRectMake(format.width/6, 32+5*_tailleIcones, format.width/3, _tailleIcones)];
        [_btnColorAxeY setFrame:CGRectMake(format.width/6+format.width/3, 32+5*_tailleIcones, format.width/3, _tailleIcones)];
        
        
    }else{
        _tailleIcones = (format.height-64)/6;
        [_lblModeIntExt setFrame:CGRectMake(5, 64, (format.width/2)-5, _tailleIcones)];
        [_swhInOut setFrame:CGRectMake(5+format.width/2, 64+_tailleIcones/3, format.width/2, _tailleIcones)];
        
        [_lblHauteurMax setFrame:CGRectMake(5, 64+_tailleIcones, (format.width/2)-5, _tailleIcones)];
        [_txtHauteurMax setFrame:CGRectMake(format.width/2+10, 84+_tailleIcones+2, format.width/2-20, _tailleIcones-44)];
        
        [_lblCoeffAccel setFrame:CGRectMake(5, 64+2*_tailleIcones, (format.width/2)-5, _tailleIcones)];
        [_txtCoeffAccel setFrame:CGRectMake(format.width/2+10, 84+2*_tailleIcones+2, format.width/2-20, _tailleIcones-44)];
        
        [_lblCouleurDim setFrame:CGRectMake(5, 64+3*_tailleIcones, (format.width/2)-5, _tailleIcones)];
        [_btnColor1D setFrame:CGRectMake(format.width/2, 64+3*_tailleIcones, format.width/2, _tailleIcones)];
        
        [_btnColor2D setFrame:CGRectMake(format.width/2, 64+4*_tailleIcones, format.width/2, _tailleIcones)];
        [_btnColor3D setFrame:CGRectMake(format.width/2, 64+5*_tailleIcones, format.width/2, _tailleIcones)];
        
        [_btnColorAxeX setFrame:CGRectMake(0, 64+4*_tailleIcones, format.width/2, _tailleIcones)];
        [_btnColorAxeY setFrame:CGRectMake(0, 64+5*_tailleIcones, format.width/2, _tailleIcones)];
        
    }
    
    
}

-(void) drawRect:(CGRect)rect{
    [self updateView:rect.size];
}


@end
