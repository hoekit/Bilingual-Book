package Book::Bilingual;
# ABSTRACT: Data structure for a bilingual book
use Mojo::Base -base;
use Carp;

has 'chapters';

sub new { $_[0]->SUPER::new({ chapters => [] }) }
sub num_chapters { ## () :> Int
    my ($self) = @_;

    return scalar @{$self->{chapters}};
}
sub push { ## ($ch:Book::Bilingual::Chapter) :> Self
    my ($self, $ch) = @_;

    croak 'Not a Book::Bilingual::Chapter'
        unless ref($ch) eq 'Book::Bilingual::Chapter';

    push @{$self->{chapters}}, $ch;

    return $self;
}

1;

