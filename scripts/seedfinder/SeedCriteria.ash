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
	string rave_combos;
	string seahorse_name;
	string slime_potions;
};

// Please use this function to manually instantiate a SeedCriteria. Do not use "new SeedCriteria()".
SeedCriteria blank_criteria(){
	SeedCriteria rv;
	rv.bang_potions="?????????";
	rv.condo_order="??????";
	rv.daily_dungeon="????_????_????";
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
	
	return rv;
}

string to_string(SeedCriteria criteria){
	string rv="";
	
	if(criteria.bang_potions!="?????????"){
		rv+=" bp="+criteria.bang_potions;
	}
	
	if(criteria.condo_order!="??????"){
		rv+=" co="+criteria.condo_order;
	}
	
	if(criteria.daily_dungeon!="????_????_????"){
		rv+=" dd="+criteria.daily_dungeon;
	}
	
	string ds=flatten_arr(criteria.dreadscroll);
	if(ds!="00000000"){
		rv+=" ds="+ds;
	}
	
	if(criteria.rave_combos!="??????"){
		rv+=" rc="+criteria.rave_combos;
	}
	
	if(criteria.seahorse_name!=""){
		rv+=" sh="+criteria.seahorse_name;
	}
	
	if(criteria.slime_potions!="???_???_??????"){
		rv+=" sl="+criteria.slime_potions;
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

boolean matches(SeedCriteria criteria, int seed){
	if(criteria.bang_potions!="?????????" && !string_matches(criteria.bang_potions,calculate_bang_potions(seed))){
		return false;
	}
	
	if(criteria.condo_order!="??????" && !string_matches(criteria.condo_order,calculate_condo_order(seed))){
		return false;
	}
	
	if(criteria.daily_dungeon!="????_????_????" && !string_matches(criteria.daily_dungeon,calculate_daily_dungeon(seed))){
		return false;
	}
	
	if(flatten_arr(criteria.dreadscroll)!="00000000"){
		int[8] seed_ds=calculate_dreadscroll(seed);
		for(int i=0;i<8;i++){
			if(criteria.dreadscroll[i]>0 && criteria.dreadscroll[i]!=seed_ds[i]){
				return false;
			}
		}
	}
	
	if(criteria.rave_combos!="??????" && !string_matches(criteria.rave_combos,calculate_rave_combos(seed))){
		return false;
	}
	
	if(criteria.seahorse_name!="" && criteria.seahorse_name!=calculate_seahorse_name(seed)){
		return false;
	}
	
	if(criteria.slime_potions!="???_???_??????" && !string_matches(criteria.slime_potions,calculate_slime_potions(seed))){
		return false;
	}
	
	return true;
}

boolean bang_potions_filled(SeedCriteria criteria){
	return !criteria.bang_potions.contains_text("?");
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
		msg+=" // "+criteria_str;
		for(int i=819;i<=827;i++){
			msg+=" // "+get_property("lastBangPotion"+i);
		}
		msg+=" // "+get_property("leprecondoNeedOrder");
		msg+=" // "+get_property("dailyDungeonRooms");
		msg+=" // ";
		for(int i=1;i<=8;i++){
			msg+=get_property("dreadScroll"+i);
		}
		for(int i=1;i<=6;i++){
			msg+=" // "+get_property("raveCombo"+i);
		}
		msg+=" // "+get_property("seahorseName");
		for(int i=3885;i<=3896;i++){
			msg+=" // "+get_property("lastSlimeVial"+i);
		}
		msg=msg.replace_string(";"," ").replace_string("|"," ");
		boolean ignore_error=cli_execute("kmail to VeeArr || "+msg);
	}
}
