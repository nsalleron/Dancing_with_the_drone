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

/**
 * @brief Redéfinition de ces deux méthodes pour forcer la rotation de l'écran ou non.
 */
- (BOOL)shouldAutorotate
{
    return self.topViewController.shouldAutorotate;
}
/**
 * @brief Redéfinition de ces deux méthodes pour forcer la rotation de l'écran ou non.
 */
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return self.topViewController.supportedInterfaceOrientations;
}

@end
