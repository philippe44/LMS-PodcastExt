package Plugins::PodcastExt::iTunes;

use strict;

use Slim::Utils::Strings qw(string cstring);
use Slim::Utils::Prefs;

my $prefs = preferences('plugin.podcastext');

Slim::Plugin::Podcast::Plugin::registerProvider(__PACKAGE__, 'Apple/iTunes', {
	name   => 'Apple/iTunes',
	result => 'results',
	feed   => 'feedUrl',
	title  => 'collectionName',
	image  => ['artworkUrl600', 'artworkUrl100'],
});

# just use defaults
sub getItems { [ { } ] }

sub getSearchParams {
	my ($class, $client, $item, $search) = @_;
	my $url = 'https://itunes.apple.com/search?media=podcast&term=' . $search;
	my $country = $prefs->get('country');
	$url .= "&country=$country" if $country;
	# iTunes kindly sends us in a redirection loop when we use default LMS user-agent
	return ($url, [ 'User-Agent', 'Mozilla/5.0' ]);
}	


1;
