#!/usr/bin/env perl
use utf8;
use strict;
use warnings;
use feature 'state';

use DateTime;
use DateTime::Format::Duration;
use DateTime::Format::Strptime;
use JSON;
use Net::MPD;
use Net::DBus;
use Time::HiRes 'usleep';

my $uname = `uname -r`;
chomp $uname;

my $ani_idx = 0;
my @chars   = (qw( - \ | /  - ), ' ', qw( . o 0 O 0 o . ), ' ');

my $start_time = DateTime->now;
my $timer_formatter = DateTime::Format::Duration->new(
    pattern   => '%H:%M:%S',
    normalize => 'ISO',
);

my $mpd = eval { Net::MPD->connect };

my %mpd_state_translation = (
    'play'  => '▶',
    'pause' => 'll ',
    'stop'  => '■',
);

local $| = 1;
print scalar <STDIN>;
print scalar <STDIN>;

my ($dbus, $calendar_service, $calendar_object);

sub init_calendar {
    eval {
        $dbus = Net::DBus->session;

        if($dbus) {
            $calendar_service = $dbus->get_service('org.gnome.Shell.CalendarServer');

            if($calendar_service) {
                $calendar_object = $calendar_service->get_object('/org/gnome/Shell/CalendarServer', 'org.gnome.Shell.CalendarServer');
            }
        }
    };

    return;
}

my $dt_formatter = DateTime::Format::Strptime->new(
    pattern   => '%c',
);

my $calendar_entries     = [];
my $calendar_last_update = 0;

while (my ($statusline) = (<STDIN> =~ /^,?(.*)/)) {
    if ( -e '/tmp/mgr_timer.reset') {
        $start_time = DateTime->now;
        unlink '/tmp/mgr_timer.reset' or die;
    }

    my @blocks = decode_json($statusline)->@*;
    my @new_blocks;

    if(! -f '.streaming-mode') {
        if($calendar_object) {
            eval {
                if(time - $calendar_last_update > 300) {
                    $calendar_entries     = $calendar_object->GetEvents(time, time + 86400, 1);
                    $calendar_last_update = time;
                }

                if(my $entry = $calendar_entries->[0]) {
                    my $name    = $entry->[1];
                    utf8::decode($name);
                    my $from_ts = $entry->[4];
                    my $to_ts   = $entry->[5];

                    my $color = ($from_ts - time) <= 300 ? '#FF0000'
                              : ($from_ts - time) <= 1800 ? '#FF9900'
                              : '#00AA55';

                    my @time = gmtime($from_ts - time);

                    my $dt_start = DateTime->from_epoch(epoch => $from_ts);
                    $dt_start->set_time_zone('Europe/Berlin');

                    my $from_ts_formatted = ($from_ts - time) <= 300 ? ('in ' . sprintf("%02dm / %02ds", $time[1], $time[0]))
                                          : $dt_formatter->format_datetime($dt_start);

                    unshift(@new_blocks,
                        {
                            full_text => "Upcoming event: $name (starting $from_ts_formatted)",
                            color     => $color,
                        },
                    );
                }
            };
        }
        else {
            init_calendar();
        }

        if($mpd) {
            local $@;
            eval { $mpd->ping };

            if($@) {
                $mpd = undef;
            }
            else {
                my $status = $mpd->update_status;
                my $current_song = $mpd->current_song;
                my $song         = $current_song->{Artist} . ' / ' . $current_song->{Album} . ' / ' . $current_song->{Title};
                my $mpd_state    = $mpd->state;
                my $state        = $mpd_state_translation{$mpd_state};

                if($mpd_state eq 'stop') {
                    $song = 'No music playing 😲 ';
                } else {
                    $song .= ' (' . join('/', map { $timer_formatter->format_duration(DateTime::Duration->new(seconds => $_)) } split(':', $status->{time})) . ')';
                }

                unshift(@new_blocks,
                    {
                        full_text => $state . ' ' . $song,
                        color     => '#AAAAFF',
                    },
                );
            }
        }
        else {
            $mpd = eval { Net::MPD->connect; };
        }

        my $ts = DateTime->now;
        my $timer = $ts - $start_time;

        my $temp = `cat /sys/class/thermal/thermal_zone0/temp | tr -d '\n'` / 1000;

        for(1..5) {
            print encode_json([
                (
                    {
                        full_text => $chars[++$ani_idx % @chars],
                        color     => '#508050',
                    },
                    {
                        full_text => $uname,
                        color     => '#505050',
                    },
                    {
                        full_text => "$temp°C",
                        color     => ($temp > 80 ? '#FF0000'
                                    : $temp > 65 ? '#FFFF00'
                                    : '#F0F0F0'),
                    },
                    {
                        full_text => $timer_formatter->format_duration($timer),
                    },
                ),
                @new_blocks,
                @blocks,
            ]) . ",\n";
            usleep 180_000;
        }
    }
    else {
        my $ts = DateTime->now;
        my $timer = $ts - DateTime->from_epoch(epoch => (stat '.streaming-mode')[9]);

        unshift(@new_blocks,
            {
                full_text => 'Streaming since ' . $timer_formatter->format_duration($timer),
            },
        );

        print encode_json([@new_blocks, @blocks]) . ",\n";
    }
}
