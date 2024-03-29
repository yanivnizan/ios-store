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

#import "VirtualItem.h"
#import "JSONConsts.h"

@implementation VirtualItem

@synthesize name, description, imgFilePath, itemId;

- (id)init{
    self = [super init];
    if ([self class] == [VirtualItem class]) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
               reason:@"Error, attempting to instantiate AbstractClass directly." userInfo:nil];
    }
    
    return self;
}
- (id)initWithName:(NSString*)oName andDescription:(NSString*)oDescription
    andImgFilePath:(NSString*)oImgFilePath andItemId:(NSString*)oItemId{
    self = [super init];
    if ([self class] == [VirtualItem class]) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:@"Error, attempting to instantiate AbstractClass directly." userInfo:nil];
    }
    
    if (self) {
        self.name = oName;
        self.description = oDescription;
        self.imgFilePath = oImgFilePath;
        self.itemId = oItemId;
    }
    
    return self;
}

- (id)initWithDictionary:(NSDictionary*)dict{
    self = [super init];
    if ([self class] == [VirtualItem class]) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:@"Error, attempting to instantiate AbstractClass directly." userInfo:nil];
    }
    
    if (self) {
        self.name = [dict objectForKey:JSON_ITEM_NAME];
        self.description = [dict objectForKey:JSON_ITEM_DESCRIPTION];
        self.imgFilePath = [dict objectForKey:JSON_ITEM_IMAGEFILEPATH];
        self.itemId = [dict objectForKey:JSON_ITEM_ITEMID];
    }
    
    return self;
}

- (NSDictionary*)toDictionary{
    return [[NSDictionary alloc] initWithObjectsAndKeys:
                          self.name, JSON_ITEM_NAME,
                          self.description, JSON_ITEM_DESCRIPTION,
                          self.imgFilePath, JSON_ITEM_IMAGEFILEPATH,
                          self.itemId, JSON_ITEM_ITEMID,
                          nil];
}


@end
