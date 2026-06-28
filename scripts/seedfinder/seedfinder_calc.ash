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

string[int] SWIM_NAMES = { "<0>", "<1>", "Glitter", "<3>", "<4>", "Luster", "Dazzle", "Splendor", "Fritter", "<9>", "<10>" };
string[int] JACK_NAMES = { "<0>", "<1>", "<2>", "<3>", "<4>", "Clementine", "<6>", "<7>", "<8>", "<9>", "<10>", "<11>", "<12>", "<13>", "<14>", "<15>", "<16>", "<17>", "<18>", "<19>", "<20>", "<21>",  "<22>", "<23>", "<24>", "<25>", "<26>", "<27>", "<28>", "<29>", "<30>", "<31>" };
string[int] TWOPART_NAMES_1 = { "<0>", "Afternoon", "<2>", "<3>", "<4>", "<5>", "<6>", "<7>", "Orangie", "<9>", "<10>", "<11>", "<12>", "<13>", "<14>", "<15>", "<16>", "<17>", "<18>", "Butterfly", "Hermit", "<21>", "<22>", "<23>", "Starfish", "<25>", "<26>" };
string[int] TWOPART_NAMES_2 = { "Splash", "<1>", "Sparkle", "<3>", "<4>", "<5>", "<6>", "<7>", "<8>", "<9>", "<10>", "<11>", "<12>", "<13>", "<14>", "<15>", "<16>", "<17>", "Beam", "<19>", "<20>", "<21>", "Coral", "Anemone", "<24>" };

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
