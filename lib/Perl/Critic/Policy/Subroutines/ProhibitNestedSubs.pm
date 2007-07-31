##############################################################################
#      $URL$
#     $Date$
#   $Author$
# $Revision$
##############################################################################

package Perl::Critic::Policy::Subroutines::ProhibitNestedSubs;

use strict;
use warnings;
use Readonly;

use Perl::Critic::Utils qw{ :severities };
use base 'Perl::Critic::Policy';

our $VERSION = 1.061;

#-----------------------------------------------------------------------------

Readonly::Scalar my $DESC => q{Nested named subroutine};
Readonly::Scalar my $EXPL =>
    q{Declaring a named sub inside another named sub does not prevent the }
        . q{inner sub from being global.};

#-----------------------------------------------------------------------------

sub supported_parameters { return ()                    }
sub default_severity     { return $SEVERITY_HIGH        }
sub default_themes       { return qw(core bugs)         }
sub applies_to           { return 'PPI::Statement::Sub' }

#-----------------------------------------------------------------------------

sub violates {
    my ($self, $elem, $doc) = @_;

    my $inner = $elem->find_first('PPI::Statement::Sub');
    return if not $inner;

    # Must be a violation...
    return $self->violation($DESC, $EXPL, $inner);
}

1;

__END__

#-----------------------------------------------------------------------------

=pod

=for stopwords RJBS SIGNES

=head1 NAME

Perl::Critic::Policy::Subroutines::ProhibitNestedSubs

=head1 DESCRIPTION

B<Attention would-be clever Perl writers (including Younger RJBS):>

This does not do what you think:

  sub do_something {
      ...
      sub do_subprocess {
          ...
      }
      ...
  }

C<do_subprocess()> is global, despite where it is declared.
Either write your subs without nesting or use anonymous code
references.


=head1 NOTE

Originally part of L<Perl::Critic::Tics>.


=head1 AUTHOR

Ricardo SIGNES <rjbs@cpan.org>

=head1 COPYRIGHT

Copyright (c) 2007 Ricardo SIGNES.

This program is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.

=cut

# Local Variables:
#   mode: cperl
#   cperl-indent-level: 4
#   fill-column: 78
#   indent-tabs-mode: nil
#   c-indentation-style: bsd
# End:
# ex: set ts=8 sts=4 sw=4 tw=78 ft=perl expandtab :