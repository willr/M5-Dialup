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

NSString * const PersonPhoneLabel = @"phoneLabel";

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
NSString * const M5DialCmd = @"M5DialCmd";
NSString * const M5AnswerCmd = @"M5AnswerCmd";
NSString * const M5IgnoreCmd = @"M5IgnoreCmd";
NSString * const M5ReleaseCmd = @"M5ReleaseCmd";
NSString * const M5HoldCmd = @"M5HoldCmd";
NSString * const M5ListCallsCmd = @"M5ListCallsCmd";
NSString * const M5ResumeCmd = @"M5ResumeCmd";

// KeyChainItem Keys
NSString * const M5UserAccountName = @"M5UserAccountName";
NSString * const M5UserAccountPassword = @"M5UserAccountPassword";
NSString * const KeychainUserPasswordIdentifier = @"UserNamePassword.com.codespantech.dialer";
NSString * const KeychainPhoneNumberIdendifier = @"PhoneNumber.com.codespantech.dialer";

// LoginInfo Headers
NSString * const UserNameName =@"Username";
NSString * const PasswordName = @"Password";
NSString * const CallbackNumberName = @"Callback Phone Number";

NSInteger const kPasswordTag = 2;

// DialingView Headers
NSString * const CallingName = @"Calling";
NSString * const PhoneNumberCalling = @"Phone Number";
NSString * const ProgressIndicator = @"Progress";

// Connection Statuses
NSString * const WaitingToConnect =@"Waiting to Connect";
NSString * const ConnectingConnection = @"Connecting";
NSString * const CompletedConnection = @"Completed Communication";
NSString * const CancelledConnection = @"Connection Cancelled";
NSString * const ErroredConnection = @"Connection Errored";

// NSNotificationCenter Notification Names
NSString * const ContactsReloaded = @"ContactsReloaded";
NSString * const FavoritesReloaded = @"FavoritesReloaded";

// M5 get commands https strings
// real hostAddress = https://hostedconnect.m5net.com
// real hostPath = /bobl/bobl?
NSString * const M5HostAddress = @"https://hostedconnect.m5net.com";
NSString * const M5HostPath = @"/bobl/bobl?";
// NSString * const M5HostAddress = @"http://127.0.0.1:8000/";
// NSString * const M5HostPath = @"m5";

NSString * const M5DialCmdFormat = @"%@%@name=org.m5.apps.v1.cti.ClickToDial.dial&user=%@&password=%@&args=%@&args=";
NSString * const M5DialCmdNoPassFormat = @"%@%@name=org.m5.apps.v1.cti.ClickToDial.dial&user=%@&password=####&args=%@&args=";
NSString * const M5AnswerCmdFormat = @"%@%@name=org.m5.apps.v1.cti.ClickToDial.answer&user=%@&password=%@";
NSString * const M5IgnoreCmdFormat = @"%@%@name=org.m5.apps.v1.cti.ClickToDial.ignore&user=%@&password=%@";
NSString * const M5ReleaseCmdFormat = @"￼%@%@name=org.m5.apps.v1.cti.ClickToDial.release&user=%@&password=%@";
NSString * const M5ListCallsCmdFormat = @"￼￼%@%@name=org.m5.apps.v1.cti.ClickToDial.listCalls&user=%@&password=%@";
NSString * const M5HoldCmdFormat = @"%@%@name=org.m5.apps.v1.cti.ClickToDial.hold&user=%@&password=%@";
NSString * const M5ResumeCmdFormat = @"￼￼%@%@name=org.m5.apps.v1.cti.ClickToDial.resume&user=%@&password=%@";













//