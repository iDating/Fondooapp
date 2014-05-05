//
//  CommonClass.h
//  KeithDatingApp
//
//  Created by Devansh Bhardwaj on 03/12/13.
//  Copyright (c) 2013 Devansh Bhardwaj. All rights reserved.
//

#import <Foundation/Foundation.h>


//****************App Webservice URLs*****************
#define KImageUploadPhpFile @"http://deftsoft.info/meetups/images/upload.php"
#define kImageUploadUrlPrefix @"http://deftsoft.info/meetups/images/"
#define kDeftsoftWeserviceUrl @"http://deftsoft.info/meetups/services.php?"
#define kDeftsoftTextFileUploadUrl @"http://deftsoft.info/meetups/files/upload.php"

//#define kImageAFClassParam @"deftsoft.info/meetups/images/upload.php?method=setImage&image="
//http://www.fondooapp.co/Webservices/
#define kFondooWebservice @"http://www.fondooapp.co/Webservices/services.php?"
#define kImageUploadFondooPhpFile @"http://www.fondooapp.co/Webservices/images/upload.php"
//#define kImageUploadTextFileFondooPhpFile @"http://www.fondooapp.co/Webservices/upload.php"
#define kImageUploadFondooUrlPrefixFile @"http://www.fondooapp.co/Webservices/images/"

//****************Four Square API*****************
#define kFourSquareAccessTokenURL @"https://foursquare.com/oauth2/"
#define kFourSquareAuthorizationURL @"https://foursquare.com/oauth2/authorize"
#define kFourSquareCategorySring @"venues/categories"
#define kFourSquarePrefixSearchURL @"https://api.foursquare.com/v2/"
#define kFourSquareClientID @"ROKT0WC243QLNO5QJVXIBIZINPMJN0MATOEJC0LGXNFXPDKR"
#define kFourSquareClientSecret @"D0M2II0FDHSRZP5J5R0JGPUPJ4HIGA2WWEBC5XNGG1UBNJGW"
#define kFourSquareRedirectURI @"keithdatingapp://foursquare"

//****************Google Api*****************
//#define kGoogleAPIKEY @"AIzaSyD8l3WKSXZ0Xemr46omCMZ0oHWKFlHqAAo"
//#define kGoogleAPIKEY @"AIzaSyBR9DOyyZJU6HqEz8I2bIeaOztg0C84ZSo"
//AIzaSyB0nsj0pBngxL-NeiR478A05qOq44WTqnI
#define kGoogleAPIKEY @"AIzaSyBKwcDSns4A_SMbXzfD0kRCZJlmkYen414"
#define kGoogleAPIKEYReference @"AIzaSyCsB9NmVJlzlu6BkhWin_0kdzkueW0ywp8"
#define kFlurryAPIKey @"5KXB3MFN2QD9Y948XQQM"

//****************Constant Values*****************
#define kImageHeight4 320
#define kImageHeight5 300
#define kBasicScrollHeight_iPhone5 500
#define kBasicScrollHeight_iPhone4 420
#define kBasicScrollwidth 320;
//****************method*****************
#define kPostMessageMethod @"method=pushMessages"
#define kGetUserDetails @"method=getUserDetails"
#define kEditUserDetails @"method=setUserDetails"
#define kPostStatusMethod @"method=postStatus"
#define kGetPostMessages @"method=getPostMessages"
#define kCheckInUser @"method=checkedIn"
#define kLogInMethod @"method=login"
#define kSinUpMethod @"method=signUp"
#define kLikeMethod @"method=like"
#define kEditUserProfile @"method=editProfile"
#define kGetCheckinUsers @"method=getCheck"
#define kSetCriteria @"method=setCategory"
#define kGetCurrentUserCheckinDetail @"method=getCheckindata"
#define kSendMessage @"method=sendMessages"
#define kGetAllLatestMessages @"method=getAllMessages"
#define kGetAllMessages @"method=getMessages"
#define kGetOtherUserDetails @"method=otherUserDetails"
#define kSearchnearByLocation @"method=searchLocation"
#define kMessageCount @"method=countUsers"
#define kEditTagLine @"method=editTagline"
#define kEditGender @"method=editGender"
#define kEditGenderType @"method=editGenderType"
#define kEditRadius @"method=editRadius"
#define kDeleteImage @"method=deleteImage"
#define kGetCountOfUsers @"method=countCheckUser"
#define kDeleteUserMethod @"method=deleteAccount"
#define kBlockUserMethod @"method=blockUsers"
#define kEditAge @"method=editAge"
#define kGetBlockedUsers @"method="

//****************Keywords*****************
#define kDeviceTokenString @"&deviceid="
#define kUserIDString @"&userid="
#define kUserFacebookID @"&userfacebookid="
#define kTagLineString @"&tagline="
#define kAuthKeyString @"&auth_key="
#define kMessageSting @"&msg="
#define kLatitudeString @"&lat="
#define kLongitudeString @"&lon="
#define kAddressString @"&address="
#define kPostImageString @"&locationimg="
#define kPostIDString @"&postid="
#define kImageString @"&image="
#define kTimeZoneString @"&timezone="
#define kRadiusString @"&radius="
#define kMinimumAge @"&minage="
#define kMaximumAge @"&maxage="
#define kGenderString @"&gender="
#define kGenderTypeString @"&gendertype="
#define kPageString @"&page="
#define kOtherUserID @"&otheruserid="
#define kFriendsIDString @"&friendid="
#define kInterestIDString @"&interestid="
#define kFourSquareID @"&foursquareid="
#define kAgeString @"&age="
#define kCheckInImage @"&checkinimage="
#define kCheckinImageParamerterString @"&checkin_feeds="
#define kFullAdressString @"&fulladdress="
#define kPhoneString @"&phone="
#define kIconImageString @"&image="
#define kPlaceNameString @"&placename="
#define kLocationType @"&locationtype="

#define kRedColor [UIColor colorWithRed:(235.0f/255.0f) green:(92.0f/255.0f) blue:(83.0f/255.0f) alpha:0.9f]
#define kGrayColor [UIColor colorWithRed:(130.0f/255.0f) green:(139.0f/255.0f) blue:(150.0f/255.0f) alpha:0.9f]
#define kLightGray [UIColor colorWithRed:127.0/255.0 green:127.0/255.0 blue:127.0/255.0 alpha:1.0f]
#define kSeaGreenColor [UIColor colorWithRed:69.0/255.0 green:137.0/255.0 blue:174.0/255.0 alpha:1.0f]

#define kBuyTheWheelsImageFile @"www.buythewheels.com"
#define kBuyWheelImagePrefix @"www.buythewheels.com/Images/"


#define kTableCellIdentifier @"Cell"
@interface CommonClass : NSObject



@end
