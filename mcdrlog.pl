#!/usr/bin/perl

# cdrlog.pl by sean caron (scaron@umich.edu)

# this just reads data from a serial port hooked up to a
# TTY port of a nortel meridian with USER SCH CTY set and
# provides a little post processing to massage out some
# undesired control characters and then logs the desired
# data to a file.

use Device::SerialPort;

$logfile = "/usr/local/apache/sites/wwwoss/meridiancdr.log";

# meridian is hooked up to tty1 on our server; set serial
# parameters to match the TTY in the ADAN record on the
# meridian.

$ob = Device::SerialPort->new ('/dev/cuau1');

$ob->baudrate(9600);
$ob->parity('none');
$ob->databits(8);
$ob->stopbits(1);

$ob->write_settings;

$ob->handshake('none');

# these settings basically determine the polling interval for
# the serial port; if you find that the logger is running the
# load average up too much, you can increase these values and
# it should help (value in msec).

$ob->read_const_time(250);
$ob->read_char_time(250);

open LOGFIL, (">>" . $logfile);

$t_line = "";

while (1) {
    # read in a character at a time from the serial port
    ($count_in, $char_in) = $ob->read(1);

    # ignore NULs and LFs otherwise add it to the tail of
    # the line buffer

    if (($char_in ne "\x00") && ($char_in ne "\x0d")) {
        $t_line = $t_line . $char_in;
    }

    # when a full line of text has been obtained, verify
    # that it is a cdr record and if so, add it to the
    # log

    if ($char_in eq "\n") {
        if ( ((substr $t_line, 0, 1) eq "N") && ((substr $t_line, 1, 1) eq " ") ) {
            syswrite LOGFIL, $t_line;
        }	

        $t_line = "";
    }
}

close LOGFIL;

undef $ob;

