// Seedfinder
// by VeeArr (#2045369)

import <seedfinder/seedfinder_calc.ash>;
import <seedfinder/seedfinder_lookups.ash>;
import <seedfinder/seedfinder_util.ash>;

record SeedCriteria {
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

// Please use this function to manually instantiate a SeedCriteria. Do not use "new SeedCriteria()".
SeedCriteria blank_criteria(){
	SeedCriteria rv;
	rv.bang_potions="?????????";
	rv.condo_order="??????";
	rv.daily_dungeon="????_????_????";
	rv.island_barracks="???_???_???_???_???_???";
	rv.rave_combos="??????";
	rv.slime_potions="???_???_??????";
	return rv;
}

boolean validate_string(string criterion, string letters, int len){
	if(criterion.length()!=len){
		return false;
	}
	
	for(int i=0;i<criterion.length();i++){
		string v=criterion.char_at(i);
		if(v!="?" && !letters.contains_text(v)){
			return false;
		}
	}
	
	return true;
}

string validation_errors(SeedCriteria criteria){
	string rv="";
	if(!validate_string(criteria.bang_potions,"scitdembh",9)){
		rv+=", Invalid bang_potions";
	}
	
	if(!validate_string(criteria.condo_order,"emdfbs",6)){
		rv+=", Invalid condo_order";
	}
	
	if(!validate_string(criteria.daily_dungeon,"MDT_",14)){
		rv+=", Invalid daily_dungeon";
	}
	
	if(!validate_string(criteria.island_barracks,"123CKR_",23)){
		rv+=", Invalid island_barracks";
	}
	
	if(!validate_string(criteria.rave_combos,"BbPpRr",6)){
		rv+=", Invalid rave_combos";
	}
	
	if(!validate_string(criteria.slime_potions,"123ies_",14)){
		rv+=", Invalid slime_potions";
	}
	
	if(rv.length()>0){
		rv=rv.substring(2);
	}
	return rv;
}

SeedCriteria criteria_from_player(){
	SeedCriteria rv=blank_criteria();
	
	rv.bang_potions="";
	for(int i=819;i<=827;i++){
		string p=get_property("lastBangPotion"+i);
		if(p==""){
			rv.bang_potions+="?";
		}else{
			rv.bang_potions+=p.char_at(0);
		}
	}
	
	string needs_prop=get_property("leprecondoNeedOrder");
	if(needs_prop==""){
		rv.condo_order="??????";
	}else{
		rv.condo_order="";
		string[int] needs=needs_prop.split_string(",");
		foreach idx, need in needs {
			rv.condo_order+=need.char_at(0);
		}
		while(rv.condo_order.length()<6){
			rv.condo_order+="?";
		}
	}
	if(!validate_string(rv.condo_order,"emdfbs",6)){
		print(`Parsed invalid condo_order: {rv.condo_order}, ignoring.`,"purple");
		print(`<{get_property("leprecondoNeedOrder")}>`,"purple");
		rv.condo_order="??????";
	}
	
	string dd_data=get_property("dailyDungeonRooms");
	if(validate_string(dd_data,"MDT_",14)){
		rv.daily_dungeon=dd_data;
	}
	
	for(int i=1;i<=8;i++){
		rv.dreadscroll[i-1]=get_property("dreadScroll"+i).to_int();
	}
	
	// ib
	// It's pretty much impossible to read the hacienda state from
	// mafia prefs since it changes post-quest, so don't try to include
	// it in the criteria.
	
	rv.rave_combos="";
	for(int i=1;i<=6;i++){
		string p=get_property("raveCombo"+i);
		if(p==""){
			rv.rave_combos+="?";
		}else{
			string[int] parts=p.split_string(",");
			string letter=parts[0].char_at(0);
			if(parts[1].char_at(0)<parts[2].char_at(0)){
				letter=letter.to_upper_case();
			}else{
				letter=letter.to_lower_case();
			}
			rv.rave_combos+=letter;
		}
	}
	
	rv.seahorse_name=get_property("seahorseName");
	
	rv.slime_potions="";
	for(int i=3885;i<=3896;i++){
		rv.slime_potions+=lookup_slime_potion(get_property("lastSlimeVial"+i));
		if(i==3887||i==3890){
			rv.slime_potions+="_";
		}
	}
	
	string[int] vf_pref=get_property("violetFogLayout").split_string(",");
	if(vf_pref.count()==92){
		for(int choice=48;choice<=70;choice++){
			int baseIdx=4*(choice-48);
			if(choice>=62){
				baseIdx++;
			}
			for(int c=0;c<3;c++){
				int idx=baseIdx+c;
				int v=to_int(vf_pref[idx]);
				if(v>0){
					rv.violet_fog[(choice-48)*3+c]=v;
				}
			}
		}
	}
	
	int[6] wine_glyphs;
	string wg_pref=get_property("seedfinder_wineGlyphs");
	if(wg_pref!=""){
		string[int] parts=wg_pref.split_string(":");
		int asc=to_int(parts[0]);
		if(parts[1].contains_text("0")||my_ascensions()>asc){
			set_property("seedfinder_wineGlyphs","");
			wg_pref="";
		}else{
			for(int i=0;i<6;i++){
				wine_glyphs[i]=to_int(parts[1].char_at(i));
			}
		}
	}
	if(is_default(wine_glyphs)){
		item glasses=$item[Lord Spookyraven's spectacles];
		item equipped_acc;
		boolean glasses_equipped=false;
		if(have_equipped(glasses)){
			glasses_equipped=true;
		}else if(get_inventory()[glasses]>0){
			equipped_acc=equipped_item($slot[acc3]);
			equip(glasses,$slot[acc3]);
			glasses_equipped=true;
		}
		if(glasses_equipped){
			for(int i=0;i<6;i++){
				int item_id=2271+i;
				string desc=visit_url("desc_item.php?whichitem="+to_item(item_id).descid,false);
				matcher m=create_matcher("Arcane Glyph #(.)",desc);
				if(m.find()){
					wine_glyphs[i]=to_int(m.group(1));
				}else{
					wine_glyphs[i]=0;
				}
			}
		}
		if(equipped_acc!=$item[none]){
			equip(equipped_acc,$slot[acc3]);
		}
		if(!is_default(wine_glyphs)){
			set_property("seedfinder_wineGlyphs",my_ascensions()+":"+flatten_arr(wine_glyphs));
		}
	}
	rv.wine_glyphs=wine_glyphs;
	
	return rv;
}

string to_string(SeedCriteria criteria){
	string rv="";
	
	if(!is_default(criteria.bang_potions)){
		rv+=" bp="+criteria.bang_potions;
	}
	
	if(!is_default(criteria.condo_order)){
		rv+=" co="+criteria.condo_order;
	}
	
	if(!is_default(criteria.daily_dungeon)){
		rv+=" dd="+criteria.daily_dungeon;
	}
	
	if(!is_default(criteria.dreadscroll)){
		rv+=" ds="+flatten_arr(criteria.dreadscroll);
	}
	
	if(!is_default(criteria.island_barracks)){
		rv+=" ib="+criteria.island_barracks;
	}
	
	if(!is_default(criteria.rave_combos)){
		rv+=" rc="+criteria.rave_combos;
	}
	
	if(criteria.seahorse_name!=""){
		rv+=" sh="+criteria.seahorse_name;
	}
	
	if(!is_default(criteria.slime_potions)){
		rv+=" sl="+criteria.slime_potions;
	}
	
	if(!is_default(criteria.violet_fog)){
		rv+=" vf="+flatten_arr(criteria.violet_fog,",");
	}
	
	if(!is_default(criteria.wine_glyphs)){
		rv+=" wg="+flatten_arr(criteria.wine_glyphs);
	}
	
	if(rv.length()>0){
		rv=rv.substring(1);
	}
	return rv;
}

boolean string_matches(string criteria, string data){
	for(int i=0;i<criteria.length();i++){
		if(criteria.char_at(i)!="?" && criteria.char_at(i)!=data.char_at(i)){
			return false;
		}
	}
	return true;
}

boolean array_matches(int[int] criteria, int[int] data){
	for(int i=0;i<criteria.count();i++){
		if(criteria[i]>0 && criteria[i]!=data[i]){
			return false;
		}
	}
	return true;
}

boolean matches(SeedCriteria criteria, int seed){
	if(!is_default(criteria.bang_potions) && !string_matches(criteria.bang_potions,calculate_bang_potions(seed))){
		return false;
	}
	
	if(!is_default(criteria.condo_order) && !string_matches(criteria.condo_order,calculate_condo_order(seed))){
		return false;
	}
	
	if(!is_default(criteria.daily_dungeon) && !string_matches(criteria.daily_dungeon,calculate_daily_dungeon(seed))){
		return false;
	}
	
	if(!is_default(criteria.dreadscroll) && !array_matches(criteria.dreadscroll,calculate_dreadscroll(seed))){
		return false;
	}
	
	if(!is_default(criteria.island_barracks) && !string_matches(criteria.island_barracks,calculate_island_barracks(seed))){
		return false;
	}
	
	if(!is_default(criteria.rave_combos) && !string_matches(criteria.rave_combos,calculate_rave_combos(seed))){
		return false;
	}
	
	if(criteria.seahorse_name!="" && criteria.seahorse_name!=calculate_seahorse_name(seed)){
		return false;
	}
	
	if(!is_default(criteria.slime_potions) && !string_matches(criteria.slime_potions,calculate_slime_potions(seed))){
		return false;
	}
	
	if(!is_default(criteria.violet_fog) && !array_matches(criteria.violet_fog,calculate_violet_fog(seed))){
		return false;
	}
	
	if(!is_default(criteria.wine_glyphs) && !array_matches(criteria.wine_glyphs,calculate_wine_glyphs(seed))){
		return false;
	}
	
	return true;
}

void report_error(SeedCriteria criteria){
	string already_reported=get_property("_seedfinder_reportedErrors");
	string criteria_str=criteria.to_string();
	if(already_reported.contains_text(criteria_str)){
		return;
	}
	set_property("_seedfinder_reportedErrors",already_reported+"|"+criteria_str);
	
	string allow_error_reports=get_property("_seedfinder_allowErrorReports");
	boolean do_error_report=false;
	if(allow_error_reports=="true"){
		do_error_report=true;
	}else if(allow_error_reports==""){
		do_error_report=user_confirm("Seedfinder found no matching seeds based on your player data. This shouldn't be possible. Is it okay to send error reports to improve seedfinder? (Proceeding automatically in 60 seconds.)",60000,false);
	}
	set_property("_seedfinder_allowErrorReports",to_string(do_error_report));
	
	if(do_error_report){
		string msg="seedfinder error";
		msg+=" /bp/ "+criteria_str;
		for(int i=819;i<=827;i++){
			msg+=" / "+get_property("lastBangPotion"+i);
		}
		msg+=" /co/ "+get_property("leprecondoNeedOrder");
		msg+=" /dd/ "+get_property("dailyDungeonRooms");
		msg+=" /ds/ ";
		for(int i=1;i<=8;i++){
			msg+=get_property("dreadScroll"+i);
		}
		msg+=" /ib/ "+get_property("haciendaLayout");
		for(int i=1;i<=6;i++){
			msg+=(i==1?" /rc/ ":" / ");
			msg+=get_property("raveCombo"+i);
		}
		msg+=" /sh/ "+get_property("seahorseName");
		for(int i=3885;i<=3896;i++){
			msg+=(i==3885?" /sl/ ":" / ");
			msg+=get_property("lastSlimeVial"+i);
		}
		msg+=" /vf/ "+get_property("violetFogLayout");
		msg+=" /wg/ "+get_property("seedfinder_wineGlyphs");
		msg=msg.replace_string(";"," ").replace_string("|"," ");
		boolean ignore_error=cli_execute("kmail to VeeArr || "+msg);
	}
}
