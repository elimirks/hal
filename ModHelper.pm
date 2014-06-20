package ModHelper;
sub is_privmsg {
	return @_[1] =~ /^.*PRIVMSG.*$/;
}
sub get_privmsg {
	my ($user, $channel, $message) = @_[1] =~ /^:([^!]+)!\S+\sPRIVMSG\s(\S+)\s:(.*)$/;
	# Strip junk out of messages.
	$message =~ tr/\x20-\x7f//cd;
	# Set the channel as the sending user, if it is a private message.
	return ($user, ($channel =~ /#/) ? $channel : $user, $message);
}
sub generate_msg {
	my ($channel, $message) = @_;
	return "PRIVMSG $channel :$message\n";
}
1;

