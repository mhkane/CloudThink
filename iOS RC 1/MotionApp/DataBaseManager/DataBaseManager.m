//
//  DataBaseManager.m

#import "DataBaseManager.h"
#import <sqlite3.h>

#define DATABASE_NAME	@"MotionApp.sqlite"
#define strDocumentPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define strResourcePath [[NSBundle mainBundle] resourcePath]

@implementation DataBaseManager


- (id)init {
    self = [super init];
    
    return self;
}


//RecordObject Methods
- (NSMutableArray *)selectRecords
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat: @"yyyy-MM-dd HH:mm:ss:SSSS"];
    NSMutableArray * recordArray = [[NSMutableArray alloc]init];
    
    NSString *dbPath = [NSString stringWithFormat:@"%@/%@", strDocumentPath,DATABASE_NAME];
    
    sqlite3 *database = nil;
    sqlite3_stmt *selectStmt = nil;
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
        const char *sql = "select * from Record";
        NSLog(@"it is working: %d",sqlite3_prepare_v2(database, sql, -1, &selectStmt, NULL));
        
        if(sqlite3_prepare_v2(database, sql, -1, &selectStmt, NULL) == SQLITE_OK) {
            
            NSLog(@"error: %d",sqlite3_step(selectStmt));
            while(sqlite3_step(selectStmt) == SQLITE_ROW)
            {
                RecordObject * recordObject = [[RecordObject alloc]init];
                
                recordObject.record_id = sqlite3_column_int(selectStmt, 0);
                
                recordObject.record_name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStmt, 1)];
                
                recordObject.record_time = [formatter dateFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStmt, 2)]];
                
                recordObject.record_duration = sqlite3_column_int(selectStmt, 3);
                
                recordObject.isGpsOn = sqlite3_column_int(selectStmt, 4);
                
                recordObject.isGyroOn = sqlite3_column_int(selectStmt, 5);
                
                recordObject.isAccOn = sqlite3_column_int(selectStmt, 6);
                
                recordObject.isComOn = sqlite3_column_int(selectStmt, 7);
                
                [recordArray addObject:recordObject];
            }
            
        }
    }
    
    //Even though the open call failed, close the database connection to release all the memory.
    sqlite3_finalize(selectStmt);
    sqlite3_close(database);
    
    //return ret;
    
    return recordArray;
}


- (void)insertRecord:(RecordObject *)record
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss:SSSS"];
    NSString *dbPath = [NSString stringWithFormat:@"%@/%@", strDocumentPath,DATABASE_NAME];
    
	sqlite3 *database = nil;
	sqlite3_stmt *addStmt = nil;
	if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
    {
		const char *sql = "insert into Record(record_id,record_name,record_time,record_duration,isGpsOn,isGyroOn,isAccOn,isComOn) Values(?,?,?,?,?,?,?,?)";
        
    
		if(sqlite3_prepare_v2(database, sql, -1, &addStmt, NULL) == SQLITE_OK)
        {
            
            NSLog(@"db is okay: %d",sqlite3_prepare_v2(database, sql, -1, &addStmt, NULL));
            
            sqlite3_bind_int (addStmt, 1, record.record_id);
            sqlite3_bind_text(addStmt, 2, [record.record_name UTF8String], -1, SQLITE_TRANSIENT);
            
            NSString * str = [formatter stringFromDate:record.record_time];
            
            sqlite3_bind_text(addStmt, 3, [str UTF8String], -1, SQLITE_TRANSIENT);

            sqlite3_bind_int (addStmt, 4, record.record_duration);
            
            sqlite3_bind_int (addStmt, 5, record.isGpsOn);
            
            sqlite3_bind_int (addStmt, 6, record.isGyroOn);
            
            sqlite3_bind_int (addStmt, 7, record.isAccOn);
            
            sqlite3_bind_int (addStmt, 8, record.isComOn);
            
			if(SQLITE_DONE != sqlite3_step(addStmt))
            {
				
			}
			else{
            }
            
            sqlite3_last_insert_rowid(database);
			
            
            
            sqlite3_finalize(addStmt);
            sqlite3_close(database);
            
            
        }
        
    }

}


