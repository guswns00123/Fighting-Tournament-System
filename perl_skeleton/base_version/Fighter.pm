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

package Fighter;


sub new{
    my $class = shift;
    my $self = {
        NO => shift,
        HP => shift,
        attack => shift,
        defense => shift,
        speed => shift,
        defeated => 0,
    };
    
    return bless $self, $class;
}
sub get_properties{
    my($self) = @_;
    my %x = ("NO" => $self->{NO},
             "HP" => $self->{HP},
             "attack" => $self->{attack},
             "defense" => $self->{defense},
             "speed" => $self->{speed},
             "defeated" => $self->{defeated},
             );

    return %x;
}

sub reduce_HP{
    my ($self) = @_;
    $self->{'HP'} = $self->{'HP'} - $_[1];
    if($self->{'HP'} <= 0){
        $self->{'HP'} = 0;
        $self->{'defeated'} = 1;
    }
    
    return $self->{'HP'}
}

sub check_defeated{
    my $self = shift;
    return $self->{defeated};
}

sub print_info{
  my $self = shift;
  
  my $defeated_info;
  if ($self -> check_defeated() eq 1){
    $defeated_info = "defeated";
  }else{
    $defeated_info = "undefeated";
  }
  print "Fighter $self->{'NO'}: HP: $self->{'HP'} attack: $self->{'attack'} defense: $self->{'defense'} speed: $self->{'speed'} $defeated_info\n";
}


1;
