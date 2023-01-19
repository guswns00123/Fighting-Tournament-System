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

package Tournament;
use base_version::Team;
use base_version::Fighter;
use List::Util qw[min max];

sub new{
    my $class = shift;
    my $self = {
        team1 => [],
        team2 => [],
        round_cnt => 1,
    };
    return bless $self, $class;
}

sub set_teams{
    my ($self, $team1, $team2) = @_;
    $self->{team1} = $team1;
    $self->{team2} = $team2;
}

sub play_one_round{
    my ($self) = @_;
    my $fight_cnt = 1;
    my $team1_fighter;
	my $team2_fighter;
    print "Round $self->{round_cnt}: \n";
    while (){
        my $team1 = $self->{team1};
        my $team2 = $self->{team2};
        $team1_fighter = $team1->get_next_fighter();
        $team2_fighter = $team2->get_next_fighter();
     
        if ($team1_fighter eq 0 || $team2_fighter eq 0 ){
            last;
        }
        my $fighter_first = $team1_fighter;
        my $fighter_second = $team2_fighter;
        
        my %properties_first_team1 = $team1_fighter->get_properties();
        my %properties_second_team2 = $team2_fighter->get_properties();
        if ($properties_first_team1{speed} < $properties_second_team2{speed}){
            $fighter_first = $team2_fighter;
            $fighter_second = $team1_fighter;
        }

        my %properties_first = $fighter_first->get_properties();
        my %properties_second = $fighter_second->get_properties();

        my $damage_first = max( $properties_first{attack} - $properties_second{defense}, 1);
        $fighter_second->reduce_HP($damage_first);

        my $damage_second = 0;
        if ( $fighter_second->check_defeated() eq 0 ){
            $damage_second = max( $properties_second{attack} - $properties_first{defense}, 1);
            $fighter_first->reduce_HP($damage_second);
        }

        my $winner_info = "tie";
        if ($damage_second eq 0){
            $winner_info = "Fighter $properties_first{NO} wins";
        }
        else{
            if ($damage_first > $damage_second){
                $winner_info = "Fighter $properties_first{NO} wins";
            }
            elsif($damage_second > $damage_first){
                $winner_info = "Fighter $properties_second{NO} wins";
            }
        }
        print "Duel $fight_cnt: Fighter $properties_first_team1{NO} VS Fighter $properties_second_team2{NO}, $winner_info\n";
        $team1_fighter->print_info();
        $team2_fighter->print_info();
        $fight_cnt = $fight_cnt + 1;

    }
    print "Fighters at rest:\n";
	my $team_fighter;
    foreach my $i ($self->{team1}, $self->{team2}){
		if ($i eq $self->{team1}){
			$team_fighter = $team1_fighter;
			
		}
		else{
			$team_fighter = $team2_fighter;
			
		}
		while (){
			if ($team_fighter ne 0){
				$team_fighter->print_info();
			}
			else{
				last;
			}
			$team_fighter = $i->get_next_fighter();
		}
	}

    $self->{round_cnt} = $self->{round_cnt} + 1;

	
}

sub check_winner(){
    my ($self) = @_;
	my $team1_defeated = 1;
	my $team2_defeated = 1;
	my $team1 = $self->{team1};
	my $team2 = $self->{team2};
	my @fighter_list1 = @{ $team1->{fighter_list} };
	my @fighter_list2 = @{ $team2->{fighter_list} };
	foreach my $i (@fighter_list1){
		if ( $i->check_defeated() eq 0 ){
			$team1_defeated = 0;
			last;
		}
	}
	
	foreach my $i (@fighter_list2){
		if ( $i->check_defeated() eq 0){
			$team2_defeated = 0;
			last;
		}
	}
	
	my $stop = 0;
	my $winner = 0;
	if ($team1_defeated eq 1){
		$stop = 1;
		$winner = 2;
		$stop = 1;
	}

	if ($team2_defeated eq 1){
		$winner = 1;
		$stop = 1;
	}
	return ($stop, $winner);
}

