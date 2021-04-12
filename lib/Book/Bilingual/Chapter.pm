package Book::Bilingual::Chapter;
use Mojo::Base -base;
use Carp;

has 'number';
has 'title';
has 'body';

sub new { $_[0]->SUPER::new({ body => [] }) }
sub num_paragraphs {
    my ($self) = @_;

    return scalar @{$self->{body}};
}

1;
