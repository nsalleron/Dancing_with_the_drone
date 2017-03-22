//
//  ChildViewController.m
//  Jack Sparrot
//
//  Created by Nicolas Salleron on 07/02/2017.
//
//

#import "ViewControllerManuel.h"
#import "ViewDimensionViewController.h"
#import "ViewManuel.h"
#import "BebopDrone.h"
@interface ViewControllerManuel ()

@end


ViewManuel *ecran;
BOOL firstTime = TRUE;
BebopDrone * droneBebop;

double accX;
double accY;
double accZ;
double rotX;
double rotY;
double rotZ;

@implementation ViewControllerManuel


- (void)viewDidLoad {
    [super viewDidLoad];
    
  
    
  
   
    
    /* Accelerometre */
    
    
    _currentMaxAccelX = 0;
    _currentMaxAccelY = 0;
    _currentMaxAccelZ = 0;
    
    _currentMaxRotX = 0;
    _currentMaxRotY = 0;
    _currentMaxRotZ = 0;
    
    self.motionManager = [[CMMotionManager alloc] init];
    
    if(self.motionManager.isGyroAvailable && self.motionManager.isAccelerometerAvailable){
        
        self.motionManager.accelerometerUpdateInterval = .2;
        self.motionManager.gyroUpdateInterval = .2;

        
        
        [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue]
                                                 withHandler:^(CMAccelerometerData  *accelerometerData, NSError *error) {
                                                     [self outputAccelertionData:accelerometerData.acceleration];
                                                     if(error){
                                                         NSLog(@"%@", error);
                                                     }
                                                 }];
        
        [self.motionManager startGyroUpdatesToQueue:[NSOperationQueue currentQueue]
                                        withHandler:^(CMGyroData *gyroData, NSError *error) {
                                            [self outputRotationData:gyroData.rotationRate];
                                        }];
        
        self.motionManager.deviceMotionUpdateInterval = 0.2;
        
        [self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue]
                                                withHandler:^(CMDeviceMotion *deviceData, NSError *error){
                                                    [self outputDeviceMotionData:deviceData.userAcceleration];
                                                    if (error) {
                                                        NSLog(@"%@", error);
                                                    }
                                                }];
        

        
    }
    

    

    /* Fin accelerometre */
    
    
    _enStatio = FALSE;
    _enVol = FALSE;
    _axeX = TRUE;
    
    ecran = [[ViewManuel alloc ] initWithFrame:[[UIScreen mainScreen] bounds]];
    [ecran setBackgroundColor:[UIColor colorWithRed:250.0/255 green:246.0/255 blue:244.0/255 alpha:1.0]];
    [ecran setViewController:self];
    [ecran updateBtnStatioDecoAttr:@"Décollage"];
    [ecran updateBtnDimensions:@"1D"];
    [ecran updateBtnChangementMode:@"Axe X"];
    [self setView: ecran];
    [self setTitle:@"Manuel"];
    
    

    //Swipe UP DOWN
    UISwipeGestureRecognizer * swipeUp=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeUp:)];
    swipeUp.direction=UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:swipeUp];
    
    UISwipeGestureRecognizer * swipeDown=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeDown:)];
    swipeDown.direction=UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipeDown];
    
    //Swipe Right et Left
    UISwipeGestureRecognizer * swipeRight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(changeAxe:)];
    swipeRight.direction=UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRight];
    UISwipeGestureRecognizer * swipeLeft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(changeAxe:)];
    swipeRight.direction=UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeft];
    

    
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void) setDrone:(BebopDrone *) drone{
    droneBebop = drone;
}


- (void) changeDecoAttr:(UILongPressGestureRecognizer*)gesture{
    NSString *statio = @"Mode Stationnaire : ON";
    switch (_enVol) {
        case TRUE:
            //Atterrissage;
            NSLog(@"Atterrissage");
            _enVol = FALSE;
            _enStatio = FALSE;
            [droneBebop land];
            
            statio = @"Mode Stationnaire : OFF";
            break;
            
        case FALSE:
            //Decollage;
            NSLog(@"Decollage");
            _enVol = TRUE;
            _enStatio = TRUE;
            [droneBebop takeOff];
           
        default:
            break;
    }
    [ecran updateBtnStatioDecoAttr:statio];

    
}

- (void) changeAxe:(UIButton*)gesture{
    NSString *axe = @"Axe X";
    switch (_axeX) {
        case TRUE:
            //Axe Y
            NSLog(@"Axe Y");
            axe = @"Axe Y";
            _axeX = FALSE;
            break;
            
        case FALSE:
            //Axe X
            NSLog(@"Axe X");
            _axeX = TRUE;
        default:
            break;
    }
    [ecran updateBtnChangementMode:axe];
       
}

- (void) changeSatio:(UIButton*)send{
    if(firstTime){
        [self changeDecoAttr:NULL];
        firstTime = FALSE;
        return;
    }
        
    NSString *statio = @"Mode Stationnaire : ON";
    switch (_enStatio) {
        case TRUE:
            //Mode non stationnaire;
            NSLog(@"Mode stationnaire : OFF");
            _enStatio = FALSE;
            statio = @"Mode Stationnaire : OFF";
            break;
            
        case FALSE:
            //Mode stationnaire;
            NSLog(@"Mode Stationnaire : ON");
             _enStatio  = TRUE;
        default:
            break;
    }
    [ecran updateBtnStatioDecoAttr:statio];
}

-(void) goToDimensionChoice:(UILongPressGestureRecognizer*)gesture{
    
    ViewDimensionViewController *secondController = [[ViewDimensionViewController alloc] init];
    secondController.delegate = self;
    [self.navigationController pushViewController:secondController animated:YES];
    
}


