"""
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
"""

from base_version.Fighter import Fighter

coins_to_obtain = 20
delta_attack = -1
delta_defense = -1
delta_speed = -1


class AdvancedFighter(Fighter):
    def __init__(self, NO, HP, attack, defense, speed):
        super(AdvancedFighter, self).__init__(NO, HP, attack, defense, speed)
        self.coins = 0
        self.history_record = []

    def obtain_coins(self):
        global coins_to_obtain
        self.coins += coins_to_obtain
        coins_to_obtain = 20
        
    def buy_prop_upgrade(self):
        while True:
            if self.coins < 50:
                break
            print ("Do you want to upgrade properties for Fighter {}? A for attack. D for defense. S for speed. N for no.".format(self.properties["NO"]))
            a = input()
            if a == 'A':
                self.coins -= 50
                self.attack += 1
            elif a == 'D':
                self.coins -= 50
                self.defense += 1
            elif a == 'S':
                self.coins -= 50
                self.speed += 1
            elif a == 'N':
                break
        
    def update_properties(self):
        global delta_attack, delta_defense, delta_speed
        self.attack = max(self.properties["attack"] + delta_attack, 1)
        self.defense = max(self.properties["defense"] + delta_defense, 1)
        self.speed = max(self.properties["speed"] + delta_speed, 1)
        delta_attack = -1
        delta_defense = -1
        delta_speed = -1

    def record_fight(self, fight_result):
        if len(self.history_record) < 3:
            self.history_record.append(fight_result)
        else:
            self.history_record.pop(0)
            self.history_record.append(fight_result)
