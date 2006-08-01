#! /usr/bin/perl

# $Id$
use Socket;

$hostname  = $ARGV[0];
$checkport = $ARGV[1];
$HTTPDOCS{"ALL"} = [ "/index.html" ];
$HTTPPORT{"ALL"} = 80;
$HTTPURLS{"DEFAULT"} = [ "http://_HOST_/" ];
$PSQL    = "/usr/bin/pgsql/bin/psql";
$DBUSER  = "pgsql";

if ($checkport eq "ssh") {
	($color, $summary, $message) = check_ssh($hostname);
}
elsif ($checkport eq "smtp") {
	($color, $summary, $message) = check_smtp($hostname);
}
elsif ($checkport eq "pop3") {
	($color, $summary, $message) = check_pop3($hostname);
}
elsif ($checkport eq "ftp") {
	($color, $summary, $message) = check_ftp($hostname);
}
elsif ($checkport eq "http") {
	($color, $summary, $message) = check_http($hostname);
}
elsif ($checkport eq "https") {
	($color, $summary, $message) = check_http($hostname);
}
elsif ($checkport eq "pgsql") {
	($color, $summary, $message) = check_pgsql($hostname);
}
else {
	print "usage: chkport.pl host (ssh|smtp|pop3|ftp|http|pgsql)\n";
	exit 1;
}

print "color   = $color\n";
print "summary = $summary\n";
print "message = $message";

if ($color ne "green") {
	exit 1;
} else {
	exit 0;
}

# Check the ssh service with the built-in check_simple routine
sub check_ssh {
    my ($host) = @_;
    return &check_simple( $host, 22, "", "^SSH", "ssh" );
}

# Check the smtp service with the built-in check_simple routine
sub check_smtp {
    my ($host) = @_;
    return &check_simple( $host, 25, "quit\n", "^\s*220", "smtp" );
}

# Check the pop3 service with the built-in check_simple routine
sub check_pop3 {
    my ($host) = @_;
    return &check_simple( $host, 110, "quit\n", "^\\+OK", "pop3" );
}

# Check the ftp service with the built-in check_simple routine
sub check_ftp {
    my ($host) = @_;
    return &check_simple( $host, 21, "quit\n", "^\s*220", "ftp" );
}

# Check the http service 
sub check_http {

   my( $host ) = @_;
   my( @http_files ) = ( @{$HTTPDOCS{"ALL"}}, @{$HTTPDOCS{$host}} );
   my( $http_port ) = $HTTPPORT{$host} || $HTTPPORT{"ALL"} || 80;

   # Find list of URL's to check
   my( @http_urls ) = @{$HTTPURLS{$host}};
   @http_urls = @{$HTTPURLS{'DEFAULT'}}  if( ! @http_urls );
   @http_urls = @{$HOSTS{$host}->{'http_urls'}} if( ! @http_urls );
   @http_urls = @{$HOSTS_DEFAULTS{'http_urls'}} if( ! @http_urls );

   # Append mandatory urls to check
   @http_urls = ( @http_urls, @{$HOSTS_ALL{'http_urls'}} );

   my( $file, $tmessage ) = ( "", "" );
   my( $color, $summary ) = ( "green", "" );

   # If HTTP URLS are defined use the URL check
   if ( @http_urls ) {
      foreach my $url (@http_urls) {
         # Parse the URL into it's components
         $url =~ s|^http://||;  # Remove the protocol id if present
         my($hpart,$urlpath) = ( $url =~ m|^([^/]+)(/.*)| );
         my($hname,$port) = split(/:/,$hpart);
         $port = 80 if ! $port;
         #$hname = $host if ( ! $hname || $hname eq '_HOST_' );
         if ( ! $hname ) {
            $hname = $host;
         } elsif ( $hname eq '_HOST_' ) {
            $hname = $host;
            $url =~ s/_HOST_/$host/;
         }

         my $message =
            &check_tcp( $hname, $port,
               "HEAD $urlpath HTTP/1.1\r\nHost: $hname:$port\r\n\r\n", 10 );

         if( $message =~ /HTTP\S+\s+(\d\d\d)\s.*$/m ) {
            my $code = $1;

            if( $code >= 500 ) {
               $color = "red"; $summary = "http error - $code - $url";
               # Treat a 401 (authorization Required) code as a green
            } elsif( $code >= 400 && $code != 401) {
               if( $color ne "red" ) {
                  $color = "yellow"; $summary = "http warning - $code - $url"; }
            } else {
               if( $color ne "red" && $color ne "yellow" ) {
                  $color = "green"; $summary = "http ok - $code"; }
            }
         } elsif( $message !~ /HTTP/m ) {
            $color = "red"; $summary = "no response from http server";
         } else {
            if( $color ne "red" ) {
               $color = "yellow"; $summary = "can't determine status code";}
         }
         $tmessage .= "->HEAD $urlpath HTTP/1.1\nHost: $hname:$port\n$message\n\n";
      }

   } else {

      foreach $file ( @http_files ) {
         my $message =
            &check_tcp( $host, $http_port, "HEAD $file HTTP/1.0\r\n\r\n", 10 );

         if( $message =~ /HTTP\S+\s+(\d\d\d)\s.*$/m ) {
            my $code = $1;

            if( $code >= 500 ) {
               $color = "red"; $summary = "http error - $code - $file";
               # Treat a 401 (authorization Required) code as a green
            } elsif( $code >= 400 && $code != 401) {
               if( $color ne "red" ) {
                  $color = "yellow"; $summary = "http warning - $code - $file";
               }
            } else {
               if( $color ne "red" && $color ne "yellow" ) {
                  $color = "green"; $summary = "http ok - $code"; }
            }
         } elsif( $message !~ /HTTP/m ) {
            $color = "red"; $summary = "no response from http server";
         } else {
            if( $color ne "red" ) {
               $color = "yellow"; $summary = "can't determine status code";}
         }
         $tmessage .= "->HEAD $file HTTP/1.0\n$message\n\n";
      }
   }

   return( $color, $summary, $tmessage );
}

