//
//  AppController.h
//  Marshwort
//
//  Created by Andrey M. on 25.03.13.
//  Copyright (c) 2013 Andrey M. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MEPreferencesController;

@interface AppController : NSObject {
    MEPreferencesController *preferencesController;
}

- (IBAction)openPreferences:(id)sender;

@end
