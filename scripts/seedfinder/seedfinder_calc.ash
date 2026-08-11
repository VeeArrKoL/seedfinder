// Seedfinder
// by VeeArr (#2045369)

since r29108;

import <seedfinder/seedfinder_util.ash>;

string calculate_shuffle(string initial_order, int seed){
	rng r=php_seed(seed);
	buffer rv=initial_order.to_buffer();
	shuffle(rv,r);
	return rv;
}

string calculate_mt_shuffle(string initial_order, rng r){
	buffer rv=initial_order.to_buffer();
	mt_shuffle(rv,r);
	return rv;
}

string calculate_bang_potions(int seed){
	return calculate_shuffle("scitdembh",seed);
}

string calculate_condo_order(int seed){
	return calculate_shuffle("emdfbs",seed);
}

string calculate_daily_dungeon(int seed){
	string dd_data=calculate_shuffle("MMMMDDDDTTTT",seed);
	return dd_data.substring(0,4)+"_"+dd_data.substring(4,8)+"_"+dd_data.substring(8);
}

int[8] calculate_dreadscroll(int seed){
	rng r=php_seed(seed);
	int[8] rv;
	for(int i=0;i<8;i++){
		rv[i]=php_mt_rand(r,1,4);
	}
	return rv;
}

// Island Barracks algorithm spaded by Fransisc0 (#2753050)
string calculate_island_barracks(int seed){
	rng r=php_seed(seed);
	string key_locations=calculate_mt_shuffle("KKKKCC",r);
	string mariachis=calculate_mt_shuffle("123123",r);
	string rv="";
	for(int i=0;i<6;i++){
		string room=calculate_mt_shuffle(mariachis.char_at(i)+key_locations.char_at(i)+"R",r);
		rv+="_"+room;
	}
	return rv.substring(1);
}

string calculate_rave_combos(int seed){
	string combos=calculate_shuffle("BbPpRr",seed);
	int[6] combo_order={3,4,2,1,0,5};
	string rv="";
	for(int i=0;i<6;i++){
		rv+=combos.char_at(combo_order[i]);
	}
	return rv;
}

// Seahorse name data collected by Fart Scauce (#2813285)
string[int] SWIM_NAMES = { "Flicker", "Flitter", "Glitter", "Glimmer", "Shimmer", "Luster", "Dazzle", "Splendor", "Fritter", "Frizzle", "Tripper" };
string[int] JACK_NAMES = { "Banana", "Blackberry", "Blueberry", "Cantaloupe", "Cherry", "Clementine", "Dragonfruit", "Durian", "Fig", "Grape", "Grapefruit", "Honeydew", "Huckleberry", "Jackfruit", "Kiwi", "Kumquat", "Lemon", "Lime", "Mango", "Orange", "Pear", "Pineapple", "Raspberry", "Starfruit", "Strawberry", "Tangerine", "Tomato", "Watermelon", "Grapple", "Pluot", "Apricot", "Plum" };
string[int] TWOPART_NAMES_1 = { "Morning", "Afternoon", "Evening", "Waterspout", "Dolphin", "Cloud", "Reddie", "Purplie", "Bluie", "Orangie", "Greenie", "Pasty", "Lightning", "Thunder", "Pokey", "Scarlet", "Manta", "Sailboat", "Swimmy", "Backstroke", "Butterfly", "Sushi", "Hermit", "Diving", "Swordfish", "Starfish", "Sturgeon", "Urchin", "Beluga" };
string[int] TWOPART_NAMES_2 = { "Splash", "Pie", "Sparkle", "Waves", "Sand", "Gloaming", "Dreams", "Munchies", "Seagrass", "Shipwreck", "Sailor", "Fizzy", "Bucket", "Bait", "Sofa", "Apple", "Urchin", "Star", "Beam", "Valley", "Blossom", "Scallop", "Coral", "Anemone", "Seaweed" };

string calculate_seahorse_name(int seed){	
	rng r=php_seed(seed);
	int name_type=-1;
	while(name_type<1||name_type>3){
		name_type=php_mt_rand(r,1,4);
	}
	if(name_type==1){
		return choose(JACK_NAMES,r)+"jack";
	}else if(name_type==2){
		return choose(TWOPART_NAMES_1,r)+" "+choose(TWOPART_NAMES_2,r);
	}else{
		return choose(SWIM_NAMES,r)+"swim";
	}
}

string calculate_slime_potions(int seed){
	string primary=calculate_shuffle("123",seed);
	primary=primary.char_at(0)+primary.char_at(2)+primary.char_at(1);
	string secondary=calculate_shuffle("123",seed);
	string tertiary=calculate_shuffle("123ies",seed);
	tertiary=tertiary.substring(0,4)+tertiary.char_at(5)+tertiary.char_at(4);
	return `{primary}_{secondary}_{tertiary}`;
}

// Violet Fog algorithm spaded by Fransisc0 (#2753050)
int[69] VF_EXITS={49,50,51,52,53,56,53,54,57,52,54,55,61,65,68,61,66,69,61,67,70,58,65,70,59,66,68,60,67,69,51,52,63,49,53,62,50,54,64,49,50,51,50,61,52,51,61,53,54,61,49,51,54,50,49,52,51,50,53,49,49,53,50,50,54,51,51,52,49};
int[69] calculate_violet_fog(int seed){
	int[69] rv;
	for(int choice=48;choice<=70;choice++){
		rng r=php_seed(seed+choice);
		int[3] exits;
		for(int c=0;c<3;c++){
			exits[c]=VF_EXITS[3*(choice-48)+c];
		}
		shuffle(exits,r);
		for(int c=0;c<3;c++){
			rv[3*(choice-48)+c]=exits[c];
		}
	}
	return rv;
}

int[6] calculate_wine_glyphs(int seed){
	rng r=php_seed(seed);
	int[6] glyphs={1,2,3,4,5,6};
	mt_shuffle(glyphs,r);
	return glyphs;
}
