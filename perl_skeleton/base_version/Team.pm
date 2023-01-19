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


package Team;

sub new {
    my $class = shift;
    my $self = {
        NO => shift,
        fighter_list => [],
        order => [],
        fight_cnt => 0,
    };
    return bless $self, $class;
}

sub set_fighter_list{
    my ($self , @fighter_list) = @_;
    $self->{fighter_list} = [@fighter_list];
    return $self;
}

sub get_fighter_list{
    my ($self) = @_;
    return @{ $self->{fighter_list} };
}

sub set_order{
    my ($self, @order) = @_;
    $self->{order} = ();
    $self->{order} = [@order]; 
    $self->{fight_cnt} = 0;
}



sub get_next_fighter{
    my ($self) = @_;
    my $len_order =  @{ $self->{order} }  ;
    my $len_list = @{ $self->{fighter_list} };
    my @fighters = $self->get_fighter_list();
    if ($self->{fight_cnt} >= $len_order){
        return 0;
    }
    my $prev_fighter_idx = $self->{order}[$self->{fight_cnt}];
    my $fighter = undef;
    for (my $i = 0 ; $i < $len_list ; $i++ ){
        my %properties = $fighters[$i]->get_properties();
        if ($properties{NO} eq $prev_fighter_idx){
            $fighter = $fighters[$i];
        }
        
    }
    $self->{fight_cnt} = $self->{fight_cnt} + 1;
    
    return $fighter;
    
    
}

1;