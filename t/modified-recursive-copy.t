use v6;

use Test;

use FileSystem::Helpers;

plan 4;
FileSystem::Helpers::temp-dir({
    my $A = $*tmpdir.add: 'A';
    my $B = $*tmpdir.add: 'B';
    $A.mkdir;
    $A.add('dir').mkdir;
    $A.add('dir').add('file1.txt').spurt: '12345';
    $A.add('dir').add('file2.txt').spurt: '12345';
    $A.add('dir').add('dontcopy.txt').spurt: '12345';
    FileSystem::Helpers::copy-dir $A, $B, :mod(-> IO $f {
        $f.basename ~~ "file2.txt" ?? '54321' !! do {
            $f.basename ~~ 'dontcopy.txt' ?? Any !! $f.slurp
        }
    });
    ok  $B.d, 'new dir exists';
    is  $B.add('dir').add('file1.txt').slurp, '12345', 'copied file nested in dir';
    is  $B.add('dir').add('file2.txt').slurp, '54321', 'copied modified version of file';
    nok $B.add('dir').add('dontcopy.txt').e,           'did not copy the dontcopy file';
});

done-testing;

