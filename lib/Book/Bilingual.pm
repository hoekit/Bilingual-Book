package Book::Bilingual;
# ABSTRACT: Data structure for a bilingual book
use Mojo::Base -base;
use Carp;

use version; our $VERSION = version->declare('v0.001');

has 'chapters';         # ArrayRef of Book::Bilingual::Chapter

sub new { $_[0]->SUPER::new({ chapters => [] }) }
sub chapter_count { ## () :> Int
    my ($self) = @_;

    return scalar @{$self->{chapters}};
}
sub push { ## ($chapter:>Book::Bilingual::Chapter) :> Self
    my ($self, $chapter) = @_;

    croak 'Not a Book::Bilingual::Chapter'
        unless ref($chapter) eq 'Book::Bilingual::Chapter';

    push @{$self->{chapters}}, $chapter;

    return $self;
}

sub chapter_at { ## ($ch_idx :>Int) :> Int
    my ($self, $ch_idx) = @_;
    return $self->{chapters}[$ch_idx];
}

sub chapter_dlineset_count { ## ($ch_idx) :> Int
    my ($self,$ch_idx) = @_;
    return $self->chapters->[$ch_idx]->dlineset_count;
}
sub chapter_dlineset_dline_len { ## ($ch_idx, $dset_idx) :> Int
    my ($self, $ch_idx, $dset_idx) = @_;
    return $self->chapters->[$ch_idx]->dlineset_at($dset_idx)->dline_count;
}

=head2 chapter_dlineset_count($chapter_idx:>Int) :> Int

Returns the number of dlinesets in the given Chapter.

=cut
=head2 num_dline_in_dlineset($chapter_idx:Int, $dlineset_idx:Int) :> Int

Returns the number of dlines in the given Chapter and Dlineset.

=cut

1;