- (void)updateRecord:(RecordObject *)record
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat: @"yyyy-MM-dd HH:mm:ss:SSSS"];
    
    NSString *dbPath = [NSString stringWithFormat:@"%@/%@", strDocumentPath,DATABASE_NAME];
	sqlite3 *database = nil;
	sqlite3_stmt *updateStmt = nil;
	if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
		const char *sql = "update Record set where record_id = ?,record_name = ?,record_time = ?,record_duration = ? isGpsOn = ?,isGyroOn = ?,isAccOn = ?,isComOn = ?,";
        
        NSLog(@"ok value::: %d",sqlite3_prepare_v2(database, sql, -1, &updateStmt, NULL));
        
		if(sqlite3_prepare_v2(database, sql, -1, &updateStmt, NULL) == SQLITE_OK) {
            
            RecordObject * recordObject = [[RecordObject alloc]init];

             sqlite3_bind_int(updateStmt, 1, recordObject.record_id);
            
            sqlite3_bind_text(updateStmt, 2, [recordObject.record_name UTF8String], -1, SQLITE_TRANSIENT);

            NSString * str = [formatter stringFromDate:record.record_time];
            
            sqlite3_bind_text(updateStmt, 2, [str UTF8String], -1, SQLITE_TRANSIENT);
            
            sqlite3_bind_int(updateStmt, 3, recordObject.record_duration);
            
            sqlite3_bind_int(updateStmt, 4, recordObject.isGyroOn);
            
            sqlite3_bind_int(updateStmt, 5, recordObject.isGpsOn);
            
            sqlite3_bind_int(updateStmt, 6, recordObject.isComOn);
            
            sqlite3_bind_int(updateStmt, 7, recordObject.isAccOn);
            
            if(SQLITE_DONE != sqlite3_step(updateStmt)){
				
			}
			else{
				
			}
		}
		else {
			
		}
		
	}
	else{
		//ret = NO;
	}
	
	//Even though the open call failed, close the database connection to release all the memory.
	sqlite3_finalize(updateStmt);
	sqlite3_close(database);
	

}


- (void)deleteRecord:(int )record_id
{
    NSString *dbPath = [NSString stringWithFormat:@"%@/%@", strDocumentPath,DATABASE_NAME];
    sqlite3 *database = nil;
    sqlite3_stmt *delStmt = nil;
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
        const char *sql = "delete from Record where record_id = ?";
        
        if(sqlite3_prepare_v2(database, sql, -1, &delStmt, NULL) == SQLITE_OK) {
            
            sqlite3_bind_int(delStmt,1,record_id);
            
            if(SQLITE_DONE != sqlite3_step(delStmt)){
                
            }
        }
        
        else {
            
        }
        
    }
    else{
        
    }
    
    sqlite3_finalize(delStmt);
    sqlite3_close(database);
    

}


//GpsObject Methods
- (NSMutableArray *)selectGps
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss:SSSS"];
    NSMutableArray * gpsArray = [[NSMutableArray alloc]init];
    
    NSString *dbPath = [NSString stringWithFormat:@"%@/%@", strDocumentPath,DATABASE_NAME];
    
    sqlite3 *database = nil;
    sqlite3_stmt *selectStmt = nil;
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
        const char *sql = "select * from Gps";
        NSLog(@"it is working: %d",sqlite3_prepare_v2(database, sql, -1, &selectStmt, NULL));
        
        if(sqlite3_prepare_v2(database, sql, -1, &selectStmt, NULL) == SQLITE_OK) {
            
            
            while(sqlite3_step(selectStmt) == SQLITE_ROW)
            {
                GpsObject * gpsObject = [[GpsObject alloc]init];
                
                gpsObject.gps_id = sqlite3_column_int(selectStmt, 0);
                
                gpsObject.record_id = sqlite3_column_int(selectStmt, 1);
                
                gpsObject.lat = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStmt, 2)];
                
                gpsObject.log = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStmt, 3)];
                
                gpsObject.height = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStmt, 4)];
                
                gpsObject.timeStamp = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStmt, 5)];
               
                [gpsArray addObject:gpsObject];
            }
            
        }
    }
    
    //Even though the open call failed, close the database connection to release all the memory.
    sqlite3_finalize(selectStmt);
    sqlite3_close(database);
    
    //return ret;
    
    return gpsArray;
}


