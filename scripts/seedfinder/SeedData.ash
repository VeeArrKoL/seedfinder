// Seedfinder
// by VeeArr (#2045369)

import <seedfinder/SeedCriteria.ash>;
import <seedfinder/seedfinder_calc.ash>;
import <seedfinder/seedfinder_util.ash>;

record SeedData {
	int seed;
	int[8] dreadscroll;
	int[9] bang_potions;
	string seahorse_name;
};

SeedData data_from_seed(int seed){
	SeedData rv;
	rv.seed=seed;
	rv.dreadscroll=calculate_dreadscroll(seed);
	rv.bang_potions=calculate_bang_potions(seed);
	rv.seahorse_name=calculate_seahorse_name(seed);
	return rv;
}

string to_string(SeedData data){
	return `{data.seed}: bang={flatten_arr(data.bang_potions)} ds={flatten_arr(data.dreadscroll)} seahorse={data.seahorse_name}`;
}

boolean matches(SeedData data, SeedCriteria criteria){
	// print(`Check "{data.to_string()}" against "{criteria.to_string()}"`,"purple");
	for(int i=0;i<9;i++){
		if(criteria.bang_potions[i]>0 && criteria.bang_potions[i]!=data.bang_potions[i]){
			return false;
		}
	}
	
	for(int i=0;i<8;i++){
		if(criteria.dreadscroll[i]>0 && criteria.dreadscroll[i]!=data.dreadscroll[i]){
			return false;
		}
	}
	
	// if(criteria.seahorse!="" && criteria.seahorse!=seed.seahorse){
	// 	return false;
	// }
	
	return true;
}
