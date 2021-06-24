package Plugins::PodcastExt::iTunes;

use strict;

use base qw(Slim::Plugin::Podcast::Provider);

use Slim::Utils::Prefs;

my $prefs = preferences('plugin.podcastext');

sub new {
	my $self = shift->SUPER::new;
	
	$self->init_accessor(
		name   => 'Apple/iTunes',
		result => 'results',
		feed   => 'feedUrl',
		title  => 'collectionName',
		image  => ['artworkUrl600', 'artworkUrl100'],
	);
	
	return $self;
}	

sub getSearchParams {
	my $url = 'https://itunes.apple.com/search?media=podcast&term=' . $_[3];
	my $country = $prefs->get('country');
	$url .= "&country=$country" if $country;
	# iTunes kindly sends us in a redirection loop when we use default LMS user-agent
	return ($url, [ 'User-Agent', 'Mozilla/5.0' ]);
}	

sub getName { 'Apple/iTunes' }


1;
