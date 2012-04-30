//
//  Constants.m
//  Dialer
//
//  Created by William Richardson on 3/18/12.
//  Copyright (c) 2012 CodeSpan Technologies. All rights reserved.
//

#import "Constants.h"

// NSString * const MyFirstConstant = @"FirstConstant";

// phone number label from contact list
NSString * const WorkPhoneLabel = @"Work";
NSString * const WorkPhoneLabelSubStringCheck = @"work";
NSString * const HomePhoneLabel = @"Home";
NSString * const HomePhoneLabelSubStringCheck = @"home";
NSString * const MobilePhoneLabel = @"Mobile";
NSString * const MobilePhoneLabelSubStringCheck = @"mobile";
NSString * const IPhonePhoneLabel = @"iPhone";
NSString * const IPhonePhoneLabelSubStringCheck = @"iphone";

// Button Titles
NSString * const CallButtonTitle = @"Call";
NSString * const FavoriteButtonTitle = @"Favorite";

// person dictionary info
// name of person
NSString * const PersonName = @"name";
// listing of phones for that person
NSString * const PersonPhoneList = @"phoneList";
// id generated for that phone entry
NSString * const PersonPhoneId = @"phoneId";
// is person listed on favorites view
NSString * const PersonIsFavorite = @"isFavorite";
// a phone number entry for that person
NSString * const PersonPhoneNumber = @"phoneNumber";
// just the digits of the phone number entry for that person
NSString * const PersonPhoneNumberDigits = @"phoneDigits";

// reference to the person object inside a favorite (for unfavoriting)
NSString * const FavoritePersonRefName = @"personRef";

// format strings, used in building strings for the dictionaries
// @"%@ %@"		- name in person dict
NSString * const PersonNameFormat = @"%@ %@";
// @"%@_%ld"		- phoneLabel (from addressbook of phone type), index
NSString * const UniquePhoneIdentifierFormat = @"%@_%ld";
// @"(%@) %@"		- phone number detail text label
NSString * const PhoneNumberDisplayFormat = @"(%@) %@";

// regular expression pattern
// @"\d*"       - convert string phone number into digits
NSString * const PhoneNumberDigitsPattern = @"(\\d*)";

// tableview cell id
// contact list cellId
NSString * const ContactListTableViewCellId = @"GeneralCell";
// favorites list cellId 
NSString * const FavoritesListTableViewCellId = @"FavoriteCell";
// detail list cellId
NSString * const DetailListTableViewCellId = @"DetailCell";

// tableview section names
// favorites list
NSString * const FavoritesSectionName = @"Favorites";
// general contact list
NSString * const GeneralContactsSectionName = @"Contact List";

// UIView titles
// general contacts list, tableview
NSString * const InitialWindowTitle = @"Dialer";

// image filenames
// empty box no checkmark
NSString * const EmptyBoxImageTitle = @"box";
// box with checkmark
NSString * const BoxWithCheckmarkImageTitle = @"WithCheckMark";

// favorites filename
NSString * const FavoritesFileName = @"favoritesFile.plist";

// UserDefaults Keys
NSString * const M5UrlEndPointName = @"M5UrlEndPoint";

// KeyChainItem Keys
NSString * const M5UserAccountName = @"M5UserAccountName";
NSString * const M5UserAccountPassword = @"M5UserAccountPassword";
NSString * const KeychainUserPasswordIdentifier = @"UserNamePassword";


// LoginInfo Headers
NSString * const UserNameName =@"Username";
NSString * const PasswordName = @"Password";
NSString * const CallbackNumberName = @"Callback Phone Number";








//