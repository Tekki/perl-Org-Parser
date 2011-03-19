package Org::Element::Block;
# ABSTRACT: Represent Org block

use 5.010;
use Moo;
extends 'Org::Element::Base';

=head1 ATTRIBUTES

=head2 name => STR

Block name. For example, #+begin_src ... #+end_src is an 'SRC' block.

=cut

has name => (is => 'rw');

=head2 raw_arg => STR

Argument of block. For example:

 #+BEGIN_EXAMPLE -t -w40
 ...
 #+END_EXAMPLE

will have '-t -w40' as the raw_arg value.

=cut

has raw_arg => (is => 'rw');

=head2 raw_content => STR

Content of block. In the previous 'raw_arg' example, 'raw_content' is "...\n".

=cut

has raw_content => (is => 'rw');

my @known_blocks = qw(
                         ASCII CENTER COMMENT EXAMPLE HTML
                         LATEX QUOTE SRC VERSE
                 );


=head1 METHODS

=for Pod::Coverage element_as_string BUILD

=cut

sub BUILD {
    my ($self, $args) = @_;
    $self->name(uc $self->name);
    $self->name =~ @known_blocks or die "Unknown block name: ".$self->name;
}

sub element_as_string {
    my ($self) = @_;
    return $self->_str if defined $self->_str;
    join("",
         "#+BEGIN_".uc($self->name),
         defined($self->raw_arg) ? " ".$self->raw_arg : "",
         "\n",
         $self->raw_content,
         "#+END_".uc($self->name)."\n");
}

1;
__END__

=head1 DESCRIPTION

Derived from Org::Element::Base.

=cut
