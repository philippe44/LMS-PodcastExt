package Plugins::PodcastExt::Settings;

use strict;
use base qw(Slim::Web::Settings);

use Slim::Utils::Prefs;

my $prefs = preferences('plugin.podcastext');

sub name {
	return 'PLUGIN_PODCASTEXT';
}

sub page {
	return 'plugins/PodcastExt/settings/basic.html';
}

sub prefs {
	my @items;
	my $provider = Slim::Plugin::Podcast::Plugin::getProviderByName;
	
	push @items, qw(country) if !defined preferences('plugin.podcast')->get('country') && $provider->can('hasCountry') && $provider->hasCountry;
	return ($prefs, @items);
}

sub handler {
	my ($class, $client, $params, $pageSetup) = @_;

	return $class->SUPER::handler($client, $params, $pageSetup);
}

	
1;
