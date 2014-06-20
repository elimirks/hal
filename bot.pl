#!/usr/bin/perl
use strict;
use IO::Socket;

# TODO create some type of object accessible from the modules that will allow to send messages, execute commands, etc.

# Configuration for EVERYTHING.
my %config = (
	identifier=>"halbot",
	nick=>"hal_bot",
	module_dir=>"modules",
	host=>"irc.freenode.net",
	port=>"6667",
	channels=>[
		"#testinghal",
	],
);

my $sock = new IO::Socket::INET(
	PeerAddr => $config{host},
	PeerPort => $config{port},
	Proto    => "tcp",
	Blocking => 0,
) or die "Could not establish socket: $@\n";

my @command_queue = ();
my @module_list   = ();

sub handle_server_socket {
	my ($sock) = @_;
	
	# Read input.
	while (my $data = <$sock>) {
		print "Recieved: $data";
		# If the connection has been established.
		for ($data) {
			if    (/^.*Found your hostname.*$/) { push @command_queue, "set_nick"; }
			elsif (/^PING.*$/) { push @command_queue, "send_pong"; }
		}
		foreach (@module_list) {
			my $response = $_->recognizer($data);
			push @command_queue, $response if not $response eq undef;
		}
	}
}
sub send_msg {
	my ($sock, $msg) = @_;
	print $sock "$msg" or die "Error sending message: $@";
	print "Sent: $msg";
}
sub reload_modules {
	delete $INC{"$config{module_dir}/$_.pm"} foreach @module_list;
	
	@module_list = ();
	# Scan the module directory for pm files.
	opendir(DIR, $config{module_dir}) or die $@;
	while (my $_ = readdir(DIR)) {
		next if not /\.pm$/;
		eval {
			require "$config{module_dir}/$_";
			push @module_list, (substr $_, 0, -3);
			1;
		} or print "Error loading $_: $@";
	}
	closedir(DIR);
	print "Loaded modules: @module_list\n";
}

reload_modules();
while (1) {
	handle_server_socket($sock);
	# Execute one client command at a time.
	if (my $command = shift @command_queue) {
		if ($command eq "set_nick") {
			send_msg($sock, "USER $config{identifier} 0 * :Phobot\nNICK $config{nick}\n");
			send_msg($sock, "JOIN $_\n") foreach @{$config{channels}};
		} elsif ($command eq "send_pong") {
			send_msg($sock, "PONG $config{identifier}\n");
		} elsif ($command eq "reload_modules") {
			reload_modules();
		} else {
			send_msg($sock, $command);
		}
	}
}

# http://tools.ietf.org/html/rfc2812#section-3.1.3

