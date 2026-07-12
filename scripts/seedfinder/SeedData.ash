// Seedfinder
// by VeeArr (#2045369)

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
	rv.bang_potions=calculate_bang_potions(seed);
	rv.condo_order=calculate_condo_order(seed);
	rv.daily_dungeon=calculate_daily_dungeon(seed);
	rv.dreadscroll=calculate_dreadscroll(seed);
	rv.seahorse_name=calculate_seahorse_name(seed);
	return rv;
}

string to_string(SeedData data){
	return `{data.seed}: bp={data.bang_potions} co={data.condo_order} dd={data.daily_dungeon} ds={flatten_arr(data.dreadscroll)} sh={data.seahorse_name}`;
}
