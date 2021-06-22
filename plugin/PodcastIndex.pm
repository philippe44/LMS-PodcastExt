package Plugins::PodcastExt::PodcastIndex;

use strict;

use Slim::Utils::Strings qw(string cstring);

# replace PodcastIndex provider with ourselves
my $provider = Slim::Plugin::Podcast::Plugin::getProviderByName('PodcastIndex');
Slim::Plugin::Podcast::Plugin::registerProvider(__PACKAGE__, 'PodcastIndex', $provider, 1);

sub getItems {
	my ($class, $client);
	my $items = Slim::Plugin::Podcast::PodcastIndex->getItems($client);
	splice @$items, 1, 0, {
		title => cstring($client, 'PLUGIN_PODCASTEXT_TRENDING'),
		image => 'plugins/Podcast/html/images/search.png',
	};
	return $items;
}

sub getSearchParams {
	my ($class, $client, $item, $search) = @_;

	if ($item->{title} eq cstring($client, 'PLUGIN_PODCASTEXT_TRENDING')) {
		my $headers = Slim::Plugin::Podcast::PodcastIndex::getHeaders();	
		my @tags = split / /, $search;
		$search = join '&', @tags;
		return ('https://api.podcastindex.org/api/1.0/podcasts/trending?' . $search, $headers);
	} else {
		return Slim::Plugin::Podcast::PodcastIndex->getSearchParams($client, $item, $search);	
	}	
}

# there is no subclassing and registered provider still uses PodcastIndex's methods, 
# we must signal they exist for can() requests
sub newsHandler { 1 }


1;
