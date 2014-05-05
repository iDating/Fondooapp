
//
//  SharedClass.h
//  KeithDatingApp
//
//  Created by Mohit on 25/12/13.
//  Copyright (c) 2013 Devansh Bhardwaj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedClass : NSObject

@property(nonatomic,copy) NSString *m_ImageNumber;
@property(nonatomic,copy)NSMutableDictionary *m_UserDetails;
@property(nonatomic,copy)NSString *m_Lattitude;
@property(nonatomic,copy)NSString *m_Longitude;
@property(nonatomic,copy)NSMutableDictionary *m_FBImages;
@property(nonatomic,copy)NSString *m_TempImageUrl;
@property(nonatomic,copy)NSString *m_LocationName;
@property(nonatomic,copy)NSString *m_GoogleLat;
@property(nonatomic,copy)NSString *m_GoogleLng;
@property(nonatomic,copy)NSString *m_FoursquareID;
@property(nonatomic,copy)NSString *m_IconImage;
@property(nonatomic,copy)NSString *m_FullAddress;
@property(nonatomic,copy)NSString *m_PhoneNumber;
@property(nonatomic,copy)NSString *m_PlaceName;
@property(nonatomic,copy)NSString *m_LocationType;
@property(nonatomic,copy)NSString *m_FourSquareLattitude;
@property(nonatomic,copy)NSString *m_FourSquareLongitude;
+(SharedClass*)sharedInstance;
@end
