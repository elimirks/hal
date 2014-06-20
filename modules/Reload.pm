package Reload;
require "ModHelper.pm";
sub recognizer {
	return if not ModHelper::is_privmsg(@_);
	my ($user, $channel, $message) = ModHelper::get_privmsg(@_);
	return "reload_modules" if $message =~ m/^\.reload$/;
}
1;

