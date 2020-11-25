use v6;

use Test;

use FileSystem::Helpers;

plan 2;
FileSystem::Helpers::temp-dir({
    my $A = $*tmpdir.add: 'A';
    my $B = $*tmpdir.add: 'B';
    $A.mkdir;
    $A.add('dir').mkdir;
    $A.add('dir').add('file.txt').spurt: '12345';
    FileSystem::Helpers::copy-dir $A, $B;
    ok $B.d, 'new dir exists';
    is $B.add('dir').add('file.txt').slurp, '12345', 'copied file nested in dir';
});

done-testing;

