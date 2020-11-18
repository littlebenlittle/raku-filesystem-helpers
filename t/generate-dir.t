use v6;

use Test;

use FileSystem::Helpers;

use META6::Query;

my $root-dir = META6::Query::root-dir $?FILE;

plan 7;

temp-dir {
    my $template-dir = $root-dir.add('resources').add('template');
    my %args = %(
        name        => 'Some::Mod',
        description => 'Some module for test purposes',
        version     => '0.0.0',
        author-name   => 'Guy Nobody',
        author-email  => 'guy@nowhere.net',
        author-github => 'guynobody'
    );
    generate-dir($template-dir, $*tmpdir, |%args);
    say $*tmpdir.add('t').dir;
    ok $*tmpdir.add('lib').d, 'lib';
    ok $*tmpdir.add('lib').add('Some').add('Mod.rakumod').f, 'some::mod';
    ok $*tmpdir.add('t').d,   't';
    ok $*tmpdir.add('t').add('t.t').f, 't.t';
    ok $*tmpdir.add('README.md').f,  'readme';
    ok $*tmpdir.add('LICENSE').f,    'license';
    ok $*tmpdir.add('META6.json').f, 'meta6';
};

done-testing;

