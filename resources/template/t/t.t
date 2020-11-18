use v6;

use Test;

class Unit {
	has $.name;
}

my @units = [
    Unit.new(name => 'not implemented'),
];

plan @units.elems;

ok False, .name for @units;

done-testing;

