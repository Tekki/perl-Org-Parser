#!perl -T

use 5.010;
use strict;
use warnings;

sub test_parse {
    my %args = @_;

    subtest $args{name} => sub {
        my @elems;
        my $orgp = Org::Parser->new();
        if ($args{handler}) {
            $orgp->handler($args{handler});
        } elsif ($args{filter_elements}) {
            $orgp->handler(
                sub {
                    my ($orgp, $ev, $args) = @_;
                    return unless $ev eq 'element';
                    my $el     = $args->{element};
                    my $eltype = ref($el);
                    if (ref($args{filter_elements}) eq 'Regexp') {
                        return unless $eltype =~ $args{filter_elements};
                    } else {
                        return unless $eltype eq $args{filter_elements};
                    }
                    push @elems, $el;
                });
        }

        my $res;
        eval {
            $res = $orgp->parse($args{doc});
        };
        my $eval_err = $@;

        if ($args{dies}) {
            ok($eval_err, "dies");
        } else {
            ok(!$eval_err, "doesnt die") or diag("died with msg $eval_err");
        }

        if (defined $args{num}) {
            is(scalar(@elems), $args{num}, "num=$args{num}");
        }

        if ($args{test_after_parse}) {
            $args{test_after_parse}->(parser=>$orgp, result=>$res,
                                      elements=>\@elems);
        }
    };
}

1;