- (void)insertGps:(GpsObject *)gpsObj WithRecordId:(int) recordId;
{
    NSString *dbPath = [NSString stringWithFormat:@"%@/%@", strDocumentPath,DATABASE_NAME];
    
	sqlite3 *database = nil;
	sqlite3_stmt *addStmt = nil;
	if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
    {
		const char *sql = "insert into Gps(gps_id,record_id,lat,log,height,timeStamp) Values(?,?,?,?,?,?)";
        
		if(sqlite3_prepare_v2(database, sql, -1, &addStmt, NULL) == SQLITE_OK)
        {
            GpsObject * gpsObject = [[GpsObject alloc]init];
            NSLog(@"db is okay: %d",sqlite3_prepare_v2(database, sql, -1, &addStmt, NULL));
            
             sqlite3_bind_int (addStmt, 0, gpsObject.gps_id);
            
            sqlite3_bind_int (addStmt, 1, recordId);
            
            sqlite3_bind_text(addStmt, 2, [gpsObject.lat UTF8String], -1, SQLITE_TRANSIENT);
            
            sqlite3_bind_text(addStmt, 3, [gpsObject.log UTF8String], -1, SQLITE_TRANSIENT);
            
            sqlite3_bind_text(addStmt, 4, [gpsObject.height UTF8String], -1, SQLITE_TRANSIENT);
            
            sqlite3_bind_text(addStmt, 5, [gpsObject.timeStamp UTF8String], -1, SQLITE_TRANSIENT);
            
			if(SQLITE_DONE != sqlite3_step(addStmt))
            {
				
			}
			else{
            }
            
            sqlite3_last_insert_rowid(database);
			
            
            
            sqlite3_finalize(addStmt);
            sqlite3_close(database);
            
            
        }
        
    }
}


- (void)deleteGps:(int)gps_id
{
    NSString *dbPath = [NSString stringWithFormat:@"%@/%@", strDocumentPath,DATABASE_NAME];
    sqlite3 *database = nil;
    sqlite3_stmt *delStmt = nil;
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
        const char *sql = "delete from Gps where gps_id = ?";
        
        if(sqlite3_prepare_v2(database, sql, -1, &delStmt, NULL) == SQLITE_OK) {
            
            sqlite3_bind_int(delStmt,1,gps_id);
            
            if(SQLITE_DONE != sqlite3_step(delStmt)){
                
            }
        }
        
        else {
            
        }
        
    }
    else{
        
    }
    
    sqlite3_finalize(delStmt);
    sqlite3_close(database);
    

}


//GyroObject Methods
- (NSMutableArray *)selectGyro
{
    NSMutableArray * gyroArray = [[NSMutableArray alloc]init];
    
    NSString *dbPath = [NSString stringWithFormat:@"%@/%@", strDocumentPath,DATABASE_NAME];
    
    sqlite3 *database = nil;
    sqlite3_stmt *selectStmt = nil;
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
        const char *sql = "select * from Gyro";
        NSLog(@"it is working: %d",sqlite3_prepare_v2(database, sql, -1, &selectStmt, NULL));
        
        if(sqlite3_prepare_v2(database, sql, -1, &selectStmt, NULL) == SQLITE_OK) {
            
            
            while(sqlite3_step(selectStmt) == SQLITE_ROW)
            {
                GyroScopeObject * gyroObject = [[GyroScopeObject alloc]init];
                
                gyroObject.gyro_id = sqlite3_column_int(selectStmt, 1);
                
                gyroObject.record_id = sqlite3_column_int(selectStmt, 2);
                
                gyroObject.x = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStmt, 3)];
                
                gyroObject.y = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStmt, 4)];
                
                gyroObject.z = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStmt, 5)];
                
                gyroObject.timeStamp = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStmt, 6)];
                
                [gyroArray addObject:gyroObject];
            }
            
        }
    }
    
    //Even though the open call failed, close the database connection to release all the memory.
    sqlite3_finalize(selectStmt);
    sqlite3_close(database);
    
    //return ret;
    
    return gyroArray;
}


- (void)insertGyro:(GyroScopeObject *)gyroObj WithRecordId:(int) recordId;
{
    NSString *dbPath = [NSString stringWithFormat:@"%@/%@", strDocumentPath,DATABASE_NAME];
    
	sqlite3 *database = nil;
	sqlite3_stmt *addStmt = nil;
	if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
    {
		const char *sql = "insert into Gyro(gyro_id,record_id,x,y,z,timeStamp) Values(?,?,?,?,?,?)";
        
		if(sqlite3_prepare_v2(database, sql, -1, &addStmt, NULL) == SQLITE_OK)
        {
            GyroScopeObject * gyroObject = [[GyroScopeObject alloc]init];
            NSLog(@"db is okay: %d",sqlite3_prepare_v2(database, sql, -1, &addStmt, NULL));
            
            sqlite3_bind_int (addStmt, 0,  gyroObject.gyro_id);
            
            sqlite3_bind_int (addStmt, 1, recordId);
            
            sqlite3_bind_text(addStmt, 2, [gyroObject.x UTF8String], -1, SQLITE_TRANSIENT);
            
            sqlite3_bind_text(addStmt, 3, [gyroObject.y UTF8String], -1, SQLITE_TRANSIENT);
            
            sqlite3_bind_text(addStmt, 4, [gyroObject.z UTF8String], -1, SQLITE_TRANSIENT);
            
            sqlite3_bind_text(addStmt, 5, [gyroObject.timeStamp UTF8String], -1, SQLITE_TRANSIENT);
            
			if(SQLITE_DONE != sqlite3_step(addStmt))
            {
				
			}
			else{
            }
            
            sqlite3_last_insert_rowid(database);
			
            sqlite3_finalize(addStmt);
            sqlite3_close(database);
        }
    }
}


