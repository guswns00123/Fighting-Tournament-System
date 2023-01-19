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

package AdvancedTournament;
use base_version::Team;
use advanced_version::AdvancedFighter;
use base_version::Tournament;
use List::Util qw(sum);

our @ISA = qw(Tournament); 


sub new{
    my $class = shift;
    my $self = $class->SUPER::new();
    $self->{defeat_record} = [];
    return bless $self, $class;
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
        $team1_fighter->buy_prop_upgrade();
        $team2_fighter->buy_prop_upgrade();
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

        my $damage_first = $properties_first{attack} - $properties_second{defense};
        if ($damage_first < 1){
            $damage_first = 1;
        }
        $fighter_second->reduce_HP($damage_first);

        my $damage_second = 0;
        if ( $fighter_second->check_defeated() eq 0 ){
            $damage_second = $properties_second{attack} - $properties_first{defense};
            if ($damage_second < 1){
                $damage_second = 1;
            }
            $fighter_first->reduce_HP($damage_second);
        }

        my $winner_info = "tie";
        if ($damage_second eq 0){
            $winner_info = "Fighter $properties_first{NO} wins";
            if ($fighter_first eq $team1_fighter){
                $team1_fighter->record_fight("W");
                $team2_fighter->record_fight("L");
            }else{
                $team1_fighter->record_fight("L");
                $team2_fighter->record_fight("W");
            }
        }
        else{
            if ($damage_first > $damage_second){
                $winner_info = "Fighter $properties_first{NO} wins";
                if ($fighter_first eq $team1_fighter){
                    $team1_fighter->record_fight("W");
                    $team2_fighter->record_fight("L");
                }else{
                    $team1_fighter->record_fight("L");
                    $team2_fighter->record_fight("W");
            }
            }
            elsif ($damage_first < $damage_second){
                $winner_info = "Fighter $properties_second{NO} wins";
                if ($fighter_first eq $team1_fighter){
                    $team1_fighter->record_fight("L");
                    $team2_fighter->record_fight("W");
                }else{
                    $team1_fighter->record_fight("W");
                    $team2_fighter->record_fight("L");
            }
            }
        }
        print "Duel $fight_cnt: Fighter $properties_first_team1{NO} VS Fighter $properties_second_team2{NO}, $winner_info\n";
        if ($winner_info eq "tie"){
            @{ $team1_fighter->{history_records}} = ();
            @{ $team2_fighter->{history_records}} = ();
        }
        $team1_fighter->print_info();
        $team2_fighter->print_info();
        

   
        if ($team1_fighter->check_defeated() eq 1){
            $self->update_fighter_properties_and_award_coins($team1_fighter, 0, 0);
            $self->update_fighter_properties_and_award_coins($team2_fighter, 1, 0);
            
        }
        elsif($team2_fighter->check_defeated() eq 1){
            $self->update_fighter_properties_and_award_coins($team1_fighter, 1, 0);
            $self->update_fighter_properties_and_award_coins($team2_fighter, 0, 0);
        }
        else{
            $self->update_fighter_properties_and_award_coins($team1_fighter, 0, 0);
            $self->update_fighter_properties_and_award_coins($team2_fighter, 0, 0);
        }
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
                $self->update_fighter_properties_and_award_coins($team_fighter, 0, 1);
			}
			else{
				last;
			}
			$team_fighter = $i->get_next_fighter();
		}
	}

    $self->{round_cnt} = $self->{round_cnt} + 1;
}



sub update_fighter_properties_and_award_coins{
    my ($self, $fighter, $flag_defeat, $flag_rest) = @_;
    local $AdvancedFighter::coins_to_obtain = 20;
    local $AdvancedFighter::delta_attack = -1;
    local $AdvancedFighter::delta_defense = -1;
    local $AdvancedFighter::delta_speed = -1;
    if ($flag_rest eq 1){
        $AdvancedFighter::coins_to_obtain = $AdvancedFighter::coins_to_obtain / 2;
        $AdvancedFighter::delta_attack = 1;
        $AdvancedFighter::delta_defense = 1;
        $AdvancedFighter::delta_speed = 1;
    }
    my $len = @{ $fighter->{history_records}};
    my @records = @{ $fighter->{history_records}};
    if ($len eq 3){
        if ($records[0] eq $records[1] && $records[1] eq $records[2] && $records[0] eq 'W' && $flag_defeat eq 0){
            $AdvancedFighter::coins_to_obtain = $AdvancedFighter::coins_to_obtain * 1.1;
            $AdvancedFighter::delta_attack = 1;
            $AdvancedFighter::delta_defense = -2;
            $AdvancedFighter::delta_speed = 1;
            @{ $fighter->{history_records}} = ();
        }
        elsif ($records[0] eq $records[1] && $records[1] eq $records[2] && $records[0] eq 'W' && $flag_defeat eq 1){
            $AdvancedFighter::coins_to_obtain = $AdvancedFighter::coins_to_obtain * 2.2;
            $AdvancedFighter::delta_attack = 2;
            $AdvancedFighter::delta_defense = -2;
            $AdvancedFighter::delta_speed = 1;
            @{ $fighter->{history_records}} = ();
   
            $flag_defeat = 0;
        }
        elsif ($records[0] eq $records[1] && $records[1] eq $records[2] && $records[0] eq 'L'){
           
            $AdvancedFighter::coins_to_obtain = $AdvancedFighter::coins_to_obtain * 1.1;
            $AdvancedFighter::delta_attack = -2;
            $AdvancedFighter::delta_defense = 2;
            $AdvancedFighter::delta_speed = 2;
            @{ $fighter->{history_records}} = ();
        }
    }

    if ($flag_defeat eq 1){
        $AdvancedFighter::coins_to_obtain = $AdvancedFighter::coins_to_obtain * 2;
        $AdvancedFighter::delta_attack = 1;
        $AdvancedFighter::delta_defense = -1;
        $AdvancedFighter::delta_speed = -1;

    }

    $fighter->obtain_coins();
    $fighter->update_properties();
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
				my $fighter = new AdvancedFighter($idx, $arr[0], $arr[1], $arr[2], $arr[3]);
				push @fighter_list_team, $fighter;
			
				last;
			}	
			print "Properties violate the constraint\n";
		}
            
    }
	return @fighter_list_team;
}


1;