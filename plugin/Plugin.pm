package Plugins::PodcastExt::Plugin;

use strict;
use base qw(Slim::Plugin::Base);

use Slim::Utils::Prefs;
use Slim::Utils::Log;
use Slim::Plugin::Podcast::Plugin;

my	$log = Slim::Utils::Log->addLogCategory({
	'category'     => 'plugin.podcastext',
	'defaultLevel' => 'ERROR',
	'description'  => 'PLUGIN_PODCASTEXT',
});

my $prefs = preferences('plugin.podcastext');

sub initPlugin {
	my $class = shift;
	
	# make sure we load the provider we want to replace first
	require Slim::Plugin::Podcast::PodcastIndex;
	require Plugins::PodcastExt::PodcastIndex;
	
	require Plugins::PodcastExt::iTunes;
	
	$class->SUPER::initPlugin;

	if ( main::WEBUI ) {
		require Plugins::PodcastExt::Settings;
		Plugins::PodcastExt::Settings->new;
	}
}	


1;
