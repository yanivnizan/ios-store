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

#import <Foundation/Foundation.h>

@class StorefrontViewController;

/**
 * SOOMLA's ios sdk uses this class as an interface between the
 * webview's JS and the native code.
 */
@interface StorefrontJS : NSObject <UIWebViewDelegate>{
    @private
    StorefrontViewController* sfViewController;
}

@property (nonatomic, retain) StorefrontViewController* sfViewController;

/** Constructor
 *
 * StorefrontViewController is the main UIViewController that holds the storefront.
 */
- (id)initWithStorefrontViewController:(StorefrontViewController*)sfvc;

/**
 * Sends the virtual currency and virtual goods updated data to the webview's JS.
 */
- (void)updateContentInJS;
@end
