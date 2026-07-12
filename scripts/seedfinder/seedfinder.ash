// Seedfinder
// by VeeArr (#2045369)

script "seedfinder";
notify "VeeArr";

import <seedfinder/SeedData.ash>;
import <seedfinder/SeedCriteria.ash>;

int SEED_RANGE_MIN=1000000;
int SEED_RANGE_MAX=9999999;
int SEED_RANGE_CNT=SEED_RANGE_MAX-SEED_RANGE_MIN+1;

SeedData[int] find_seeds(SeedCriteria criteria){
	SeedData[int] rv;
	string err_msg=criteria.validation_errors();
	if(err_msg.length()>0){
		print(err_msg,"red");
		return rv;
	}
	
	int idx=0;
	if(criteria.bang_potions_filled()){
		string[string] seed_data_map;
		file_to_map("seedfinder/seed_data.txt",seed_data_map);
		string bangs=criteria.bang_potions;
		string[int] seed_strs=split_string(seed_data_map[bangs],",");
		foreach idx, seed_str in seed_strs {
			int seed=seed_str.to_int();
			if(criteria.matches(seed)){
				rv[idx++]=data_from_seed(seed);
			}
		}
		return rv;
	}else{
		string warning_msg="Not all bang potions are known. Determining your seed without them may take a very long time and will likely be inconclusive. Continue anyway? (Continuing automatically in 15 seconds.)";
		print(warning_msg,"blue");
		boolean proceed=user_confirm(warning_msg,15000,true);
		if(!proceed){
			abort("Could not calculate seed.");
		}
		for(int seed=SEED_RANGE_MIN;seed<=SEED_RANGE_MAX;seed++){
			if(criteria.matches(seed)){
				rv[idx++]=data_from_seed(seed);
				if(idx>1000){
					abort("Over 1000 possible seeds");
				}
			}
		}
		return rv;
	}
}

SeedData[int] find_seeds(boolean print_criteria){
	SeedCriteria criteria=criteria_from_player();
	if(print_criteria){
		print(`Player criteria: {criteria.to_string()}`,"purple");
	}
	
	SeedData[int] rv=find_seeds(criteria);
	
	if(count(rv)==0){
		criteria.report_error();
	}
	return rv;
}

SeedData[int] find_seeds(){
	return find_seeds(false);
}

void precalculate_seeds(){
	print("Precalculating seed data... this may take a few minutes.");
	string[string] seed_data_map;
	for(int i=0;i<SEED_RANGE_CNT;i++){
		if(i%(SEED_RANGE_CNT/100)==0){
			print(i/(SEED_RANGE_CNT/100)+"% complete...");
		}
		
		int seed=i+SEED_RANGE_MIN;
		string key=calculate_bang_potions(seed);
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

void print_seed(int seed){
	SeedData data=data_from_seed(seed);
	print(data);
}

void print_help(){
	print("find: Find potential seeds based on current player state. HIGHLY RECOMMENDED: Have all bang potions identified.");
	print("precalculate: Recalculate the seed data file.");
	print("print <seed>: Print the information for an ascension with seed <seed>.");
	print("help: Print this information.");
}
		
void main(string command){
	if(command=="find"){
		SeedData[int] data=find_seeds(true);
		string all_seeds="";
		foreach idx, seed_data in data {
			print(seed_data.to_string());
			all_seeds+=","+seed_data.seed;
		}
		if(count(data)>0){
			print();
			print(count(data)+" possible seeds: "+all_seeds.substring(1),"blue");
		}
	}else if(command=="precalculate"){
		precalculate_seeds();
	}else if(command.starts_with("print ")){
		print_seed(command.substring(6).to_int());
	}else if(command=="help"){
		print_help();
	}else{
		print("Unknown seedfinder command: "+command,"red");
		print();
		print_help();
	}
}
