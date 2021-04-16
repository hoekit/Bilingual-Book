# lib/Book/Bilingual/App.pm
# PODNAME: App.pm
# ABSTRACT: A reader app
use Mojolicious::Lite;
use Book::Bilingual::Reader;

my $Reader;

get '/' => sub {
    my $c = shift;
    $c->render(text => 'hello');
};

sub get_reader_html {
    my ($c) = @_;
    my $ptr = $c->param('ptr') || '0.0.0';

    $Reader->_ptr([split '\.', $ptr])
           ->_load_chapter()
           ->_load_dlineset();

    my ($next_ptr) = @{$Reader->_next_ptr || []};
    my ($prev_ptr) = @{$Reader->_prev_ptr || []};

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

    $c->stash(chapter_html => $Reader->html);
    $c->stash(next_html => $next_html);
    $c->stash(prev_html => $prev_html);

}
get '/reader/html' => \&get_reader_html => 'reader_html';

sub run { ## ($bookfile)
    # Does the actual run using the file a
    my ($file) = @_;
    die "\n  Usage:\n    biread BOOKFILE\n\n" unless $file;

    $Reader = Book::Bilingual::Reader->new($file);
    app->start;
}

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
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="initial-scale=1, maximum-scale=1, width=device-width">
  <title>Bilingual Book Reader</title>

  <style>
    body { margin:2rem; color:gray; line-height:1.8; font-size:1.5rem; }
    .chapter-number{ font-size:2rem; margin:0; }
    .chapter-title{ font-size:1.5rem; margin:0; }
    .paragraph-start{ margin-left:2rem; }
    .pointed{ color:#000; background-color:#FFFF00; padding:0.2rem 0;
        border-radius:5px; }
    .src-lang{color:#FFF; background-color:#3687DE; padding:0.2rem 0;
        border-radius:5px; }
    footer { position:fixed; width:90%; left:0; bottom:0; text-align:right;
             background-color:#FFF }
  </style>
  <script src="https://cdn.jsdelivr.net/npm/hammerjs@2.0.8/hammer.min.js"></script>
</head>
  <body>

    <div class="main">
    %== $chapter_html

    <br/><br/><br/>
    </div>

    <footer>
    %== $prev_html
    |
    %== $next_html
    </footer>

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
            clickPrev();    // console.log("Left key is pressed.");
            break;
         case 38:
            break;          // console.log("Up key is pressed.");
         case 39:
            clickNext();    // console.log("Right key is pressed.");
            break;
         case 40:
            break;          // console.log("Down key is pressed.");
      }
    };

    // Redirect page to sentence that was clicked
    let mc = new Hammer(document.querySelector('.main'))
    mc.on('tap', function(e) {

        // Get pointer value in the data-ptr attribute
        let ptr = e.target.attributes["data-ptr"]

        // Navigate reader to pointer if defined
        if (typeof ptr !== "undefined") {
            let url = e.target.attributes["data-ptr"].value
            window.location.href = "/reader/html?ptr="+url
        }
    })

</script>

</html>

