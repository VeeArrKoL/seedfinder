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
	string island_barracks;
	string rave_combos;
	string seahorse_name;
	string slime_potions;
	int[69] violet_fog;
	int[6] wine_glyphs;
};

SeedData data_from_seed(int seed){
	SeedData rv;
	rv.seed=seed;
	rv.bang_potions=calculate_bang_potions(seed);
	rv.condo_order=calculate_condo_order(seed);
	rv.daily_dungeon=calculate_daily_dungeon(seed);
	rv.dreadscroll=calculate_dreadscroll(seed);
	rv.island_barracks=calculate_island_barracks(seed);
	rv.rave_combos=calculate_rave_combos(seed);
	rv.seahorse_name=calculate_seahorse_name(seed);
	rv.slime_potions=calculate_slime_potions(seed);
	rv.violet_fog=calculate_violet_fog(seed);
	rv.wine_glyphs=calculate_wine_glyphs(seed);
	return rv;
}

string contents(SeedData data, string field_spec){
	if(field_spec==""){
		field_spec=get_property("seedfinder_defaultFieldSpec");
	}
	if(field_spec==""){
		field_spec="bp,dd,ds,sh";
	}
	string[int] spec_parts=field_spec.split_string(",");
	string rv;
	foreach idx,spec_part in spec_parts {
		string spec=spec_part.replace_string(" ","");
		switch(spec){
			case "bp":
				rv+=" bp="+data.bang_potions;
				break;
			case "co":
				rv+=" co="+data.condo_order;
				break;
			case "dd":
				rv+=" dd="+data.daily_dungeon;
				break;
			case "ds":
				rv+=" ds="+flatten_arr(data.dreadscroll);
				break;
			case "ib":
				rv+=" ib="+data.island_barracks;
				break;
			case "rc":
				rv+=" rc="+data.rave_combos;
				break;
			case "sh":
				rv+=" sh="+data.seahorse_name;
				break;
			case "sl":
				rv+=" sl="+data.slime_potions;
				break;
			case "vf":
				rv+=" vf="+flatten_arr(data.violet_fog,",");
				break;
			case "wg":
				rv+=" wg="+flatten_arr(data.wine_glyphs);
				break;
		}
	}
	if(rv.length()>0){
		rv=rv.substring(1);
	}

	return rv;
}

string contents(SeedData data){
	return contents(data,"");
}

string to_string(SeedData data, string field_spec){
	return `{data.seed}: {data.contents(field_spec)}`; 
}

string to_string(SeedData data){
	return to_string(data,""); 
}

string to_string_html(SeedData data, string field_spec){
	return `<font color=blue>{data.seed}</font>: {data.contents(field_spec)}`;
}

string to_string_html(SeedData data){
	return to_string_html(data,"");
}
