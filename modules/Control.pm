package Control;
require "ModHelper.pm";

# TODO create a module to randomly insult someone during a random point in the day.

# Just a bunch of recognizers for fun text responses.

sub recognizer {
	return if not ModHelper::is_privmsg(@_);
	my ($user, $channel, $message) = ModHelper::get_privmsg(@_);

	if ($user eq "elimirks" and $message =~ /^hal: message #\w+ .*/i) {
		my ($c, $m) = $message =~ /^hal: message (#\w+) (.+)/i;
		return ModHelper::generate_msg($c, $m);
	}
}
1;