- (void)deleteGyro:(int)gyro_id
{
    NSString *dbPath = [NSString stringWithFormat:@"%@/%@", strDocumentPath,DATABASE_NAME];
    sqlite3 *database = nil;
    sqlite3_stmt *delStmt = nil;
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
        const char *sql = "delete from Gyro where gyro_id = ?";
        
        if(sqlite3_prepare_v2(database, sql, -1, &delStmt, NULL) == SQLITE_OK) {
            
            sqlite3_bind_int(delStmt,1,gyro_id);
            
            if(SQLITE_DONE != sqlite3_step(delStmt)){
                
            }
        }
        
        else {
            
        }
        
    }
    else{
        
    }
    
    sqlite3_finalize(delStmt);
    sqlite3_close(database);
    

}


//AccelObject Methods
- (NSMutableArray *)selectAccel
{
    NSMutableArray * AccelArray = [[NSMutableArray alloc]init];
    
    NSString *dbPath = [NSString stringWithFormat:@"%@/%@", strDocumentPath,DATABASE_NAME];
    
    sqlite3 *database = nil;
    sqlite3_stmt *selectStmt = nil;
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
        const char *sql = "select * from Accel";
        NSLog(@"it is working: %d",sqlite3_prepare_v2(database, sql, -1, &selectStmt, NULL));
        
        if(sqlite3_prepare_v2(database, sql, -1, &selectStmt, NULL) == SQLITE_OK) {
            
            
            while(sqlite3_step(selectStmt) == SQLITE_ROW)
            {
                AccelObject * accelObject = [[AccelObject alloc]init];
                
                accelObject.accel_id = sqlite3_column_int(selectStmt, 1);
                
                accelObject.record_id = sqlite3_column_int(selectStmt, 2);
                
                accelObject.x = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStmt, 3)];
                
                accelObject.y = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStmt, 4)];
                
                accelObject.z = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStmt, 5)];
                
                accelObject.timeStamp = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStmt, 6)];
                
                [AccelArray addObject:accelObject];
            }
            
        }
    }
    
    //Even though the open call failed, close the database connection to release all the memory.
    sqlite3_finalize(selectStmt);
    sqlite3_close(database);
    
    //return ret;
    
    return AccelArray;
}


- (void)insertAccel:(AccelObject *)accelObj WithRecordId:(int) recordId;
{
    NSString *dbPath = [NSString stringWithFormat:@"%@/%@", strDocumentPath,DATABASE_NAME];
    
	sqlite3 *database = nil;
	sqlite3_stmt *addStmt = nil;
	if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
    {
		const char *sql = "insert into Accel(accel_id,record_id,x,y,z,timeStamp) Values(?,?,?,?,?,?)";
        
		if(sqlite3_prepare_v2(database, sql, -1, &addStmt, NULL) == SQLITE_OK)
        {
            AccelObject * accelObject = [[AccelObject alloc]init];
            NSLog(@"db is okay: %d",sqlite3_prepare_v2(database, sql, -1, &addStmt, NULL));
            
            sqlite3_bind_int (addStmt, 0, accelObject.accel_id);
            
            sqlite3_bind_int (addStmt, 1, recordId);
            
            sqlite3_bind_text(addStmt, 2, [accelObject.x UTF8String], -1, SQLITE_TRANSIENT);
            
            sqlite3_bind_text(addStmt, 3, [accelObject.y UTF8String], -1, SQLITE_TRANSIENT);
            
            sqlite3_bind_text(addStmt, 4, [accelObject.z UTF8String], -1, SQLITE_TRANSIENT);
            
            sqlite3_bind_text(addStmt, 5, [accelObject.timeStamp UTF8String], -1, SQLITE_TRANSIENT);
			if(SQLITE_DONE != sqlite3_step(addStmt))
            {
				
			}
			else{
            }
            
            sqlite3_last_insert_rowid(database);
			
            
            
            sqlite3_finalize(addStmt);
            sqlite3_close(database);
            
            
        }
        
    }

}


