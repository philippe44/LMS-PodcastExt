package Plugins::PodcastExt::iTunes;

use strict;

use base qw(Slim::Plugin::Podcast::Provider);

use Slim::Utils::Prefs;

my $prefs = preferences('plugin.podcastext');

sub hasCountry { 1 }

sub getFeedsIterator {
	my ($self, $feeds) = @_;

	my $index;	
	$feeds = $feeds->{results};

	return sub {	
		my $feed = $feeds->[$index++];
		return unless $feed;
	
		my ($image) = grep { $feed->{$_} } qw(artworkUrl600 artworkUrl100);
	
		return {
			name         => $feed->{collectionName},
			url          => $feed->{feedUrl},
			image        => $feed->{$image},
			author       => $feed->{artistName},
		};
	};	
}

sub getSearchParams {
	my $url = 'https://itunes.apple.com/search?media=podcast&term=' . $_[3];
	my $country = preferences('plugin.podcast')->get('country') // $prefs->get('country');
	$url .= "&country=$country" if $country;
	# iTunes kindly sends us in a redirection loop when we use default LMS user-agent
	return ($url, [ 'User-Agent', 'Mozilla/5.0' ]);
}	

sub getName { 'Apple/iTunes' }


1;
