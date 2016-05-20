//
//  LocationViewer.m
//  MUMScrum
//
//  Created by Najmul Hasan on 5/23/13.
//  Copyright (c) 2013 Najmul Hasan. All rights reserved.
//

#import "LocationViewer.h"
#import <QuartzCore/QuartzCore.h>
#import <AddressBookUI/AddressBookUI.h>
#import "AppDelegate.h"
#import "MyAnnotation.h"
#import "REVClusterPin.h"
#import "REVClusterAnnotationView.h"
#import "SVProgressHUD.h"
#import "CalloutMapAnnotationView.h"

@implementation LocationViewer
@synthesize delegate;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        [self setUp];
        initialFrame = self.frame;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUp];
        initialFrame = frame;
    }
    return self;
}

- (void)setUp{
    
    self.backgroundColor = [UIColor clearColor];
//    self.backgroundColor = [UIColor colorWithRed:230.0/255 green:230.0/255 blue:230.0/255 alpha:1];
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"LocationViewer" owner:self options:nil];
    infoView = [nibViews objectAtIndex:0];

    infoView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
//    self.mapView.frame = self.frame;
//    self.mapView.bounds = CGRectInset(self.mapView.frame, 10.0f, 10.0f);
    
    infoView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
    [self addSubview:infoView];
    
    [infoView.layer setCornerRadius:infoView.frame.size.height/2];
    infoView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    infoView.layer.borderWidth = 0.5;
    
    self.mapView.delegate = self;
    [self.mapView.layer setCornerRadius:self.mapView.frame.size.height/2];
    self.mapView.showsUserLocation = YES;
    self.mapView.zoomEnabled = YES;
    
    self.mapView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.mapView.layer.borderWidth = 0.5;
    
//    [self.layer setCornerRadius:10.0];
}

-(IBAction)showInFullView:(id)sender{

    self.needFullView = !self.needFullView;
//    [(UIButton*)sender setSelected:self.needFullView];
    [UIView animateWithDuration:0.5f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         if (self.needFullView) {
                             
                             CGRect _frame = [UIScreen mainScreen].bounds;
                             _frame.size.height = [UIScreen mainScreen].bounds.size.height - 64;
                             self.frame = _frame;
                             
                             [infoView.layer setCornerRadius:0.0];
                             [self.mapView.layer setCornerRadius:0.0];
                             
                         }else{
                             
                             self.frame = initialFrame;
                             [infoView.layer setCornerRadius:infoView.frame.size.height/2];
                             [self.mapView.layer setCornerRadius:self.mapView.frame.size.height/2];
                         }
                     }
                     completion:^(BOOL finished) {
//                         AppDelegate *appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
//                         [appDelegate.navController setNavigationBarHidden:self.needFullView animated:YES];
                     }];
}

-(void)readjustView{

    self.frame = initialFrame;
}

-(void)setSpanOfMyMapView{
    
    MKCoordinateRegion newRegion;
    
    newRegion.center.latitude  = self.mapView.userLocation.location.coordinate.latitude;
    newRegion.center.longitude = self.mapView.userLocation.location.coordinate.longitude;
    
    MKCoordinateSpan span;
    span.latitudeDelta = 0.1;
    span.longitudeDelta = 0.1;
    
    newRegion.span= span;
    [self.mapView setRegion:newRegion animated:YES];
}

-(void)resetSpanOfMyMapView{
    
    MKCoordinateRegion newRegion;
    
    newRegion.center.latitude  = self.mapView.userLocation.location.coordinate.latitude;
    newRegion.center.longitude = self.mapView.userLocation.location.coordinate.longitude;
    
    MKCoordinateSpan span;
    span.latitudeDelta=180;
    span.longitudeDelta=360;
    
    newRegion.span= span;
    [self.mapView setRegion:newRegion animated:YES];
}

- (void)createPIOOnMap:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;
   
    if (gestureRecognizer.state != UIGestureRecognizerStateEnded){
        
        [self.mapView removeAnnotation:annot];
        
        CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
        CLLocationCoordinate2D touchMapCoordinate = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
        [self performCoordinateGeocode:touchMapCoordinate];
        annot = [[MKPointAnnotation alloc] init];
        annot.coordinate = touchMapCoordinate;

        [self.mapView addAnnotation:annot];
        [self.mapView setCenterCoordinate:touchMapCoordinate animated:YES];
    }
}

-(void)showDetailsAddress{

    dispatch_async(dispatch_get_main_queue(),^ {
        
        NSLog(@"showDetailsAddress");
//        GetStartViewController *controller = [[GetStartViewController alloc] initWithNibName:@"GetStartViewController" bundle:nil];
//        controller.themeColor = self.parentController.navigationController.navigationBar.tintColor;
//        [self.parentController.navigationController pushViewController:controller animated:YES];
    });
}

// display the results
- (void)displayPlacemarks:(NSArray *)placemarks
{
    self.placeMark = placemarks[0];
    annot.title = self.placeMark.name;
    annot.subtitle = CFBridgingRelease(CFBridgingRetain(ABCreateStringWithAddressDictionary(self.placeMark.addressDictionary, NO)));
    [delegate LocationViewerDidPickedLocation:self];
}

