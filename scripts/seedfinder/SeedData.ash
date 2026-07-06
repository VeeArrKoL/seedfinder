// Seedfinder
// by VeeArr (#2045369)

import <seedfinder/SeedCriteria.ash>;
import <seedfinder/seedfinder_calc.ash>;
import <seedfinder/seedfinder_util.ash>;

record SeedData {
	int seed;
	string bang_potions;
	string condo_order;
	string daily_dungeon;
	int[8] dreadscroll;
	string seahorse_name;
};

SeedData data_from_seed(int seed){
	SeedData rv;
	rv.seed=seed;
	rv.dreadscroll=calculate_dreadscroll(seed);
	rv.bang_potions=calculate_bang_potions(seed);
	rv.seahorse_name=calculate_seahorse_name(seed);
	rv.daily_dungeon=calculate_daily_dungeon(seed);
	rv.condo_order=calculate_condo_order(seed);
	return rv;
}

string to_string(SeedData data){
	return `{data.seed}: bp={data.bang_potions} co={data.condo_order} dd={data.daily_dungeon} ds={flatten_arr(data.dreadscroll)} sh={data.seahorse_name}`;
}

boolean string_matches(string criteria, string data){
	for(int i=0;i<criteria.length();i++){
		if(criteria.char_at(i)!="?" && criteria.char_at(i)!=data.char_at(i)){
			return false;
		}
	}
	return true;
}

boolean matches(SeedData data, SeedCriteria criteria){
	// print(`Check "{data.to_string()}" against "{criteria.to_string()}"`,"purple");
	if(!string_matches(criteria.bang_potions,data.bang_potions)){
		return false;
	}
	
	if(!string_matches(criteria.condo_order,data.condo_order)){
		return false;
	}
	
	if(!string_matches(criteria.daily_dungeon,data.daily_dungeon)){
		return false;
	}
	
	for(int i=0;i<8;i++){
		if(criteria.dreadscroll[i]>0 && criteria.dreadscroll[i]!=data.dreadscroll[i]){
			return false;
		}
	}
	
	if(criteria.seahorse_name!=""){
		string seahorse_name_search=create_matcher("<.+?>",data.seahorse_name).replace_all(".+");
		if(!create_matcher(seahorse_name_search,criteria.seahorse_name).find()){
			return false;
		}
	}
	
	return true;
}
