//
//  InterfaceController.h
//  Jack Sparrot Watch Extension
//
//  Created by Nicolas Salleron on 22/02/2017.
//
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

@interface InterfaceController : WKInterfaceController
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceButton *btnDim;
@property (assign, nonatomic)  NSArray <WKPickerItem *> *pickerItems;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfacePicker *picker;
@property (unsafe_unretained, nonatomic) IBOutlet WKSwipeGestureRecognizer *swipeCtrl;
@property (strong, nonatomic) WKPickerItem *selectedItem;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceButton *btnChgMode;

- (IBAction)pickerAction:(NSInteger)value;

@end
