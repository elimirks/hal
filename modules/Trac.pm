package Trac;
require "ModHelper.pm";
sub recognizer {
	return if not ModHelper::is_privmsg(@_);
	my ($user, $channel, $message) = ModHelper::get_privmsg(@_);
	my $return_msg = "";
	
	for ($message =~ /#(\d+)/g) {
		my $url = "http://git.carpages.ca/carpages.ca/ticket/$_";
		my $title = `curl -s $url --user bot:123427`;
		$title =~ s/\R/ /g;
		$title =~ s/.*<title>.*\((.*)\).*<\/title>.*/\1/g;
		$return_msg .= ModHelper::generate_msg($channel, "\x033#$_ \x03$url ($title)");
	}
	
	return $return_msg if length $return_msg > 0;
}
1;

