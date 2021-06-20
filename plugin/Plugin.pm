package Plugins::PodcastExt::Plugin;

use strict;
use base qw(Slim::Plugin::Base);

use Digest::SHA1 qw(sha1_hex);
use Encode qw(encode);

use Slim::Utils::Strings qw(string cstring);
use Slim::Utils::Prefs;
use Slim::Utils::Log;

use Slim::Plugin::Podcast::Provider;

my	$log = Slim::Utils::Log->addLogCategory({
	'category'     => 'plugin.podcastext',
	'defaultLevel' => 'ERROR',
	'description'  => 'PLUGIN_PODCASTEXT',
});

my $prefs = preferences('plugin.podcastext');

my $PodcastIndex = {
	name   => 'PodcastIndex',
	result => 'feeds',
	feed   => 'url',
	title  => 'title',
	image  => ['artwork', 'image'],
	menu => [ {
		query => sub {
			my ($self, $search) = @_;
			my $headers = $self->{_buildHeaders}->($self);
			return ('https://api.podcastindex.org/api/1.0/search/byterm?q=' . $search, $headers);
		},
	}, {
		title => cstring(undef, 'PLUGIN_PODCASTEXT_TRENDING'),
		image => 'plugins/PodcastExt/html/images/podcastindex.png',
		query => sub {
			my ($self, $search) = @_;
			my $headers = $self->{_buildHeaders}->($self);
			my @tags = split / /, $search;
			$search = join '&', @tags;
			return ('https://api.podcastindex.org/api/1.0/podcasts/trending?' . $search, $headers);
		},
	} ],
	_buildHeaders => sub {
		my $config = preferences('plugin.podcast')->get('podcastindex');
		my $k = pack('H*', scalar(reverse(MIME::Base64::decode($config->{k}))));
		my $s = pack('H*', scalar(reverse(MIME::Base64::decode($config->{s}))));
		my $time = time;
		return [
			'X-Auth-Key', $k,
			'X-Auth-Date', $time,
			'Authorization', sha1_hex($k . $s . $time),
		];
	},
};

my $iTunes = {
 	name   => 'Apple/iTunes',
	result => 'results',
	feed   => 'feedUrl',
	title  => 'collectionName',
	image  => ['artworkUrl600', 'artworkUrl100'],
	menu => [ {
		query => sub {
			my $url = 'https://itunes.apple.com/search?media=podcast&term=' . $_[1];
			my $country = $prefs->get('country');
			$url .= "&country=$country" if $country;
			# iTunes kindly sends us in a redirection loop when we use default LMS user-agent
			return ($url, [ 'User-Agent', 'Mozilla/5.0' ]);
		},
	} ],
};	

$prefs->init({ 
});

sub initPlugin {
	my $class = shift;
	
	Slim::Plugin::Podcast::Provider->registerProvider($PodcastIndex, 1);
	Slim::Plugin::Podcast::Provider->registerProvider($iTunes);
	
	$class->SUPER::initPlugin;

	if ( main::WEBUI ) {
		require Plugins::PodcastExt::Settings;
		Plugins::PodcastExt::Settings->new;
	}
}	
	
#sub getDisplayName { 'PLUGIN_PODCASTEXT' }

1;
