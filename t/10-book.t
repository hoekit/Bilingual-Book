# t/10-book.t v0.0.1-1
use strict; use warnings; use utf8; use 5.10.0;
use Test::More;

use lib qw(lib ../lib);
use Book::Bilingual;
use Book::Bilingual::Chapter;

my ($sub, $got, $exp, $msg, $tmp, $tmp1, $tmp2, $tmp3);


BEGIN {
    use_ok( 'Book::Bilingual' ) || print "Bail out!\n";
}
{ ## Basic test
$msg = 'Basic test -- Ok';
$got = 1;
$exp = 1;
is($got, $exp, $msg);
}
{ ## chapters is ArrayRef
$msg = 'chapters is ArrayRef';
$tmp = Book::Bilingual->new->chapters;
$got = ref $tmp;
$exp = 'ARRAY';
is($got, $exp, $msg);
}
{ ## chapters ArrayRef is empty
$msg = 'chapters ArrayRef is empty';
$tmp = Book::Bilingual->new->chapters;
$got = @$tmp;
$exp = 0;
is($got, $exp, $msg);
}
{ ## num_chapters on init is 0
$msg = 'num_chapters on init is 0';
$tmp = Book::Bilingual->new;
$got = $tmp->num_chapters;
$exp = 0;
is($got, $exp, $msg);
}

{ ## push($chapter) result in correct length
$msg = 'push($chapter) result in correct length';
$tmp = Book::Bilingual->new;
$got = $tmp->push(Book::Bilingual::Chapter->new)->num_chapters;
$exp = 1;
is($got, $exp, $msg);
}
{ ## push($chapter) dies on bad type
$msg = 'push($chapter) result in correct length';
eval { Book::Bilingual->new->push({})->num_chapters };
$got = $@ =~ /Not a Book::Bilingual::Chapter/ ? 1 : 0;
$exp = 1;
is($got, $exp, $msg);
}


done_testing();

