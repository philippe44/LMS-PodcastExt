package Plugins::PodcastExt::PodcastIndex;

use strict;

use base qw(Slim::Plugin::Podcast::PodcastIndex);

use Slim::Utils::Strings qw(string cstring);

sub getMenuItems {
	my ($self, $client) = @_;
	my $items = $self->SUPER::getMenuItems($client);
	splice @$items, 1, 0, {
		name => cstring($client, 'PLUGIN_PODCASTEXT_TRENDING'),
		image => 'html/images/search.png',
	};
	return $items;
}

sub getSearchParams {
	my ($self, $client, $item, $search) = @_;

	if ($item->{name} eq cstring($client, 'PLUGIN_PODCASTEXT_TRENDING')) {
		my @tags = split / /, $search;
		$search = join '&', @tags;
		return ('https://api.podcastindex.org/api/1.0/podcasts/trending?' . $search, $self->getHeaders);
	} else {
		return $self->SUPER::getSearchParams($client, $item, $search);	
	}	
}


1;
