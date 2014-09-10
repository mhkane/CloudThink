import socket
import sys, syslog

syslog.openlog(logoption=syslog.LOG_PID, facility=syslog.LOG_DAEMON)

SERVER_PORT=5114

def debug(message):
	syslog.syslog(syslog.LOG_DEBUG, message)
	print 'DEBUG: ' + message

# Create a TCP/IP socket
sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

# Bind the socket to the port
server_address = ('', SERVER_PORT)
debug('Starting up on %s port %s' % server_address)
sock.bind(server_address)

# Listen for incoming connections
sock.listen(1)

file = open("DOT_Temp_Log.txt","a")

while True:
    # Wait for a connection
    debug('Waiting for a connection')
    connection, client_address = sock.accept()

    try:
        print >>sys.stderr, 'connection from', client_address

        # Receive the data in small chunks and retransmit it
        while True:
            data = connection.recv(2048)
            debug('GOT DATA:\n\t'+data+'\n')
            if data:
            	print 'Got data'
            	file.write(data)
                #connection.sendall(data)
            else:
            	print 'No more data from device'
            	#print 'No more data from ' + client_address
                break

    finally:
        # Clean up the connection
        file.close()
        connection.close()
