// Seedfinder
// by VeeArr (#2045369)

import <seedfinder/seedfinder_util.ash>;

int[8] calculate_dreadscroll(int seed){
	rng r=php_seed(seed);
	int[8] rv;
	for(int i=0;i<8;i++){
		rv[i]=mt_rand(1,4,r);
	}
	return rv;
}

int[9] calculate_bang_potions(int seed){
	rng r=php_seed(seed);
	int[9] rv={1,2,3,4,5,6,7,8,9};
	shuffle(rv,r);
	return rv;
}

string[int] SWIM_NAMES = { "Flicker", "Flitter", "Glitter", "Glimmer", "Shimmer", "Luster", "Dazzle", "Splendor", "Fritter", "Frizzle", "Tripper" };
string[int] JACK_NAMES = { "<Banana>", "<Blackberry>", "<Blueberry>", "<Cantaloupe>", "<Cherry>", "Clementine", "<Dragonfruit>", "Durian", "<Fig>", "<Grapefruit>", "<Grape>", "<Honeydew>", "<Huckleberry>", "Jackfruit", "Kiwi", "<Kumquat>", "<Lemon>", "<Lime>", "<Mango>", "Orange", "<Pear>", "<Pineapple>", "<Raspberry>", "<Starfruit>", "<Strawberry>", "<Tangerine>", "<Tomato>", "<Watermelon>", "Grapple", "Pluot", "<Apricot>", "Plum" };
string[int] TWOPART_NAMES_1 = { "<Morning>", "Afternoon", "<Evening>", "<Cloud>", "<Dolphin>", "<Waterspout>", "Reddie", "Purplie", "<Bluie>", "Orangie", "Greenie", "Pasty", "<Thunder>", "<Lightning>", "<14>", "<15>", "<16>", "<17>", "<18>", "<19>", "Butterfly", "<21>", "Hermit", "<23>", "<24>", "Starfish", "<26>", "<27>", "<28>" };
string[int] TWOPART_NAMES_2 = { "Splash", "<1>", "Sparkle", "<3>", "<4>", "<5>", "Dreams", "<7>", "<8>", "Shipwreck", "<10>", "<11>", "<12>", "<13>", "Sofa", "Apple", "<16>", "<17>", "Beam", "<19>", "<20>", "<21>", "Coral", "Anemone", "<24>" };

string choose(string[int] arr,rng r){
	int n=count(arr);
	int idx=mt_rand(0,n-1,r);
	return arr[idx];
}

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
