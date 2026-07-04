// Seedfinder
// by VeeArr (#2045369)

import <seedfinder/seedfinder_util.ash>;

record SeedCriteria {
	int[8] dreadscroll;
	string bang_potions;
	string seahorse_name;
	string condo_order;
};

SeedCriteria blank_criteria(){
	SeedCriteria rv;
	rv.bang_potions="?????????";
	rv.condo_order="??????";
	return rv;
}

boolean validate_string(string criterion, string letters){
	if(criterion.length()!=letters.length()){
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
	if(!validate_string(criteria.bang_potions,"scitdembh")){
		rv+=", Invalid bang_potions";
	}
	
	if(!validate_string(criteria.condo_order,"emdfbs")){
		rv+=", Invalid condo_order";
	}
	
	if(rv.length()>0){
		rv=rv.substring(2);
	}
	return rv;
}

SeedCriteria criteria_from_player(){
	SeedCriteria rv;
	
	for(int i=0;i<8;i++){
		rv.dreadscroll[i]=get_property("dreadScroll"+(i+1)).to_int();
	}
	
	rv.bang_potions="";
	for(int i=0;i<9;i++){
		string p=get_property("lastBangPotion"+(i+819));
		if(p==""){
			rv.bang_potions+="?";
		}else{
			rv.bang_potions+=p.char_at(0);
		}
	}
	
	string needsP=get_property("leprecondoNeedOrder");
	if(needsP==""){
		rv.condo_order="??????";
	}else{
		rv.condo_order="";
		string[int] needs=needsP.split_string(",");
		foreach idx, need in needs {
			rv.condo_order+=need.char_at(0);
		}
		while(rv.condo_order.length()<6){
			rv.condo_order+="?";
		}
	}
	if(!validate_string(rv.condo_order,"emdfbs")){
		print(`Parsed invalid condo_order: {rv.condo_order}, ignoring.`,"purple");
		print(`<{get_property("leprecondoNeedOrder")}>`,"purple");
		rv.condo_order="??????";
	}
	
	rv.seahorse_name=get_property("seahorse_name");
	
	return rv;
}

string to_string(SeedCriteria criteria){
	string rv="";
	
	if(criteria.bang_potions!="?????????"){
		rv+=" bang="+criteria.bang_potions;
	}
	
	string ds=flatten_arr(criteria.dreadscroll);
	if(ds!="00000000"){
		rv+=" ds="+ds;
	}
	
	if(criteria.condo_order!="??????"){
		rv+=" co="+criteria.condo_order;
	}
	
	if(criteria.seahorse_name!=""){
		rv+=" <seahorse>="+criteria.seahorse_name;
	}
	
	if(rv.length()>0){
		rv=rv.substring(1);
	}
	return rv;
}

boolean bang_potions_filled(SeedCriteria criteria){
	return !criteria.bang_potions.contains_text("?");
}
