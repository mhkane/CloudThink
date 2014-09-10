#!/usr/bin/python
from twisted.protocols.basic import LineReceiver
from twisted.internet.protocol import Protocol, Factory
from twisted.internet import reactor
import MySQLdb, syslog

syslog.openlog(logoption=syslog.LOG_PID, facility=syslog.LOG_DAEMON)

SERVER_PORT=5114

DB_HOST='localhost'
DB_USER='DataLogger'
DB_PASSWORD='cloudcar12!'
DB_NAME='dotdb'

def debug(message):
	syslog.syslog(syslog.LOG_DEBUG, message)
	print 'DEBUG: ' + message

try:
	db = MySQLdb.connect (host = DB_HOST, user = DB_USER, passwd = DB_PASSWORD, db = DB_NAME )
	cursor = db.cursor()
	debug('DOT DB ready.')
except MySQLdb.Error, e:
	error='Error:DB connection:' + str(e.args[0]) + ':' + e.args[1]
	debug(error)
	sys.exit(1);

class MultiEcho(LineReceiver):
	def __init__(self, factory):
		self.factory = factory
		#file = open("./Users/jsiegel/Desktop/%s" % 'datalog.log', 'w+')

	def connectionMade(self):
		p = self.transport.getPeer()
		self.factory.echoers.append(self)
		self.peer = '%s:%s' % (p.host, p.port)
		info='Connected from ' + self.peer
		debug(info)
		self.APP_TYPE=None
		self.USER_ID=None
		self.ACTIVE_CASE=None
		self.UID_TABLENAME=None

	def getClient(self):
		return self.transport.getPeer( ).host;

	def lineReceived(self, line):
		#file.write(line)
		line = line.strip()
		# log line to file

		if len(line) <=0:
			line='NULL'
		try:
			debug('GOT DATA:\n\t'+line+'\n')
		except TypeError:
			debug('Type error - not a line!')
			line = 'NULL' # Set to type string
		except:
			debug('Some other type of error!')
			line = 'NULL'

		if line != 'NULL':
			try:
				if line.find('START') == 0: # found the start of a new file
					debug('Start line found')
					split_line = line.split(',')
					if split_line[1] == 'IOS':
						self.APP_TYPE='iOS'
						debug('Starting iOS App')
					if split_line[1] == 'ANDROID':
						self.APP_TYPE='Android'
						debug('Starting Android App')
				elif line.find('USER') == 0: # found the username
					split_line = line.split(',') 					# Split line at commas for this string (which is also fixed length)
					self.USER_ID = split_line[1]
					debug('User ID: ' + self.USER_ID)
					self.UID_TABLENAME='UID'+self.USER_ID
					# Check if table has been created - if not, create it now
					# Check if table exists, else create table
					sql = 'SHOW COLUMNS FROM ' + DB_NAME + '.' + self.UID_TABLENAME + ''

					try:
						cursor.execute(sql)				# Try to execute command
						db.commit()
						debug('Table \'' + self.UID_TABLENAME + '\' exists.')

					except MySQLdb.Error, e:
						error='Error:DB connection:' + str(e.args[0]) + ':' + e.args[1]
						db.rollback()
						debug('Table ' + self.UID_TABLENAME + ' does not exist in DB. Creating new table.')
						newsql = 'CREATE TABLE IF NOT EXISTS `'+self.UID_TABLENAME+'` ( `ID` int(11) NOT NULL AUTO_INCREMENT, `IP` varchar(21) DEFAULT NULL, `Timestamp` bigint(20) DEFAULT NULL, `ACCEX` double DEFAULT NULL, `ACCEY` double DEFAULT NULL, `ACCEZ` double DEFAULT NULL, `COMPX` double DEFAULT NULL, `COMPY` double DEFAULT NULL, `GYROX` double DEFAULT NULL, `GYROY` double DEFAULT NULL, `GYROZ` double DEFAULT NULL, `GPSLatitude` double(9,7) DEFAULT NULL, `GPSLongitude` double(10,7) DEFAULT NULL, `Altitude` double(7,2) DEFAULT NULL, `Estimate` text, `Ground` text, `CloudThink` text, PRIMARY KEY (`ID`), UNIQUE KEY `ID` (`ID`) ) ENGINE=MyISAM  DEFAULT CHARSET=latin1;'
						try:
							cursor.execute(newsql)
							db.commit()
						except MySQLdb.Error, e:
							error='Error:DB connection:' + str(e.args[0]) + ':' + e.args[1]
							db.rollback()
							debug(error)

				elif self.APP_TYPE is not None:
					if self.APP_TYPE=='iOS':
		#				debug('Parsing like an iOS app')
						if line.find('CONTEXT') == 0:
							debug('Found CONTEXT')
							self.ACTIVE_CASE='Context'
							debug('Starting Context block')
						elif line.find('GPS') == 0:
							self.ACTIVE_CASE='GPS'
							debug('Starting GPS block')
						elif line.find('COMPASS') == 0:
							self.ACTIVE_CASE='Compass'
							debug('Starting Compass block')
						elif line.find('ACCEL') == 0:
							self.ACTIVE_CASE='Accel'
							debug('Starting Accel block')
						elif line.find('GYRO') == 0:
							self.ACTIVE_CASE='Gyro'
							debug('Starting Gyro block')
						elif line.find('GROUND') == 0:
							self.ACTIVE_CASE='Ground'
							debug('Starting Ground block')
						elif line.find('END') == 0:
							self.ACTIVE_CASE=None
							self.USER_ID = None
							self.APP_TYPE = None
							debug('Ending')
						else: # This is a data line - check the active header
							if (self.ACTIVE_CASE == 'Context'):
								debug('Parsing Context line')
								split_line = line.split(',')
								Context = split_line[0]
								Timestamp = split_line[1]
								Timesplit = Timestamp.split(' ')
								TimesplitA = Timesplit[1].split('-')
								TimesplitB = Timesplit[2].split(':')
								Year = TimesplitA[0]
								Month = TimesplitA[1]
								Day = TimesplitA[2]
								Hour = TimesplitB[0]
								Minute = TimesplitB[1]
								Seconds = TimesplitB[2]
								Milliseconds = TimesplitB[3]

								TimeText = Year+Month+Day+Hour+Minute+Seconds+Milliseconds
								sql = 'INSERT INTO `' + DB_NAME + '`.`' + self.UID_TABLENAME + '` (`Timestamp`, `Estimate`) VALUES (\'' + TimeText + '\', \'' + Context + '\');'
								#debug('SQL: '+sql)
								try:
									cursor.execute(sql)				# Fetch rows from VIN database
									db.commit()
								except MySQLdb.Error, e:
									db.rollback()
									error='Failed to execute SQL:'  + str(e.args[0]) + ':' + e.args[1]
									syslog.syslog(syslog.LOG_ERR, error)
									print error

							elif (self.ACTIVE_CASE == 'GPS'):
								debug('Parsing GPS line')
								split_line = line.split(',')
								Latitude = split_line[0]
								Longitude = split_line[1]
								Altitude = split_line[2]
								Timestamp = split_line[3]
								Timesplit = Timestamp.split(' ')
								TimesplitA = Timesplit[1].split('-')
								TimesplitB = Timesplit[2].split(':')
								Year = TimesplitA[0]
								Month = TimesplitA[1]
								Day = TimesplitA[2]
								Hour = TimesplitB[0]
								Minute = TimesplitB[1]
								Seconds = TimesplitB[2]
								Milliseconds = TimesplitB[3]

								TimeText = Year+Month+Day+Hour+Minute+Seconds+Milliseconds
								sql = 'INSERT INTO `' + DB_NAME + '`.`' + self.UID_TABLENAME + '` (`Timestamp`, `GPSLatitude`, `GPSLontitude`) VALUES (\'' + TimeText + '\', \'' + Latitude + '\', \'' + Longitude + '\');'
								#debug('SQL: '+sql)
								try:
									cursor.execute(sql)				# Fetch rows from VIN database
									db.commit()
								except MySQLdb.Error, e:
									db.rollback()
									error='Failed to execute SQL:'  + str(e.args[0]) + ':' + e.args[1]
									syslog.syslog(syslog.LOG_ERR, error)
									print error


							elif (self.ACTIVE_CASE == 'Compass'):
								debug('Parsing Compass line')
								split_line = line.split(',')
								RotX = split_line[0]
								RotY = split_line[1]
								Timestamp = split_line[2]
								Timesplit = Timestamp.split(' ')
								TimesplitA = Timesplit[1].split('-')
								TimesplitB = Timesplit[2].split(':')
								Year = TimesplitA[0]
								Month = TimesplitA[1]
								Day = TimesplitA[2]
								Hour = TimesplitB[0]
								Minute = TimesplitB[1]
								Seconds = TimesplitB[2]
								Milliseconds = TimesplitB[3]

								TimeText = Year+Month+Day+Hour+Minute+Seconds+Milliseconds
								sql = 'INSERT INTO `' + DB_NAME + '`.`' + self.UID_TABLENAME + '` (`Timestamp`, `COMPX`, `COMPY`) VALUES (\'' + TimeText + '\', \'' + RotX + '\', \'' + RotY + '\');'
								#debug('SQL: '+sql)
								try:
									cursor.execute(sql)				# Fetch rows from VIN database
									db.commit()
								except MySQLdb.Error, e:
									db.rollback()
									error='Failed to execute SQL:'  + str(e.args[0]) + ':' + e.args[1]
									syslog.syslog(syslog.LOG_ERR, error)
									print error


							elif (self.ACTIVE_CASE == 'Accel'):
								debug('Parsing Accel line')
								split_line = line.split(',')
								AccelX = split_line[0].replace('g','')
								AccelY = split_line[1].replace('g','')
								AccelZ = split_line[2].replace('g','')
								Timestamp = split_line[3]
								Timesplit = Timestamp.split(' ')
								TimesplitA = Timesplit[1].split('-')
								TimesplitB = Timesplit[2].split(':')
								Year = TimesplitA[0]
								Month = TimesplitA[1]
								Day = TimesplitA[2]
								Hour = TimesplitB[0]
								Minute = TimesplitB[1]
								Seconds = TimesplitB[2]
								Milliseconds = TimesplitB[3]

								TimeText = Year+Month+Day+Hour+Minute+Seconds+Milliseconds
								sql = 'INSERT INTO `' + DB_NAME + '`.`' + self.UID_TABLENAME + '` (`Timestamp`, `ACCEX`, `ACCEY`, `ACCEZ`) VALUES (\'' + TimeText + '\', \'' + AccelX + '\', \'' + AccelY + '\', \'' + AccelZ + '\');'
								#debug('SQL: '+sql)
								try:
									cursor.execute(sql)				# Fetch rows from VIN database
									db.commit()
								except MySQLdb.Error, e:
									db.rollback()
									error='Failed to execute SQL:'  + str(e.args[0]) + ':' + e.args[1]
									syslog.syslog(syslog.LOG_ERR, error)
									print error

							elif (self.ACTIVE_CASE == 'Gyro'):
								debug('Parsing Gyro line')
								split_line = line.split(',')
								GyroX = split_line[0]
								GyroY = split_line[1]
								GyroZ = split_line[2]
								Timestamp = split_line[3]
								Timesplit = Timestamp.split(' ')
								TimesplitA = Timesplit[1].split('-')
								TimesplitB = Timesplit[2].split(':')
								Year = TimesplitA[0]
								Month = TimesplitA[1]
								Day = TimesplitA[2]
								Hour = TimesplitB[0]
								Minute = TimesplitB[1]
								Seconds = TimesplitB[2]
								Milliseconds = TimesplitB[3]

								TimeText = Year+Month+Day+Hour+Minute+Seconds+Milliseconds
								sql = 'INSERT INTO `' + DB_NAME + '`.`' + self.UID_TABLENAME + '` (`Timestamp`, `GYROX`, `GYROY`, `GYROZ`) VALUES (\'' + TimeText + '\', \'' + GyroX + '\', \'' + GyroY + '\', \'' + GyroZ + '\');'
								#debug('SQL: '+sql)
								try:
									cursor.execute(sql)				# Fetch rows from VIN database
									db.commit()
								except MySQLdb.Error, e:
									db.rollback()
									error='Failed to execute SQL:'  + str(e.args[0]) + ':' + e.args[1]
									syslog.syslog(syslog.LOG_ERR, error)
									print error


							elif (self.ACTIVE_CASE == 'Ground'):
								debug('Parsing Ground line')
								split_line = line.split(',')
								Ground = split_line[0]
								Timestamp = split_line[1]
								Timesplit = Timestamp.split(' ')
								TimesplitA = Timesplit[1].split('-')
								TimesplitB = Timesplit[2].split(':')
								Year = TimesplitA[0]
								Month = TimesplitA[1]
								Day = TimesplitA[2]
								Hour = TimesplitB[0]
								Minute = TimesplitB[1]
								Seconds = TimesplitB[2]
								Milliseconds = TimesplitB[3]

								TimeText = Year+Month+Day+Hour+Minute+Seconds+Milliseconds
								sql = 'INSERT INTO `' + DB_NAME + '`.`' + self.UID_TABLENAME + '` (`Timestamp`, `Ground`) VALUES (\'' + TimeText + '\', \'' + Ground + '\');'
								#debug('SQL: '+sql)
								try:
									cursor.execute(sql)				# Fetch rows from VIN database
									db.commit()
								except MySQLdb.Error, e:
									db.rollback()
									error='Failed to execute SQL:'  + str(e.args[0]) + ':' + e.args[1]
									syslog.syslog(syslog.LOG_ERR, error)
									print error

							elif (self.ACTIVE_CASE == 'CloudThink'):
								print 'Skipping CloudThink data'

							else:
								debug('Undefined line')
					elif self.APP_TYPE=='Android':
						debug('Parsing like an Android app')
				else:
					debug('Unkown data type')
			except:
				debug('Unhandled error.')
				pass

	def connectionLost(self, reason):
		info=str('Disconnected from %s: %s' % (self.peer, reason.value))
		debug(info)
		self.APP_TYPE=None
		self.USER_ID=None
		self.ACTIVE_CASE=None
		self.UID_TABLENAME=None
		self.factory.echoers.remove(self)

def timestamp():
	now = time.time()
	localtime = time.localtime(now)
	milliseconds = '%03d' % int((now - int(now)) * 1000)
	return time.strftime('%Y%m%d%H%M%S', localtime) + milliseconds

def serverStart( ):
	info='Server ready, listening on port: ' + str(SERVER_PORT)
	syslog.syslog(syslog.LOG_INFO, info )
	debug(info)

class MultiEchoFactory(Factory):
	def __init__(self):
		self.echoers = []

	def buildProtocol(self, addr):
		return MultiEcho(self)

reactor.listenTCP(SERVER_PORT, MultiEchoFactory())
reactor.run()

