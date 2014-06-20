package Jira;
require "ModHelper.pm";
use JSON;

sub recognizer {
	return if not ModHelper::is_privmsg(@_);
	my ($user, $channel, $message) = ModHelper::get_privmsg(@_);
	my $return_msg = "";
	
	for ($message =~ /([A-Z0-9]+\-[0-9]+)/g) {
		my $ticket_id = $_;
		my $url = "<JIRA_URL>/rest/api/latest/issue/$ticket_id";
		my $ticket_json = `curl -s $url --user <user>:<password>`;

		my $scalar = JSON->new->utf8->decode($ticket_json);
		my $summary = $scalar->{fields}{summary};

		if (length($summary)) {
			my $human_url = "http://jira.carpages.ca/browse/$ticket_id";
			my $msg = "\x033$ticket_id \x03$human_url ($summary)";
			$return_msg .= ModHelper::generate_msg($channel, $msg);
		}
	}
	
	return $return_msg if length $return_msg > 0;
}

1;