- (void)displayError:(NSError*)error
{
    dispatch_async(dispatch_get_main_queue(),^ {
        
        NSString *message;
        switch ([error code])
        {
            case kCLErrorGeocodeFoundNoResult: message = @"kCLErrorGeocodeFoundNoResult";
                break;
            case kCLErrorGeocodeCanceled: message = @"kCLErrorGeocodeCanceled";
                break;
            case kCLErrorGeocodeFoundPartialResult: message = @"kCLErrorGeocodeFoundNoResult";
                break;
            default: message = [error description];
                break;
        }
        
        UIAlertView *alert =  [[UIAlertView alloc] initWithTitle:@"An error occurred."
                                                         message:message
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];;
        [alert show];
    });
}

-(void)clearAllAnnotation {
    
    for (id annotation in self.mapView.annotations) {
        
        if (![(id <MKAnnotation>)annotation isKindOfClass:[MKUserLocation class]]) {
            [self.mapView removeAnnotation:(id <MKAnnotation>)annotation];
        }
    }
}

-(void)plotAllPlace:(NSArray*)places{
    
    [self clearAllAnnotation];
    if ([places count]) [_mapView addAnnotations:places];
    
    if ([places count]==1) {
        [self performSelector:@selector(setSpanForSingleAnnotation) withObject:nil afterDelay:0.5];
    }else{
        [self performSelector:@selector(zoomToFitMapAnnotations) withObject:nil afterDelay:0.5];
    }
}

-(void)setSpanForSingleAnnotation{

    if ([self.mapView.annotations count] == 0) {
        return;
    }
    
    MKCoordinateRegion newRegion;
    
    id<MKAnnotation> annotation = self.mapView.annotations[0];
    
    newRegion.center.latitude  = annotation.coordinate.latitude;
    newRegion.center.longitude = annotation.coordinate.longitude;
    
    MKCoordinateSpan span;
    span.latitudeDelta=.1;
    span.longitudeDelta=.1;
    
    newRegion.span= span;
    [self.mapView setRegion:newRegion animated:YES];
}

- (void)zoomToFitMapAnnotations {
    
    [self resetSpanOfMyMapView];
    if ([self.mapView.annotations count] <= 1) return;
    
    CLLocationCoordinate2D topLeftCoord;
    topLeftCoord.latitude = -90;
    topLeftCoord.longitude = 180;
    
    CLLocationCoordinate2D bottomRightCoord;
    bottomRightCoord.latitude = 90;
    bottomRightCoord.longitude = -180;
    
    for(id<MKAnnotation> annotation in self.mapView.annotations) {
        topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
        topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
        bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
        bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
    }
    
    MKCoordinateRegion region;
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
    
    region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.1;
    // Add a little extra space on the sides
    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 2.0;
    
    region = [self.mapView regionThatFits:region];
    if(region.center.longitude == -180.00000000){
        return;
    }
    [self.mapView setRegion:region animated:YES];
}

- (void)performCoordinateGeocode:(CLLocationCoordinate2D)coord
{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:coord.latitude longitude:coord.longitude];
    
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error){
            NSLog(@"Geocode failed with error: %@", error);
            [self displayError:error];
            return;
        }
        NSLog(@"Received placemarks: %@", placemarks);
        [self displayPlacemarks:placemarks];
    }];
}

- (void)mapViewWillStartLoadingMap:(MKMapView *)mapView{
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView{
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{

    self.mapView.centerCoordinate = userLocation.coordinate;
    [self setSpanOfMyMapView];
}

- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error {
   
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
//    if ([error userInfo]) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Alert_Suggestion", @"") message:[[error userInfo] objectForKey:@"NSLocalizedRecoverySuggestion"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
//    }
}

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    // in case it's the user location, we already have an annotation, so just return nil
    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        return nil;
    }

    MKAnnotationView *annView;
    annView = [_mapView dequeueReusableAnnotationViewWithIdentifier:@"pin"];
    
    if( !annView )
        annView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                               reuseIdentifier:@"pin"];
    
    annView.image = [UIImage imageNamed:@"pinpoint.png"];
//    annView.canShowCallout = YES;
    
    return annView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if ([view.annotation isKindOfClass:[MKUserLocation class]]) return;
        
        if (self.calloutAnnotation == nil) {
            self.calloutAnnotation = [[CalloutMapAnnotation alloc] initWithLatitude:view.annotation.coordinate.latitude
                                                                       andLongitude:view.annotation.coordinate.longitude];
        } else {
            self.calloutAnnotation.latitude = view.annotation.coordinate.latitude;
            self.calloutAnnotation.longitude = view.annotation.coordinate.longitude;
        }
        [self.mapView addAnnotation:self.calloutAnnotation];
        self.selectedAnnotationView = view;
        
//        [self.mapView adjustToContainAnnotationView:view];
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
	
    if (self.calloutAnnotation) {
		[self.mapView removeAnnotation: self.calloutAnnotation];
	}
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
