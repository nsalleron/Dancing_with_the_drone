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
#define rgb(R,G,B) ([[UIColor alloc] initWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1.0])

@implementation ViewCouleurs



- (id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if(self){
        
        /* Couleurs disponibles ici : https://www.materialui.co/colors */
        _couleurs = [[NSArray alloc] initWithObjects:
                      rgb(213,0,0)
                     ,rgb(197,17,98)
                     ,rgb(170,0,255)
                     ,rgb(98,0,234)
                     ,rgb(48,79,254)
                     ,rgb(41,98,255)
                     ,rgb(0,145,234)
                     ,rgb(0,184,212)
                     ,rgb(0,191,165)
                     ,rgb(0,200,83)
                     ,rgb(100,221,23)
                     ,rgb(174,234,0)
                     ,rgb(255,214,0)
                     ,rgb(255,171,0)
                     ,rgb(255,109,0)
                     ,rgb(221,44,0)
                     
                     
                     
                     ,rgb(84,110,122)
                     ,rgb(117,117,117)
                     ,rgb(109,76,65)
                     ,rgb(30,136,229)
                     ,rgb(57,73,171)
                     ,rgb(94,53,177)
                     ,rgb(244,81,30)
                     ,rgb(251,140,0)
                     ,rgb(255,179,0)
                     ,rgb(253,216,53)
                     ,rgb(192,202,51)
                     ,rgb(124,179,66)
                     ,rgb(67,160,71)
                     ,rgb(0,137,123)
                     ,rgb(0,172,193)
                     ,rgb(3,155,229)
                     
                     , nil ];
   
   
        
        
        _tmp = [NSMutableArray new];
        
        for (int i = 0; i < 32; ++i) {
            UIButton *TmpBtn = [[UIButton alloc] init];
            TmpBtn = [[UIButton alloc] init ];
            [TmpBtn setBackgroundColor:[_couleurs objectAtIndex:i]];
            [TmpBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Wundeclared-selector"
            [TmpBtn addTarget:self.superview action:@selector(endColorChoice:) forControlEvents:UIControlEventTouchUpInside];
            #pragma clang diagnostic pop
            
            //NSLog(@"Ajout de : %@",[TmpBtn titleLabel].text);
            [_tmp addObject:TmpBtn];
            [self addSubview:TmpBtn];
        }
    
        
    }
    
    return self;
}




- (void)updateView:(CGSize)format{
    
    CGFloat height = format.height;
    CGFloat width = format.width;
    int i = 0;
    
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
    {
        height = (height-32)/4;
        width = width /8;
        
        for (UIButton *boutton in _tmp) {
            if(i<8){
                //NSLog(@"btn %d X = %d Y = %f width : %f height : %f",i,0,i*width, width,height);
                [boutton setFrame:CGRectMake(i*width,32  , width, height)];
            }else{
                //NSLog(@"btn %d X = %d Y = %f width : %f height : %f",i,0,i*width, width,height);
                [boutton setFrame:CGRectMake((i-8)*width,height+32  , width, height)];
            }
            
            if(i<8){
                [boutton setFrame:CGRectMake(i*width,32, width, height)];
            }else if (i<16){
                [boutton setFrame:CGRectMake((i-8)*width,height+32  , width, height)];
            }else if (i<24){
                [boutton setFrame:CGRectMake((i-16)*width,2*height+32  , width, height)];
            }else{
                [boutton setFrame:CGRectMake((i-24)*width,3*height+32  , width, height)];
            }
            
            
            
            i++;
        }
        
                                          
        
        
    }else{ //Vertical
        width = width /4;
        height = (height-32) /8;
        
        for (UIButton *boutton in _tmp) {
            if(i<8){
                [boutton setFrame:CGRectMake(0,i*height+32  , width, height)];
            }else if (i<16){
                [boutton setFrame:CGRectMake(width, 32+(i-8)*height,width, height)];
            }else if (i<24){
                [boutton setFrame:CGRectMake(2*width, 32+(i-16)*height,width, height)];
            }else{
                [boutton setFrame:CGRectMake(3*width, 32+(i-24)*height,width, height)];
            }
            i++;
        }
    }
    
}


-(void) drawRect:(CGRect)rect{
    [self updateView:rect.size];
}


@end
