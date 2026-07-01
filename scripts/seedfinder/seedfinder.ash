// Seedfinder
// by VeeArr (#2045369)

script "seedfinder";
notify "VeeArr";

import <seedfinder/SeedData.ash>;
import <seedfinder/SeedCriteria.ash>;
import <seedfinder/seedfinder_util.ash>;

int SEED_RANGE_MIN=0;
int SEED_RANGE_MAX=10000000;
int SEED_RANGE_CNT=SEED_RANGE_MAX-SEED_RANGE_MIN+1;

SeedData[int] find_seeds(SeedCriteria criteria){
	SeedData[int] rv;
	int idx=0;
	if(!criteria.bang_potions_filled()){
		boolean proceed=user_confirm("Not all bang potions are known. Determining your seed without them may take a long time and will likely be inconclusive. Continue anyway? (Continuing automatically in 15 seconds.)",15000,true);
		if(!proceed){
			abort("Could not calculate seed.");
		}
		for(int seed=SEED_RANGE_MIN;seed<=SEED_RANGE_MAX;seed++){
			SeedData data=data_from_seed(seed);
			if(data.matches(criteria)){
				rv[idx++]=data;
				if(idx>1000){
					abort("Over 1000 possible seeds");
				}
			}
		}
		return rv;
	}else{
		string[string] seed_data_map;
		file_to_map("seedfinder/seed_data.txt",seed_data_map);
		string bangs=flatten_arr(criteria.bang_potions);
		string[int] seedStrs=split_string(seed_data_map[bangs],",");
		foreach idx, seedStr in seedStrs {
			int seed=seedStr.to_int();
			SeedData data=data_from_seed(seed);
			if(data.matches(criteria)){
				rv[idx++]=data;
			}
		}
		return rv;
	}
}

SeedData[int] find_seeds(){
	SeedCriteria criteria=criteria_from_player();
	// print(`Player criteria: {criteria.to_string()}`,"purple");
	return find_seeds(criteria);
}

void precalculate_seeds(){
	print("Precalculating seed data... this may take a few minutes.");
	string[string] seed_data_map;
	for(int seed=SEED_RANGE_MIN;seed<=SEED_RANGE_MAX;seed++){
		if(seed%(SEED_RANGE_CNT/100)==0){
			print(seed/(SEED_RANGE_CNT/100)+"% complete...");
		}
		
		string key=calculate_bang_potions(seed).flatten_arr();
		if(seed_data_map contains key){
			seed_data_map[key]+=","+seed;
		}else{
			seed_data_map[key]=to_string(seed);
		}
	}
	
	print("Writing to seed_data.txt ...");
	map_to_file(seed_data_map,"seedfinder/seed_data.txt");
	print("Done");
}

void print_help(){
	print("find: Find potential seeds based on current player state. HIGHLY RECOMMENDED: Have all bang potions identified.");
	print("precalculate: Recalculate the seed data file");
	print("help: Print this information");
}
		
void main(string command) {
	if(command=="find"){
		SeedData[int] data=find_seeds();
		string all_seeds="";
		foreach idx, seed_data in data {
			print(seed_data.to_string());
			all_seeds+=","+seed_data.seed;
		}
		if(all_seeds.length()>0){
			print();
			print("Possible seeds: "+all_seeds.substring(1));
		}
	}else if(command=="precalculate"){
		precalculate_seeds();
	}else if(command=="help"){
		print_help();
	}else{
		print("Unknown seedfinder command: "+command,"red");
		print();
		print_help();
	}
}
