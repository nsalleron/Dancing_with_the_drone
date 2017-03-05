//
//  InterfaceController.m
//  Jack Sparrot Watch Extension
//
//  Created by Nicolas Salleron on 22/02/2017.
//
//

#import "InterfaceController.h"


@interface InterfaceController()

@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    
    
    WKPickerItem *unD = [[WKPickerItem alloc] init];
    unD.title = @"1 Dimension.";
    
    WKPickerItem *deuxD = [[WKPickerItem alloc] init];
    deuxD.title = @"2 Dimensions.";
    
    WKPickerItem *troisD = [[WKPickerItem alloc] init];
    troisD.title = @"3 Dimensions.";
    
    _pickerItems = @[unD, deuxD, troisD];
    

    // Connect data
    [_tp setItems:self.pickerItems];
    [_tp setSelectedItemIndex:0];
    

}

- (IBAction)swipeAction:(id)sender {
    
    
    
    WKSwipeGestureRecognizer* send = (WKSwipeGestureRecognizer*)sender;
    
    if(send.direction == WKSwipeGestureRecognizerDirectionRight){
        NSLog(@"RIGHT -> UP");
    }else if(send.direction == WKSwipeGestureRecognizerDirectionLeft){
        NSLog(@"LEFT -> Down");
    }
    
}
- (IBAction)btnClick {
    NSLog(@"Clique");
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



