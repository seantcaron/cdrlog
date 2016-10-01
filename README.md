CDR Reporting Utilities for Nortel Meridian and Avaya Definity
--------------------------------------------------------------
Sean Caron scaron@umich.edu

###REQUIRES

Device:SerialPort
IO::Socket

###INSTALLATION

In general:

```
cp cdrlog.tar /usr/local
cd /usr/local
tar xvf cdrlog.tar

cd cdrlog
vi dcdrlog.pl
vi mcdrlog.pl
```

dcdrlog.pl is the CDR logger for Definity platforms.
mcdrlog.pl is the CDR logger for Meridian platforms.

Within each, set variable $logfile to the path of a file where you want the
cdr log data output.

The data is processed somewhat to remove undesirable control characters and
ensure that only cdr records are being logged so it is not entirely raw, but
there is no further postprocessing outside of that. 

Tt would be a fairly trivial exercise to extend the scripts to do more
sophisticated things with the output, such as wrapping it in HTML, or
injecting it into a database.

###USAGE

Nominally, insert the following in your /etc/rc.local or create an init script
in /etc/init.d containing the following:

```
./mcdrlog.pl &
./dcdrlog.pl &
```

###BUGS

* No error checking

