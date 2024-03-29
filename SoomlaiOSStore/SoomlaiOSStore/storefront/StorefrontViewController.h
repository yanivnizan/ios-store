/*
 * Copyright (C) 2012 Soomla Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import <UIKit/UIKit.h>

@class StorefrontJS;

@interface StorefrontViewController : UIViewController{
    @private
    UIWebView* storeWebview;
    NSMutableArray* pendingMessages;
    @public
    BOOL jsUIReady;
    StorefrontJS* storefrontJS;
}

@property (nonatomic, retain) IBOutlet UIWebView* storeWebview;
@property (nonatomic, retain) NSMutableArray* pendingMessages;
@property (nonatomic, retain) StorefrontJS* storefrontJS;
@property BOOL jsUIReady;

- (void)loadWebView;
- (void)sendToJSWithAction:(NSString*)action andData:(NSString*)data;
- (void)closeStore;

@end
