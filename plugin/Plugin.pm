package Plugins::PodcastExt::Plugin;

use strict;
use base qw(Slim::Plugin::Base);

use Slim::Utils::Prefs;
use Slim::Utils::Log;
use Slim::Plugin::Podcast::Plugin;

use Plugins::PodcastExt::iTunes;

my	$log = Slim::Utils::Log->addLogCategory({
	'category'     => 'plugin.podcastext',
	'defaultLevel' => 'ERROR',
	'description'  => 'PLUGIN_PODCASTEXT',
});

my $prefs = preferences('plugin.podcastext');

sub initPlugin {
	my $class = shift;
	
	Slim::Plugin::Podcast::Plugin::registerProvider('Plugins::PodcastExt::iTunes');
	Slim::Plugin::Podcast::Plugin::registerProvider('Plugins::PodcastExt::PodcastIndex', 1);
	
	$class->SUPER::initPlugin;

	if ( main::WEBUI ) {
		require Plugins::PodcastExt::Settings;
		Plugins::PodcastExt::Settings->new;
	}
}	


1;
