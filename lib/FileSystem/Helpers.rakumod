
unit package FileSystem::Helpers:auth<github:littlebenlittle>:ver<0.0.0>;

sub temp-dir (
    &code,
    Str:D :$template = 'tmp',
    IO()  :$root = $*TMPDIR
) is export {
    my $uid = sprintf '%d%d%d%d', (0..9).pick: 4;
    our $*tmpdir = $root.add("$template-$uid");
    mkdir $*tmpdir;
    LEAVE { run « rm -r $*tmpdir »  if $*tmpdir.defined }
    &code()
}
