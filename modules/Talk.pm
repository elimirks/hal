package Talk;
require "ModHelper.pm";

# Just a bunch of recognizers for fun text responses.

sub recognizer {
	return if not ModHelper::is_privmsg(@_);
	my ($user, $channel, $message) = ModHelper::get_privmsg(@_);

	if ($message =~ /^(hello|hey|hi|greetings)\W.*(?<=\W)hal(?![a-z0-8])/i) {
		my @messages = (
			"Hello there, $user.",
			"Hey $user!",
			"Greetings, human.",
		);
		return ModHelper::generate_msg($channel, $messages[rand @messages]);
	}
	# Add random regex matchers and responses :)
}
1;

