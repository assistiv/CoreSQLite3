//
//  Tests.h
//  Tests
//
//  Created by Mirek Rusin on 10/02/2011.
//  Copyright 2011 Inteliv Ltd. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "CoreSQLite3.h"

@interface Tests : SenTestCase {
@private
  SQLite3ConnectionRef connection;
}

@end