# Check the pgsql service 
sub check_pgsql {

   my( $host ) = @_;
   my( $color, $summary, $message ) = ( "green", "Server OK", "" );

   open (SQL,"$PSQL -h $host -U $DBUSER -l 2>&1 |") || warn "Could not exec $PSQL for status info.";

   while (<SQL>) {
      $message .= $_;
      if (/Operation timed out/) {
         $color = "red"; $summary = "Server is down.";
      }
      if (/Connection refused/) {
         $color = "red"; $summary = "Server is unreachable.";
      }
      if (/Access denied/) {
         $color = "yellow"; $summary = "Server is up, but access is denied.";
      }
   }
  
   return( $color, $summary, $message );
}


# A generic tcp port checking routine.  You give this function a hostname, a
# port, a message to send (can be ""), a return regular expression string to 
# check for, and the name of the service.  This will go out connect to that
# port and check to make sure you get back expected results.

sub check_simple {
   my( $host, $port, $send, $check, $service ) = @_;
   my( $color, $summary ) = ( "red", "" );
   my( $attempt, $start, $message, $diff, $errcd );

   for $timeout ( 3, 5, 12 ) {
      $start = time();
      ($errcd, $message) = &check_tcp($host, $port, $send, $timeout);
      $diff = time() - $start;

      $attempt++;
      if( $message =~ /$check/ ) { $color = "green"; last; }
   }

   $diff = sprintf("%.3f",$diff);

   $summary = "$service is down, $errcd" if $color eq "red" and $errcd;
   $summary = "$service ok - $diff second response time" if $color eq "green";
   $summary .= ", attempt $attempt" if ($attempt != 1 && $color eq "green");
      
   return(  $color, $summary, $message );
}

# ---------------------------------------------------------------------------
# &check_tcp( HOST, PORT, DATA, TIMEOUT, MAXLEN )
#
# This function will make a connection to a port at a given port, and send a
# message, it will then return what it gets back to the caller of this
# function.
# ---------------------------------------------------------------------------

sub check_tcp {
   my( $addr, $port, $data, $timeout, $maxlen ) = @_;
   my( $iaddr, $paddr, $proto, $line, $ip, $sock, $err );

   if( $addr =~ /^\s*((\d+\.){3}\d+)\s*$/ ) {
      $ip = $addr;
   } else {
      my( @addrs ) = (gethostbyname($addr))[4];
      if ( ! @addrs ) { return ( 1, "" ); }
      my( $a, $b, $c, $d ) = unpack( 'C4', $addrs[0] );
      $ip = "$a.$b.$c.$d";
   }

   $timeout = 5  if ( ! defined $timeout || $timeout <= 0);
   $maxlen = 256 if ( ! defined $maxlen  || $maxlen  <= 0);

   $err = 0;
   $line = "";
   $msg = "";

   $iaddr = inet_aton( $ip )                    || return -1;
   $paddr = sockaddr_in( $port, $iaddr );
   $proto = getprotobyname( 'tcp' );
 
   # Set an alarm so that if we can't connect "immediately" it times out.
   # Poor man's exception handling in perl...
   
   eval {
      local $SIG{'ALRM'} = sub { die "Socket timed out"; };
      alarm($timeout);

      socket( SOCK, PF_INET, SOCK_STREAM, $proto ) || die "socket: $!";
      connect( SOCK, $paddr )                      || die "connect: $!";
      select((select(SOCK), $| = 1)[0]);
      print SOCK "$data";
      while (length($msg) < $maxlen) {
         recv( SOCK, $line, 256, 0 );
         $msg .= $line;
         if (length($line) == 0) { alarm(0); return; } # If the socket is closed, return
      }
      alarm(0);
      close( SOCK ) || die "close: $!";
   };

   if ( $@ =~ /^(.*) at/ ) { $err = $1; }
   if ( $@ =~ /timed out/ )  { $err = "check_tcp timed out"; }
   if ( $@ =~ /connect:(.*) at/ )   { $err = $1; }

   return ($err,$msg);
}

