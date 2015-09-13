if ! exists("b:did_perl_statusline")
    setlocal statusline+=%(\ %{StatusLineIndexLine()}%)
    setlocal statusline+=%=
    setlocal statusline+=%f\ 
    setlocal statusline+=%P
    let b:did_perl_statusline = 1
endif

if has( 'perl' )
perl << EOP
    use strict;
    sub current_sub {
        my $curwin = $main::curwin;
        my $curbuf = $main::curbuf;

        my @document = map { $curbuf->Get($_) } 0 .. $curbuf->Count;
        my ( $line_number, $column  ) = $curwin->Cursor;

        my $sub_name = '';
        for my $i ( reverse (0 .. $line_number  -1 ) ) {
            my $line = $document[$i];
            if ( $line =~ /^\s*sub\s+(\w+)\b/ ) {
                $sub_name = $1;
                last;
            } elsif ( $line =~ /^\s*has\s+'?(\w+)'?\s+/ ) {
                $sub_name = $1;
                last;
            }
        }

        my $package_name = '__global__';
        for my $i ( reverse (0 .. $line_number - 1) ) {
            my $line = $document[$i];
            if ( $line =~ /^package\s+(([a-zA-Z_][a-zA-Z0-9_]*)(::[a-zA-Z_][a-zA-Z0-9_]*)*);/) {
                $package_name = $1;
                last;
            }
        }

        my $return_value = $package_name;

        if ( $sub_name != '') {
            $return_value .= "->$sub_name";
        }

        VIM::DoCommand "let subName='$package_name->$sub_name'";
    }
EOP

function! StatusLineIndexLine()
  perl current_sub()
  return subName
endfunction
endif
