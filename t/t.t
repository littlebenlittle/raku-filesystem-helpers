use v6;

use Test;

use FileSystem::Helpers;

# class Unit {
# 	has $.name;
# }
# 
# my @units = [
#     Unit.new(name => 'not implemented'),
# ];
# 
# plan @units.elems;
# 
# ok False, .name for @units;

my $uid = sprintf '%d%d%d%d', (0..9).pick: 4;
my $tmpdir = $*TMPDIR.add("filesysem-test-$uid");
mkdir $tmpdir;
END { run « rm -r $tmpdir »  if $tmpdir.defined }

plan 3;
my $created-dir;
temp-dir({
    cmp-ok $*tmpdir.absolute, '~~', / 'filesysem-test-' \d ** 4..* /, 'root name matches';
    cmp-ok $*tmpdir.absolute, '~~', / 'some-dir-' \d ** 4..* /, 'dir name matches';
    $created-dir = $*tmpdir.absolute.IO;
}, :root($tmpdir), :template('some-dir'));
nok $created-dir ~~ :d, 'dir deleted after sub exits';

done-testing;