sub input_fighters{
    my ($self, $team_NO) = @_;
    print "Please input properties for fighters in Team $team_NO\n";
    my @fighter_list_team = ();
    my $properties;
    for (my $idx = 4 * ($team_NO-1) + 1; $idx < 4 * ($team_NO-1) + 5 ; $idx++){
		while(){
			chomp( $properties = <STDIN> );
			my @arr = split(/ / , $properties);
			
			
			if (($arr[0] + 10 * ($arr[1] + $arr[2] + $arr[3]) )<= 500){
				my $fighter = new Fighter($idx, $arr[0], $arr[1], $arr[2], $arr[3]);
				push @fighter_list_team, $fighter;
			
				last;
			}

			
			print "Properties violate the constraint\n";
		}
            
    }
	return @fighter_list_team;
}

sub play_game{
	my ($self) = @_;
	my @fighter_list_team1 = $self->input_fighters(1);
	my @fighter_list_team2 = $self->input_fighters(2);

	my $team1 = new Team(1);
	my $team2 = new Team(2);
	@ { $team1->{fighter_list} }= @fighter_list_team1;
	@ { $team2->{fighter_list} }= @fighter_list_team2;
	
	$self->set_teams($team1, $team2);

	print "===========\n";
	print "Game Begins\n";
	print "===========\n";
	print "\n";
	my $flag1;
	my @arr1_order;
	my @arr2_order;
	my $len_arr1;
	my $order1;
	my $order2;
	my $flag3;
	my @unique;
	my $len_unique;

	my $winner;
	my $stop;
	while (){
		print "Team 1: please input order\n";
		while (){
			chomp ($order1 = <STDIN>) ;
			@arr1_order = split(/ /,$order1);
			$len_arr1 = @arr1_order;
			$flag1 = 1;
			my $flag2;
			foreach my $i (@arr1_order){
				$flag2 = 1;
				$team1 = $self->{team1};
				my $check_fighter = $ { $team1->{fighter_list} }[$i-1];
				for (my $j = 1 ; $j <= 4 ; $j++){
					if ($i eq $j) {
						$flag2 = 0;
						last;
					}
				}
				if ($flag2 eq 1){
					$flag1 = 0;
				}elsif ($check_fighter->check_defeated() eq 1){			
					$flag1 = 0;
				}
			}

			my %hash;
			@unique = grep { !$hash{$_}++ } @arr1_order;
			$len_unique = @unique;
			if ($len_unique ne $len_arr1){
				$flag1 = 0;
				
			}

			if ($flag1 eq 1){
				last;
			}
			else{
				print "Invalid input order\n";				
			}
			
		}

		print "Team 2: please input order\n";
		while (){
			chomp ($order2 = <STDIN>) ;
			@arr2_order = split(/ /,$order2);
			$len_arr1 = @arr2_order;
			$flag3 = 1;
			my $flag4;
			foreach my $i (@arr2_order){
				$flag4 = 1;
				$team2 = $self->{team2};
				my $check_fighter = $ { $team2->{fighter_list} }[$i-5];
				for (my $j = 5 ; $j <= 8 ; $j++){
					if ($i eq $j) {
						$flag4 = 0;
						last;
					}
				}
				if ($flag4 eq 1){
					$flag3 = 0;
				}elsif ($check_fighter->check_defeated() eq 1){			
					$flag3 = 0;
				}
			}
			my %hash;
			@unique = grep { !$hash{$_}++ } @arr2_order;
			$len_unique = @unique;
			if ($len_unique ne $len_arr1){
				$flag3 = 0;
			}

			if ($flag3 eq 1){
				last;
			}
			else{
				print "Invalid input order\n";				
			}
			
		}
	$team1->set_order(@arr1_order);
	$team2->set_order(@arr2_order);
	$self->play_one_round();
	($stop , $winner) = $self->check_winner();
	if ($stop eq 1){
		last;
	}
	}
	print "Team $winner wins\n";

	
}
1;