- (void) viewDidDisappear:(BOOL)animated{
   
}

/* Gestion des toucher long par le viewController */
- (void) quitView:(UILongPressGestureRecognizer*)gesture{

    [self.navigationController popViewControllerAnimated:YES];
    
}


- (void) homeFunction:(UILongPressGestureRecognizer*)gesture{
    if ( gesture.state == UIGestureRecognizerStateBegan) {
        NSLog(@"Fonction Home activée!");
    }
}



-(void) changeStatio:(UIButton*)send{
    switch (_enStatio) {
        case TRUE:
            //Atterrissage;
            NSLog(@"Atterrissage");
            _enStatio = FALSE;
            break;
            
        case FALSE:
            //Decollage;
            NSLog(@"Decollage");
            _enStatio = TRUE;
        default:
            break;
    }
}


- (void)addItemViewController:(ViewDimensionViewController *)controller didFinishEnteringItem:(NSString *)item
{
    
    [ecran updateBtnDimensions:item];
    if([item  isEqual: @"1D"])
        [ecran updateView:[[UIScreen mainScreen] bounds].size];
    else
        [ecran update2D3D:[[UIScreen mainScreen] bounds].size];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)swipeUp:(UISwipeGestureRecognizer*)gestureRecognizer
{
    NSLog(@"Up");
}

-(void)swipeDown:(UISwipeGestureRecognizer*)gestureRecognizer
{
    NSLog(@"Down");
}

/* Rotation de l'écran */

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}
- (BOOL)shouldAutorotate{
    return YES;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations // iOS 6 autorotation fix
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskLandscapeRight;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation // iOS 6 autorotation fix
{
    return UIInterfaceOrientationLandscapeRight;
}
-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    [ecran updateView:size];
}

-(void)outputAccelertionData:(CMAcceleration)acceleration
{
    /*
    double const kThreshold = 0.2;
    [ecran updateBtnStatioDecoAttr:[[NSString alloc] initWithFormat:@"%2fg",acceleration.x]];
    if(acceleration.x < kThreshold * -1){
        [ecran updateBtnDimensions:@"++++"];
         _currentMaxAccelX = acceleration.x;
        [ecran updateBtnChangementMode:[[NSString alloc] initWithFormat:@"MAX : %2fg",_currentMaxAccelX]];
        NSLog(@"++++");
    }else if(acceleration.x > kThreshold){
        NSLog(@"---");
         _currentMaxAccelX = acceleration.x;
        [ecran updateBtnDimensions:@"----"];
        [ecran updateBtnChangementMode:[[NSString alloc] initWithFormat:@"MAX : %2fg",_currentMaxAccelX]];
    }
    
    */
    
    
    
    /*//NSLog(@"Y: %.2fg",acceleration.y);
    if(fabs(acceleration.y) > fabs(_currentMaxAccelY))
    {
        _currentMaxAccelY = acceleration.y;
    }
    //NSLog(@"Z: %.2fg",acceleration.z);
    if(fabs(acceleration.z) > fabs(_currentMaxAccelZ))
    {
        _currentMaxAccelZ = acceleration.z;
    }
    
    accX = acceleration.x;
    accY = acceleration.y;
    accZ = acceleration.z;
    
    
    double pitch = atan(accX / sqrt(accY*accY + accZ*accZ));
    double roll = atan(accY / sqrt(accX*accX + accZ*accZ));
    
    int pitchI = (pitch *180) / 3.14;
    int rollI = (roll*180)/3.14;
    NSLog(@" pitch %d roll %d",pitchI,rollI);
    
    if(_enVol == TRUE && _enStatio == FALSE){
        [droneBebop setFlag:1];
        [droneBebop setPitch:pitchI];
        [droneBebop setFlag:0];
        [droneBebop setRoll:rollI];
        NSLog(@"PASSAGE");
    }
     */
    
    
    
    
    
    
    
    
}
-(void) outputDeviceMotionData:(CMAcceleration) acceleration{
    
    double const kThreshold = 0.3;
    
    [ecran updateBtnStatioDecoAttr:[[NSString alloc] initWithFormat:@"%2fg",acceleration.x]];
    if(acceleration.x < kThreshold * -1){
        [ecran updateBtnDimensions:@"----"];
        _currentMaxAccelX = acceleration.x;
        [ecran updateBtnChangementMode:[[NSString alloc] initWithFormat:@"MAX - : %2fg",_currentMaxAccelX]];
        NSLog(@"----");
    }else if(acceleration.x > kThreshold){
        NSLog(@"++++");
        _currentMaxAccelX = acceleration.x;
        [ecran updateBtnDimensions:@"++++"];
        [ecran updateBtnChangementMode:[[NSString alloc] initWithFormat:@"MAX + : %2fg",_currentMaxAccelX]];
    }
    
}
-(void)outputRotationData:(CMRotationRate)rotation
{
    
    //NSLog(@"RX: %.2fr/s",rotation.x);
    if(fabs(rotation.x) > fabs(_currentMaxRotX))
    {
        _currentMaxRotX = rotation.x;
    }
    //NSLog(@"RY: %.2fr/s",rotation.y);
    if(fabs(rotation.y) > fabs(_currentMaxRotY))
    {
        _currentMaxRotY = rotation.y;
    }
    //NSLog(@"RZ: %.2fr/s",rotation.z);
    if(fabs(rotation.z) > fabs(_currentMaxRotZ))
    {
        _currentMaxRotZ = rotation.z;
    }
    
    rotX = rotation.x;
    rotY = rotation.y;
    rotZ = rotation.z;
    
}



@end
