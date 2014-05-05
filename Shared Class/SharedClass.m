//
//  SharedClass.m
//  KeithDatingApp
//
//  Created by Mohit on 25/12/13.
//  Copyright (c) 2013 Devansh Bhardwaj. All rights reserved.
//

#import "SharedClass.h"
static SharedClass *_sharedInstance;
@implementation SharedClass
@synthesize m_ImageNumber=_m_ImageNumber;
@synthesize m_UserDetails=_m_UserDetails;
@synthesize m_FBImages=_m_FBImages;
@synthesize m_Lattitude=_m_Lattitude;
@synthesize m_Longitude=_m_Longitude;
@synthesize m_TempImageUrl=_m_TempImageUrl;
@synthesize m_LocationName=_m_LocationName;
@synthesize m_GoogleLat=_m_GoogleLat;
@synthesize m_GoogleLng=_m_GoogleLng;
@synthesize m_FoursquareID=_m_FoursquareID;
@synthesize m_FullAddress=_m_FullAddress;
@synthesize m_IconImage=_m_IconImage;
@synthesize m_LocationType=_m_LocationType;
@synthesize m_PhoneNumber=_m_PhoneNumber;
@synthesize m_PlaceName=_m_PlaceName;
@synthesize m_FourSquareLattitude=_m_FourSquareLattitude;
@synthesize m_FourSquareLongitude=_m_FourSquareLongitude;

- (id) init {
    if (self = [super init]) {
        // custom initialization
    }
    return self;
}

+(SharedClass*)sharedInstance
{
    if (!_sharedInstance) {
        _sharedInstance = [[SharedClass alloc] init];
    }
    return _sharedInstance;
}


@end
