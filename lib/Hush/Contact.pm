package Hush::Contact;
use strict;
use warnings;
use Hush::Util qw/barf/;

sub contact {
    my $cmd = shift || '';
    my $subcommands = {
        "add" => sub {
            # add a hush contact, yay
            my ($cmd,$name,$zaddr) = @ARGV;
            #barf Dumper [ $cmd, $name, $zaddr ];
            #TODO: give user ability to choose
            my $chain = "hush";
            my $contacts_file = catdir($HUSHLIST_CONFIG_DIR,"$chain-contacts.txt");

            if (-e $contacts_file) {
                my %contacts   = read_file( $contacts_file ) =~ /^(z[a-z0-9]+) (.*)$/mgi ;

                # TODO: check if zaddr OR nickname exists
                if ($contacts{$zaddr}) {
                } else {
                    # TODO: see if this contact exists already in this chain
                    open my $fh, ">>", $contacts_file or barf "Could not write file $contacts_file ! : $!";
                    #TODO: validation?
                    print $fh "$zaddr $name\n";
                    close $fh;
                }
            }
        },
        "rm" => sub {
            my ($cmd,$name,$zaddr) = @ARGV;
            barf Dumper [ $cmd, $name, $zaddr ];
        },
    };
    my $subcmd = $subcommands->{$cmd};
    if ($subcmd) {
        $subcmd->();
    } else {
        barf "Invalid hushlist contact subcommand!";
    }
}

1;
