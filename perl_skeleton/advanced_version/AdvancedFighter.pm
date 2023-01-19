=cut
/*
∗ CSCI3180 Principles of Programming Languages
∗
∗ --- Declaration ---
∗
∗ I declare that the assignment here submitted is original except for source
∗ material explicitly acknowledged. I also acknowledge that I am aware of
∗ University policy and regulations on honesty in academic work, and of the
∗ disciplinary guidelines and procedures applicable to breaches of such policy
∗ and regulations, as contained in the website
∗ http://www.cuhk.edu.hk/policy/academichonesty/
∗
∗ Assignment 3
∗ Name : Yoo Hyun Jun
∗ Student ID : 1155100531
∗ Email Addr : hjyoo8@cse.cuhk.edu.hk
∗/
=cut

use strict;
use warnings;

package AdvancedFighter;

use base_version::Fighter;
use List::Util qw(sum);
use List::Util qw(max);

our @ISA = qw(Fighter); 

our $coins_to_obtain = 20;
our $delta_attack = -1;
our $delta_defense = -1;
our $delta_speed = -1;


sub new{
    my $class = shift;
    my $self = $class->SUPER::new(@_);
    $self->{coins} = 0;
    $self->{history_records} = [];
    return bless $self, $class;
}

sub obtain_coins{
    my ($self) = @_;

    if ($AdvancedFighter::coins_to_obtain eq $coins_to_obtain ){
        $self->{coins} = sum $self->{coins}, $coins_to_obtain;
    }else{
        $self->{coins} = sum $self->{coins}, $AdvancedFighter::coins_to_obtain;
    }
    
}

sub buy_prop_upgrade{
    my ($self) = @_;
    while (1){
        if ($self->{coins} < 50){
        return 0;
        }
        print "Do you want to upgrade properties for Fighter $self->{NO}? A for attack. D for defense. S for speed. N for no.\n";
        my $input;
        chomp ( $input = <STDIN> );
        if ($input eq 'A'){
            $self->{coins} = sum $self->{coins}, -50;
            $self->{attack} = sum $self->{attack}, 1;
        }elsif ($input eq 'D'){
            $self->{coins} = sum $self->{coins}, -50;
            $self->{defense} = sum $self->{defense}, 1;
        }elsif ($input eq 'S'){
            $self->{coins} = sum $self->{coins}, -50;
            $self->{speed} = sum $self->{speed}, 1;
        }elsif ($input eq 'N'){
            return 0;
        }
    }
    
}

sub record_fight{
    my ($self, $fight_result) = @_;
    my $len = @{$self->{history_records}};
    if ($len < 3){
        push @{$self->{history_records}}, $fight_result;
    }else{
        shift(@{$self->{history_records}});
        push @{$self->{history_records}}, $fight_result;
    }
}


sub update_properties{
    my ($self) = @_;
    $self->{attack} = max((sum $self->{attack} , $delta_attack), 1);
    $self->{defense} = max((sum $self->{defense} , $delta_defense), 1);
    $self->{speed} = max((sum $self->{speed} , $delta_speed), 1);

}1;

