//
//  MEPreferencesController.h
//  Marshwort
//
//  Created by Andrey M. on 25.03.13.
//  Copyright (c) 2013 Andrey M. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DBPrefsWindowController.h"

@interface MEPreferencesController : DBPrefsWindowController

@property (strong, nonatomic) IBOutlet NSView *generalPreferenceView;
@property (strong, nonatomic) IBOutlet NSView *updatesPreferenceView;

@end
