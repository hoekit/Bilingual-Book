# bin/Reader.pl
# PODNAME: Reader.pl
# ABSTRACT: A reader app
use Mojolicious::Lite;
use Book::Bilingual::Reader;

my $reader = Book::Bilingual::Reader->new('t/ff01.mdown');

get '/' => sub {
    my $c = shift;
    $c->render(text => 'hello');
};

get '/reader/html' => sub {
    my ($c) = @_;
    my $ptr = $c->param('ptr') || '0.0.0';

    $reader->_ptr([split '\.', $ptr])
           ->_load_chapter()
           ->_load_dlineset();

    my ($next_ptr) = @{$reader->_next_ptr || []};
    my ($prev_ptr) = @{$reader->_prev_ptr || []};

    my $next_html = $next_ptr
                  ? '<a id="nextPtr" href="/reader/html?ptr='.$next_ptr.'">Next</a>'
                  : 'Next';
    my $prev_html = $prev_ptr
                  ? '<a id="prevPtr" href="/reader/html?ptr='.$prev_ptr.'">Prev</a>'
                  : 'Prev';

    #say $ptr;
    #say "Curr:$ptr Next:$next_ptr Prev:$prev_ptr";
    #say "Next HTML: $next_html";
    #say "Prev HTML: $prev_html";

    $c->stash(chapter_html => $reader->html);
    $c->stash(next_html => $next_html);
    $c->stash(prev_html => $prev_html);

} => 'reader_html';

app->start;
__DATA__

@@ index.html.ep
<%= link_to Reload => 'index' %>.
<%= link_to Reader => 'reader_html' %>.

@@ reader_html.html.ep
% my $link = begin
  % my ($url, $name) = @_;
  <%= link_to $url => begin %><%= $name %><% end %>.
% end

<!DOCTYPE html>
<html>
  <head><title>Sebastians frameworks</title></head>
<head>
  <title>Bilingual Book Reader</title>
  <meta charset="UTF-8">
  <style>
    body { margin:2rem; color:gray; line-height:1.8; }
    .chapter-number{ font-size:2rem; margin:0; }
    .chapter-title{ font-size:1.5rem; margin:0; }
    .paragraph-start{ margin-left:2rem; }
    .pointed{ color:#000; background-color:#FFFF00; padding:0.2rem 0;
        border-radius:5px; }
    .src-lang{color:#000; background-color:#3687DE; padding:0.2rem 0; 
        border-radius:5px; }
  </style>
</head>
  <body>
    %== $chapter_html

    <br/><br/><br/>

    %== $prev_html
    %== $next_html

  </body>
<script>
    document.getElementById("Ptr").scrollIntoView();

    function clickPrev() {
        let elPrev = document.querySelector('#prevPtr')
        if (elPrev) { elPrev.click() }
    }
    function clickNext() {
        let elNext = document.querySelector('#nextPtr')
        if (elNext) { elNext.click() }
    }

   document.onkeydown = function (event) {
      switch (event.keyCode) {
         case 37:
            console.log("Left key is pressed.");
            clickPrev();
            break;
         case 38:
            console.log("Up key is pressed.");
            break;
         case 39:
            console.log("Right key is pressed.");
            clickNext();
            break;
         case 40:
            console.log("Down key is pressed.");
            break;
      }
   };
</script>

</html>

