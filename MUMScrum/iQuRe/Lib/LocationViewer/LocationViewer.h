//
//  LocationViewer.h
//  MUMScrum
//
//  Created by Najmul Hasan on 5/23/13.
//  Copyright (c) 2013 Najmul Hasan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "CalloutMapAnnotation.h"
#import "REVClusterMapView.h"

@class REVClusterPin;
@class LocationViewer;

@protocol LocationViewerDelegate
@required

-(void)LocationViewerDidPickedLocation:(LocationViewer*)locViewer;

@end

@interface LocationViewer : UIView<MKMapViewDelegate>{

    CGRect              initialFrame;
    MKPointAnnotation   *annot;
    UIView *infoView;
    
    MKCircle    *radiusOverlay;
    BOOL        currentAddress;
}

@property (nonatomic, retain) UIViewController *parentController;
@property (nonatomic, retain) CalloutMapAnnotation *calloutAnnotation;
@property (nonatomic, retain) MKAnnotationView *selectedAnnotationView;
@property (nonatomic, retain) NSArray *connections;

@property (nonatomic, weak) id<LocationViewerDelegate> delegate;
@property (nonatomic, weak) IBOutlet REVClusterMapView *mapView;
@property (nonatomic, weak) IBOutlet UIButton *btnExpand;
@property (nonatomic, retain) CLPlacemark *placeMark;
@property (nonatomic) BOOL needFullView;

- (IBAction)showInFullView:(id)sender;

- (void)setSpanOfMyMapView;
- (void)clearAllAnnotation;
- (void)plotAllPlace:(NSArray*)places;
- (void)readjustView;

@end
