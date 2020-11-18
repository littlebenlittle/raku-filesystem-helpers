
unit package FileSystem::Helpers:auth<github:littlebenlittle>:ver<0.1.0>;

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

sub copy-dir(
    IO() $from,
    IO() $to,
) is export {
    die "not a directory: $from" unless $from.d;
    mkdir $to unless $to.e;
    for $from.dir {
        my $dest = $to.add($_.basename);
        given $_ {
            when :d {
                mkdir $dest;
                copy-dir $_, $dest;
            }
            default {
                $_.copy: $dest;
            }
        }
    }
}

sub generate-dir(
    IO() $template-dir,
    IO() $target-dir,
    *%args
) is export {
    use Stache::Renderer;
    mkdir $target-dir unless $target-dir.e;
    for $template-dir.dir {
        my $dest = $target-dir.add: $_.basename;
        given $_ {
            when :d {
                say "expanding $dest";
                generate-dir($_, $dest, |%args);
            }
            when :f {
                say 'writing to ' ~ $dest.Str;
                $dest.spurt: Stache::Renderer::basic($_.slurp, |%args);
            }
        }
    }
}
