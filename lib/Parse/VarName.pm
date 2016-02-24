package Parse::VarName;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;

use Exporter qw(import);
our @EXPORT_OK = qw(split_varname_words);

our %SPEC;

$SPEC{':package'} = {
    v => 1.1,
    summary => 'Routines to parse variable name',
};

# cannot be put inside sub, warning "Variable %s will not stay shared"
my @res;

$SPEC{split_varname_words} = {
    v => 1.1,
    summary => 'Split words found in variable name',
    description => <<'_',

Try to split words found in a variable name, e.g. mTime -> [m, Time], foo1Bar ->
[foo, 1, Bar], Foo::barBaz::Qux2 -> [Foo, bar, Baz, Qux, 2].

_
    args => {
        varname => {
            schema => 'str*',
            req => 1,
            pos => 1,
        },
        include_sep => {
            summary => 'Whether to include non-alphanum separator in result',
            description => <<'_',

For example, under include_sep=true, Foo::barBaz::Qux2 -> [Foo, ::, bar, Baz,
::, Qux, 2].

_
            schema => [bool => {default=>0}],
        },
    },
    result_naked => 1,
};
sub split_varname_words {
    my %args = @_;
    my $v = $args{varname} or return [400, "Please specify varname"];

    #no warnings;
    @res = ();
    $v =~ m!\A(?:
                (
                    [A-Z][A-Z]+ |
                    [A-Z][a-z]+ |
                    [a-z]+ |
                    [0-9]+ |
                    [^A-Za-z0-9]+
                )
                (?{ push @res, $1 })
            )+\z!sxg
                or return [];
    unless ($args{include_sep}) {
        @res = grep {/[A-Za-z0-9]/} @res;
    }

    \@res;
}

1;
# ABSTRACT:
