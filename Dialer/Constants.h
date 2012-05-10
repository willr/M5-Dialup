//
//  Constants.h
//  Dialer
//
//  Created by William Richardson on 3/18/12.
//  Copyright (c) 2012 CodeSpan Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

// remote TestFlight log
#define RTFLog(__FORMAT__, ...) TFLog((@"%s [Line %d] " __FORMAT__), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

// extern NSString * const MyFirstConstant; 

// phone number label from contact list
extern NSString * const WorkPhoneLabel;
extern NSString * const WorkPhoneLabelSubStringCheck;
extern NSString * const HomePhoneLabel;
extern NSString * const HomePhoneLabelSubStringCheck;
extern NSString * const MobilePhoneLabel;
extern NSString * const MobilePhoneLabelSubStringCheck;
extern NSString * const IPhonePhoneLabel;
extern NSString * const IPhonePhoneLabelSubStringCheck;

// Button Titles
extern NSString * const CallButtonTitle;
extern NSString * const FavoriteButtonTitle;

// person dictionary info
// name of person
extern NSString * const PersonName;
// listing of phones for that person
extern NSString * const PersonPhoneList;
// id generated for that phone entry
extern NSString * const PersonPhoneId;
// is person listed on favorites view
extern NSString * const PersonIsFavorite;
// a phone number entry for that person
extern NSString * const PersonPhoneNumber;
// just the digits of the phone number entry for that person
extern NSString * const PersonPhoneNumberDigits;

extern NSString * const PersonPhoneLabel;

// reference to the person object inside a favorite (for unfavoriting)
extern NSString * const FavoritePersonRefName;

// format strings, used in building strings for the dictionaries
// @"%@ %@"		- name in person dict
extern NSString * const PersonNameFormat;
// @"%@_%ld"		- phoneLabel (from addressbook of phone type), index
extern NSString * const UniquePhoneIdentifierFormat;
// @"(%@) %@"		- phone number detail text label
extern NSString * const PhoneNumberDisplayFormat;

// regular expression pattern
// @"\d*"       - convert string phone number into digits
extern NSString * const PhoneNumberDigitsPattern;

// tableview cell id
// contact list cellId
extern NSString * const ContactListTableViewCellId;
// favorites list cellId 
extern NSString * const FavoritesListTableViewCellId;
// detail list cellId
extern NSString * const DetailListTableViewCellId;

// tableview section names
// favorites list
extern NSString * const FavoritesSectionName;
// general contact list
extern NSString * const GeneralContactsSectionName;

// UIView titles
// general contacts list, tableview
extern NSString * const InitialWindowTitle;

// image filenames
// empty box no checkmark
extern NSString * const EmptyBoxImageTitle;
// box with checkmark
extern NSString * const BoxWithCheckmarkImageTitle;

// favorites filename
extern NSString * const FavoritesFileName;

// UserDefaults Keys
extern NSString * const M5DialCmd;
extern NSString * const M5AnswerCmd;
extern NSString * const M5IgnoreCmd;
extern NSString * const M5ReleaseCmd;
extern NSString * const M5HoldCmd;
extern NSString * const M5ListCallsCmd;
extern NSString * const M5ResumeCmd;

// KeyChainItem Keys
extern NSString * const M5UserAccountName;
extern NSString * const M5UserAccountPassword;
extern NSString * const KeychainUserPasswordIdentifier;
extern NSString * const KeychainPhoneNumberIdendifier;

// LoginInfo Headers
extern NSString * const UserNameName;
extern NSString * const PasswordName;
extern NSString * const CallbackNumberName;

// loginInfoView tag for secure field
extern NSInteger const kPasswordTag;

// table view section numbers
enum {
    kPasswordSection = 0,
    kSourcePhoneNumberSection,
    kShowCleartextSection,
    kUsernameSection = 99,
};

enum {
    kCallingName = 0,
    kPhoneNumberCalling,
    kProgressIndictor,
    kRetryConnection
};

typedef enum {
    kWaitingToConnect = 1,
    kConnectingConnection,
    kCompletedConnection,
    kCancelledConnection,
    kErroredConnection
} ConnectionStatus;

// DialingView Headers
extern NSString * const CallingName;
extern NSString * const PhoneNumberCalling;
extern NSString * const ProgressIndicator;

// Connection Statuses
extern NSString * const WaitingToConnect;
extern NSString * const ConnectingConnection;
extern NSString * const CompletedConnection;
extern NSString * const CancelledConnection;
extern NSString * const ErroredConnection;

// NSNotificationCenter Notification Names
extern NSString * const ContactsReloaded;
extern NSString * const FavoritesReloaded;

// M5 get commands https strings
extern NSString * const M5HostAddress;
extern NSString * const M5HostPath;

extern NSString * const M5DialCmdFormat;
extern NSString * const M5AnswerCmdFormat;
extern NSString * const M5IgnoreCmdFormat;
extern NSString * const M5ReleaseCmdFormat;
extern NSString * const M5ListCallsCmdFormat;
extern NSString * const M5HoldCmdFormat;
extern NSString * const M5ResumeCmdFormat;









//
