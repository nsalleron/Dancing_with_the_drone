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

        _couleurs = [[NSArray alloc] initWithObjects:@"C1",@"C2",@"C3",@"C4",@"C5",@"C6",@"C7",@"C8", nil ];
        _tmp = [NSMutableArray new];
        
        for (int i = 0; i < 8; ++i) {
            UIButton *TmpBtn = [[UIButton alloc] init];
            TmpBtn = [[UIButton alloc] init ];
            [TmpBtn setTitle:[_couleurs objectAtIndex:i] forState:UIControlStateNormal];
            [TmpBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            [[TmpBtn layer] setBorderWidth:1.0f];
            [[TmpBtn layer] setBorderColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor];
            [[TmpBtn layer] setCornerRadius:8.0f];
            [[TmpBtn layer] setBorderWidth:2.0f];
            
            
            
            
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Wundeclared-selector"
            [TmpBtn addTarget:self.superview action:@selector(endColorChoice:) forControlEvents:UIControlEventTouchUpInside];
            #pragma clang diagnostic pop
            
            NSLog(@"Ajout de : %@",[TmpBtn titleLabel].text);
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
        
        
        height = height/2;
        width = width /4;
        
        for (UIButton *boutton in _tmp) {
            if(i<4){
                NSLog(@"btn %d X = %d Y = %f width : %f height : %f",i,0,i*width, width,height);
                [boutton setFrame:CGRectMake(i*width,0  , width, height)];
            }else{
                NSLog(@"btn %d X = %d Y = %f width : %f height : %f",i,0,i*width, width,height);
                [boutton setFrame:CGRectMake((i-4)*width,height  , width, height)];
            }
            
            //else
                //[boutton setFrame:CGRectMake(height, i*width , width, height)];
            
            i++;
        }
        
                                          
        
        
    }else{ //Vertical
        width = width /2;
        height = height /4;
        
        for (UIButton *boutton in _tmp) {
            if(i<4){
                NSLog(@"btn %d X = %d Y = %f width : %f height : %f",i,0,i*width, width,height);
                [boutton setFrame:CGRectMake(0,i*height  , width, height)];
            }else{
                NSLog(@"btn %d X = %d Y = %f width : %f height : %f",i,0,i*width, width,height);
                [boutton setFrame:CGRectMake(width, (i-4)*height,width, height)];
            }
            i++;
        }
    }
    
    
}


-(void) drawRect:(CGRect)rect{
    [self updateView:rect.size];
}


@end
