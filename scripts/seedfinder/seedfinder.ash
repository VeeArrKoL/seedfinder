// Seedfinder
// by VeeArr (#2045369)

script "seedfinder";
notify "VeeArr";

import <seedfinder/SeedCriteria.ash>;
import <seedfinder/SeedData.ash>;

SeedData[int] find_seeds(SeedCriteria criteria){
	SeedData[int] rv;
	string err_msg=criteria.validation_errors();
	if(err_msg.length()>0){
		print(err_msg,"red");
		return rv;
	}
	
	int[int] seeds;
	string dd_key=criteria.daily_dungeon;
	dd_key=dd_key.substring(0,4)+dd_key.substring(7,9)+dd_key.substring(12,14);
	if(!criteria.bang_potions.contains_text("?")){
		seeds=load_seeds("seed_data_bp",criteria.bang_potions);
	}else if(!dd_key.contains_text("?")){
		seeds=load_seeds("seed_data_dd",dd_key);
	}
	
	if(seeds.count()>0){
		foreach idx, seed in seeds {
			if(criteria.matches(seed)){
				rv[rv.count()]=data_from_seed(seed);				
				if(rv.count()>1000){
					abort("Over 1000 possible seeds");
				}
			}
		}
	}else{
		string warning_msg="Not all bang potions are known and the Daily Dungeon has not been completed. Determining your seed without either data point may take a very long time and will likely be inconclusive. Continue anyway? (Continuing automatically in 15 seconds.)";
		print(warning_msg,"blue");
		boolean proceed=user_confirm(warning_msg,15000,true);
		if(!proceed){
			abort("Could not calculate seed.");
		}
		for(int seed=SEED_RANGE_MIN;seed<=SEED_RANGE_MAX;seed++){
			if(criteria.matches(seed)){
				rv[rv.count()]=data_from_seed(seed);
				if(rv.count()>1000){
					abort("Over 1000 possible seeds");
				}
			}
		}
	}
	
	return rv;
}

SeedData[int] find_seeds(SeedCriteria criteria, boolean allow_retry){
	SeedData[int] rv=find_seeds(criteria);
	
	if(allow_retry && count(rv)==0 && !is_default(criteria.condo_order)){
		print("Found no matching seeds, re-trying without considering condo_order.","green");
		criteria.condo_order="??????";
		rv=find_seeds(criteria);
	}
	
	return rv;
}

SeedData[int] find_seeds(boolean print_criteria){
	SeedCriteria criteria=criteria_from_player();
	if(print_criteria){
		print(`Player criteria: {criteria.to_string()}`,"purple");
	}
	
	SeedData[int] rv=find_seeds(criteria,true);
	
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
	int[string,int] seed_data_map_bp;
	int[string,int] seed_data_map_dd;
	for(int i=0;i<SEED_RANGE_CNT;i++){
		if(i%(SEED_RANGE_CNT/20)==0){
			print(i/(SEED_RANGE_CNT/100)+"% complete...");
		}
		int seed=i+SEED_RANGE_MIN;
		
		string key=calculate_bang_potions(seed);
		seed_data_map_bp[key][seed_data_map_bp[key].count()]=seed;
		
		key=calculate_daily_dungeon(seed);
		key=key.substring(0,4)+key.substring(7,9)+key.substring(12,14);
		seed_data_map_dd[key][seed_data_map_dd[key].count()]=seed;
	}
	
	write_seeds(seed_data_map_bp,"seed_data_bp");
	write_seeds(seed_data_map_dd,"seed_data_dd");
	
	print("Done");
}

void print_seed(int seed, string field_spec){
	SeedData data=data_from_seed(seed);
	print(data.to_string(field_spec));
}

void print_seed(int seed){
	print_seed(seed,"");
}

void print_commands(){
	print_html("<font color=blue>seedfinder find [&lt;fields&gt;]</font>: Find potential seeds based on current player state. HIGHLY RECOMMENDED: Either have all bang potions identified or have completed the Daily Dungeon.");
	print_html("<font color=blue>seedfinder print &lt;seed&gt; [&lt;fields&gt;]</font>: Print the information for an ascension with seed &lt;seed&gt;.");
	print_html("<font color=blue>seedfinder explain</font>: Explain the data printed for each seed.");
	print_html("<font color=blue>seedfinder precalculate</font>: Recalculate the seed data file.");
	print_html("<font color=blue>seedfinder help</font>: Print this information.");
	print();
	print("[<fields>] is an optional comma-separated list of 2-letter field codes designating which fields to include in the output. See \"seedfinder explain\" for a listing of the available fields.");
}

void print_help(){
	print_html("<font size='6'><b>seedfinder</b></font>");
	print_html("<font size='4'>by <a href='showplayer.php?who=2045369'>VeeArr (#2045369)</a></font>");
	print("with contributions from:");
	print_html("<a href='showplayer.php?who=2813285'>Fart Scauce (#2813285)</a>");
	print_html("<a href='showplayer.php?who=2753050'>Fransisc0 (#2753050)</a>");
	print();
	print_commands();
}

void explain_seed_data(){
	string explain_html=file_to_buffer("seedfinder/explain.html");
	int idx=explain_html.index_of("<h2>");
	explain_html=explain_html.substring(idx);
	print_html(explain_html);
}
		
void main(string command){
	if(command.starts_with("find")){
		string field_spec=command.substring(4);
		SeedData[int] data=find_seeds(true);
		string all_seeds="";
		foreach idx, seed_data in data {
			print_html(seed_data.to_string_html(field_spec));
			all_seeds+=","+seed_data.seed;
		}
		if(count(data)>0){
			print();
			string word="seed";
			if(count(data)>1){
				word="seeds";
			}
			print(`{count(data)} possible {word}: {all_seeds.substring(1)}`,"blue");
		}else{
			print("No matching seeds found.","red");
		}
	}else if(command=="precalculate"){
		precalculate_seeds();
	}else if(command.starts_with("print ")){
		int seed=to_int(command.substring(6,13));
		string field_spec=command.substring(13);
		print_seed(seed,field_spec);
	}else if(command=="explain"){
		explain_seed_data();
	}else if(command=="help"){
		print_help();
	}else{
		print("Unknown seedfinder command: "+command,"red");
		print();
		print_commands();
	}
}
