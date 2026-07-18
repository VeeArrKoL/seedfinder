// Seedfinder
// by VeeArr (#2045369)

import <seedfinder/seedfinder_util.ash>;

string calculate_shuffle(string initial_order, int seed){
	rng r=php_seed(seed);
	buffer rv=initial_order.to_buffer();
	shuffle(rv,r);
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
		rv[i]=mt_rand(1,4,r);
	}
	return rv;
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
		name_type=mt_rand(1,4,r);
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