- (void)deleteAccel:(int)accel_id
{
    NSString *dbPath = [NSString stringWithFormat:@"%@/%@", strDocumentPath,DATABASE_NAME];
    sqlite3 *database = nil;
    sqlite3_stmt *delStmt = nil;
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
        const char *sql = "delete from Accel where accel_id = ?";
        
        if(sqlite3_prepare_v2(database, sql, -1, &delStmt, NULL) == SQLITE_OK) {
            
            sqlite3_bind_int(delStmt,1,accel_id);
            
            if(SQLITE_DONE != sqlite3_step(delStmt)){
                
            }
        }
        
        else {
            
        }
        
    }
    else{
        
    }
    
    sqlite3_finalize(delStmt);
    sqlite3_close(database);
    

}


//CompassObject Methods
- (NSMutableArray *)selectCompass
{
    NSMutableArray * compassArray = [[NSMutableArray alloc]init];
    
    NSString *dbPath = [NSString stringWithFormat:@"%@/%@", strDocumentPath,DATABASE_NAME];
    
    sqlite3 *database = nil;
    sqlite3_stmt *selectStmt = nil;
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
        const char *sql = "select * from compass";
        NSLog(@"it is working: %d",sqlite3_prepare_v2(database, sql, -1, &selectStmt, NULL));
        
        if(sqlite3_prepare_v2(database, sql, -1, &selectStmt, NULL) == SQLITE_OK) {
            
            
            while(sqlite3_step(selectStmt) == SQLITE_ROW)
            {
                CompassObject * compassObject = [[CompassObject alloc]init];
                
                compassObject.compass_id = sqlite3_column_int(selectStmt, 1);
                
                compassObject.record_id = sqlite3_column_int(selectStmt, 2);
                
                compassObject.magHeading = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStmt, 3)];
                
                compassObject.trueHeading = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStmt, 4)];
                
                compassObject.timeStamp = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStmt, 5)];
                
                
                [compassArray addObject:compassObject];
            }
            
        }
    }
    
    //Even though the open call failed, close the database connection to release all the memory.
    sqlite3_finalize(selectStmt);
    sqlite3_close(database);
    
    //return ret;
    
    return compassArray;
}



- (void)insertCompass:(CompassObject *)compassObj WithRecordId:(int) recordId;
{
    NSString *dbPath = [NSString stringWithFormat:@"%@/%@", strDocumentPath,DATABASE_NAME];
    
	sqlite3 *database = nil;
	sqlite3_stmt *addStmt = nil;
	if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
    {
		const char *sql = "insert into compass(compass_id,record_id,magHeading,trueHeading,z,timeStamp) Values(?,?,?,?,?)";
        
		if(sqlite3_prepare_v2(database, sql, -1, &addStmt, NULL) == SQLITE_OK)
        {
            CompassObject * compassObject = [[CompassObject alloc]init];
            NSLog(@"db is okay: %d",sqlite3_prepare_v2(database, sql, -1, &addStmt, NULL));
            
            sqlite3_bind_int (addStmt, 0, compassObject.compass_id);
            
            sqlite3_bind_int (addStmt, 1, recordId);
            
            sqlite3_bind_text(addStmt, 2, [compassObject.magHeading UTF8String], -1, SQLITE_TRANSIENT);
            
            sqlite3_bind_text(addStmt, 3, [compassObject.trueHeading UTF8String], -1, SQLITE_TRANSIENT);
            
            sqlite3_bind_text(addStmt, 4, [compassObject.timeStamp UTF8String], -1, SQLITE_TRANSIENT);
            
			if(SQLITE_DONE != sqlite3_step(addStmt))
            {
				
			}
			else{
            }
            
            sqlite3_last_insert_rowid(database);
			
            
            
            sqlite3_finalize(addStmt);
            sqlite3_close(database);
            
            
        }
        
    }

}


- (void)deleteCompass:(int)compass_id
{
    NSString *dbPath = [NSString stringWithFormat:@"%@/%@", strDocumentPath,DATABASE_NAME];
    sqlite3 *database = nil;
    sqlite3_stmt *delStmt = nil;
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
        const char *sql = "delete from Compass where compass_id = ?";
        
        if(sqlite3_prepare_v2(database, sql, -1, &delStmt, NULL) == SQLITE_OK) {
            
            sqlite3_bind_int(delStmt,1,compass_id);
            
            if(SQLITE_DONE != sqlite3_step(delStmt)){
                
            }
        }
        
        else {
            
        }
        
    }
    else{
        
    }
    
    sqlite3_finalize(delStmt);
    sqlite3_close(database);
    

}


@end
