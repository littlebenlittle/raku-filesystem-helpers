
unit package FileSystem::Helpers:auth<github:littlebenlittle>:ver<0.1.2>;

our sub temp-dir (
    &code,
    Str:D :$template = 'tmp',
    IO()  :$root = $*TMPDIR
) {
    my $uid = sprintf '%d%d%d%d', (0..9).pick: 4;
    our $*tmpdir = $root.add("$template-$uid");
    mkdir $*tmpdir;
    LEAVE { run « rm -r $*tmpdir »  if $*tmpdir.defined }
    &code()
}

our sub copy-dir(
    IO() $from,
    IO() $to,
    :&mod,
) {
    die "not a directory: $from" unless $from.d;
    mkdir $to unless $to.e;
    for $from.dir {
        my $dest = $to.add($_.basename);
        given $_ {
            when :d {
                mkdir $dest;
                copy-dir $_, $dest, :mod(&mod);
            }
            default {
                if &mod.defined {
                    my $content = &mod($_);
                    $dest.spurt: $content if $content.defined;
                } else {
                    $_.copy: $dest;
                }
            }
        }
    }
}

