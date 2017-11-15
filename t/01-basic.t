use v6.c;
use Test;
use File::Storage;

plan 4;

my $fs = File::Storage.new(storage-config-path-name => "test");

is $fs.load(), (), "Empty array returned by load if file does not exists.";

my %test-key-values = (test_key => "1", test_key_two => "three");
$fs.save(%test-key-values);

is-deeply $fs.load, %test-key-values, "Saved then loaded data is the same.";

# Fetch the path to the storage file and check if it is the expected one.
my $storage-file-path = $fs.get-storage-file-path();
my $storage-file-path-expected = $*SPEC.catfile($*HOME, '.config', 'test', 'storage');
is $storage-file-path-expected, $storage-file-path.path, "Proper path was created";

# Remove storage file created by this test.
$storage-file-path.unlink;

dies-ok { File::Storage.new() }, "Object creation without name dies.";
