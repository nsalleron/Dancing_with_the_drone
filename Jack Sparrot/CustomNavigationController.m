//
//  CustomNavigationController.m
//  Jack Sparrot
//
//  Created by Nicolas Salleron on 05/03/2017.
//
//

#import "CustomNavigationController.h"

@interface CustomNavigationController ()

@end

@implementation CustomNavigationController

- (BOOL)shouldAutorotate
{
    return self.topViewController.shouldAutorotate;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return self.topViewController.supportedInterfaceOrientations;
}

@end
