use v6.c;
unit class File::Storage:ver<0.0.1>;

=begin pod

=head1 NAME

File::Storage - blah blah blah

=head1 SYNOPSIS

  use File::Storage;

=head1 DESCRIPTION

File::Storage is ...

=head1 AUTHOR

wbiker <wbiker@gmx.at>

=head1 COPYRIGHT AND LICENSE

Copyright 2017 wbiker

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod

has $.storage-config-path-name;
has IO::Path $.config-file-path;

submethod TWEAK() {
    die "Parameter storage-config-path-name must be set" unless $!storage-config-path-name;

    my $config-path = $*SPEC.catdir($*HOME, '.config');
    $config-path.IO.mkdir unless $config-path.IO.e;

    my $config-name-path = $*SPEC.catdir($config-path, $!storage-config-path-name);
    $config-name-path.IO.mkdir unless $config-name-path.IO.e;

    $!config-file-path = $*SPEC.catfile($config-name-path, 'storage').IO;
}

method get-storage-file-path() {
    return $!config-file-path;
}

method load() {
    unless $!config-file-path.e {
        return ();
    }

    my %key-values;
    for $!config-file-path.lines -> $line {
        next if $line ~~ /^ \s* "#"/;
        next if $line !~~ /':'/;

        my ($key, $value) = split ':', $line;
        %key-values{$key} = $value;
    }

    return %key-values;
}

method save(%key-value) {
    my $fh = $!config-file-path.open(:w);
    for %key-value.kv -> $key, $value {
        $fh.say: $key ~ ":" ~ $value;
    }
    $fh.close;
}
