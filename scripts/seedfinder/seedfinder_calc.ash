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

string[int] SWIM_NAMES = { "Flicker", "Flitter", "Glitter", "Glimmer", "Shimmer", "Luster", "Dazzle", "Splendor", "Fritter", "Frizzle", "Tripper" };
string[int] JACK_NAMES = { "Banana", "Blackberry", "Blueberry", "Cantaloupe", "Cherry", "Clementine", "<Dragonfruit>", "Durian", "<Fig>", "Grape", "Grapefruit", "Honeydew", "Huckleberry", "Jackfruit", "Kiwi", "Kumquat", "Lemon", "Lime", "Mango", "Orange", "<Pear>", "Pineapple", "Raspberry", "<Starfruit>", "<Strawberry>", "Tangerine", "<Tomato>", "Watermelon", "Grapple", "Pluot", "Apricot", "Plum" };
string[int] TWOPART_NAMES_1 = { "Morning", "Afternoon", "Evening", "Waterspout", "Dolphin", "Cloud", "Reddie", "Purplie", "<Bluie>", "Orangie", "Greenie", "Pasty", "<Lightning>", "Thunder", "<14>", "Scarlet", "Manta", "Sailboat", "Swimmy", "<Backstroke>", "Butterfly", "Sushi", "Hermit", "Diving", "Swordfish", "Starfish", "Sturgeon", "Urchin", "Beluga" };
string[int] TWOPART_NAMES_2 = { "Splash", "Pie", "Sparkle", "<Gloaming>", "<Sand>", "<Waves>", "Dreams", "Munchies", "<Sailor>", "Shipwreck", "<Seagrass>", "Fizzy", "Bucket", "<Bait>", "Sofa", "Apple", "<16>", "Star", "Beam", "Valley", "<Blossom>", "<Scallop>", "Coral", "Anemone", "Seaweed" };

string calculate_seahorse_name(int seed){	
	rng r=php_seed(seed);
	int nameType=-1;
	while(nameType<1||nameType>3){
		nameType=mt_rand(1,4,r);
	}
	if(nameType==1){
		return choose(JACK_NAMES,r)+"jack";
	}else if(nameType==2){
		return choose(TWOPART_NAMES_1,r)+" "+choose(TWOPART_NAMES_2,r);
	}else{
		return choose(SWIM_NAMES,r)+"swim";
	}
}
