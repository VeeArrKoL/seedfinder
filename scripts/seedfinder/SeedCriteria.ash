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

string validation_errors(SeedCriteria criteria){
	string rv="";
	if(criteria.bang_potions.length()!=9){
		rv+=", Invalid bang_potions length";
	}
	
	if(criteria.condo_order.length()!=6){
		rv+=", Invalid condo_order length";
	}
	
	if(rv.length()>0){
		rv=rv.substring(2);
	}
	return rv;
}

boolean bang_potions_filled(SeedCriteria criteria){
	return !criteria.bang_potions.contains_text("?");
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
	
	/*
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
	*/
	// Currently broken?
	rv.condo_order="??????";
	
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
