docker run --privileged -it -v /home/forselli/test:/home/forselli/test:ro -v /home/forselli/git/syslog-ng-test/syslog-ng.conf:/etc/syslog-ng/syslog-ng.conf -p 514:514/udp -p 601:601 syslog-ng:test

Run with exporter and debug mode

/usr/sbin/syslog-ng -F -edv
/bin/syslog_ng_exporter \
  --telemetry.address=":9577" \
  --log.format="logger:stderr?appname=syslog-agent" \
  --socket.path="/var/lib/syslog-ng/syslog-ng.ctl"