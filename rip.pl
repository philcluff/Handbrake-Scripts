#! /usr/bin/env perl

use warnings;
use strict;
use Data::Dumper;

my @drives = [];

print "About to scan drive...\n";
my @scan_return_raw = `HandBrakeCLI -v -i /dev/sr0 -t 0 2>&1`;
print "Scan done! (Got " . scalar(@scan_return_raw) . " lines)\n\n";

print "Chomping results...\n";
chomp @scan_return_raw;
print "Chomp done!\n\n";

print "Stripping out the non-useful data from dump...\n";
my @scan_return_processed = grep(/^\s*\+/, @scan_return_raw);
my $stripped_lines_count = scalar(@scan_return_raw) - scalar(@scan_return_processed);
print "Stripping done! (Removed $stripped_lines_count)\n\n";

print "Processing response from Handbrake into a hash.\n";
my %disk_titles;
my $title_id;

foreach my $scan_line (@scan_return_processed) {

    # If we've found a "+ title", perform title switching logic. Stash away the title ID so we can use it for upcoming lines.
    if ($scan_line =~ m/\+ title (\d+)/) {
 	print "    Found Title! [" . $scan_line . "]\n";
	$disk_titles{$1} = {"title_id" => $1};
	$disk_titles{$1}->{"raw_title"} = $scan_line;
	$title_id = $1;
    }

    else {

	# Duration
	if ($scan_line =~ m/\s*\+ duration: (\d\d):(\d\d):(\d\d)/) {
	    my ($h, $m, $s) = ($1, $2, $3);
	    print "        Found duration! [" . $scan_line . "]\n";
	    $disk_titles{$title_id}->{"duration_seconds"} = ($h * 3600) + ($m * 60) + $s;
	    $disk_titles{$title_id}->{"raw_duration"} = $scan_line;
	}

	else {
	    if ($ENV{DEBUG}) {
		print "Warning: Did not parse line: [" . $scan_line . "]\n";
	    }
	}
    }
}

print "Processing done!\n\n";
print Dumper \%disk_titles;
