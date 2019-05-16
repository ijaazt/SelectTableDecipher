use strict;
use warnings;
 
my $inFile = 'fullPeople';
open(my $fh, '<:encoding(UTF-8)', $inFile) or die "Could not open file $inFile: $!";

my @lines  = <$fh>;

sub tableRow {
	my @cols = split /\s+\|\s*/, $_[0];
	$cols[1] = "($cols[1]";
	foreach my $i (1..$#cols - 1) {
		if($i =~ /[2-4]|[6-9]|10|11/ && $_[1]) {
			$cols[$i] = "'$cols[$i]'";
		}
		if($cols[$i] =~ /\S/) {
			$cols[$i] = " $cols[$i], ";
		}
	}
	if($_[1]) {
		$cols[$#cols] = "'$cols[$#cols]'";
	}
	$cols[$#cols] = "$cols[$#cols])";
	return @cols;
}

my $tableName = "USER";
print "INSERT INTO $tableName";
print tableRow($lines[2]);
print " VALUES \n";
foreach my $i (4...$#lines - 5) {
	print tableRow($lines[$i], 1);
	print ",\n";
}
print tableRow($lines[$#lines - 4], 1);
print ";\n";

