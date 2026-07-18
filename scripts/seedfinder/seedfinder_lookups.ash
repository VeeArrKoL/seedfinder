// Seedfinder
// by VeeArr (#2045369)

string lookup_slime_potion(string full){
	switch(full){
		case "":
			return "?";
		case "strong":
		case "brawn":
		case "muscle":
			return "1";
		case "sagacious":
		case "brains":
		case "mentalism":
			return "2";
		case "speedy":
		case "briskness":
		case "moxiousness":
			return "3";
		default:
			return full.char_at(0);
	}
}
