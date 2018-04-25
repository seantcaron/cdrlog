#!/usr/bin/perl

# dcdrlog.pl by sean caron (scaron@umich.edu)

# this just listens on a TCP port for connections from a
# definity system configured to send CDR records over IP
# with a C-LAN card.

use IO::Socket;

$logfile = "/usr/local/apache/sites/wwwoss/definitycdr.log";

$i_sock = new IO::Socket::INET (
    LocalHost => 'sonnet.diablonet.net',
    LocalPort => '5514',
    Proto => 'tcp',
    Listen => 1,
    Reuse => 1);

while (1) {
    $next_sock = $i_sock->accept();

    open LOGFIL, (">>" . $logfile);

    while (<$next_sock>) {
        $i_line = $_;

        $t_line = "";

        for ($c = 0; $c < (length $i_line); $c++) {
            $n_char = substr $i_line, $c, 1;

            if (($n_char ne "\x00") && ($n_char ne "\x0d")) {
                $t_line = $t_line . $n_char;
            }
        }

        syswrite LOGFIL, $t_line;
    }

    close LOGFIL;
}

close $i_sock;

