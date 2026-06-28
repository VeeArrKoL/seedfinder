// Seedfinder
// by VeeArr (#2045369)

import <seedfinder/seedfinder_util.ash>;

record SeedCriteria {
	int[8] dreadscroll;
	int[9] bang_potions;
	string seahorse_name;
};

boolean bang_potions_filled(SeedCriteria criteria){
	for(int i=0;i<9;i++){
		if(criteria.bang_potions[i]==0){
			return false;
		}
	}
	return true;
}

int[string] bang_map = {
	"sleepiness":1,
	"confusion":2,
	"inebriety":3,
	"teleportitis":4,
	"detection":5,
	"ettin strength":6,
	"mental acuity":7,
	"blessing":8,
	"healing":9
};

SeedCriteria criteria_from_player(){
	SeedCriteria rv;
	
	for(int i=0;i<8;i++){
		rv.dreadscroll[i]=get_property("dreadScroll"+(i+1)).to_int();
	}
	
	for(int i=0;i<9;i++){
		string p=get_property("lastBangPotion"+(i+819));
		if(p!=""){
			rv.bang_potions[i]=bang_map[p];
		}
	}
	
	rv.seahorse_name=get_property("seahorse_name");
	
	return rv;
}

string to_string(SeedCriteria criteria){
	return `bang={flatten_arr(criteria.bang_potions)} ds={flatten_arr(criteria.dreadscroll)} seahorse={criteria.seahorse_name}`;
}
