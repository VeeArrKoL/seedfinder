// Seedfinder
// by VeeArr (#2045369)

since r29108;

void shuffle(int[int] arr, rng r){
	for (int i=count(arr)-1;i>0;i--){
		int idx=php_rand(r,0,i);
		int temp=arr[i];
		arr[i]=arr[idx];
		arr[idx]=temp;
	}
}

void shuffle(buffer arr, rng r){
	for (int i=arr.length()-1;i>0;i--){
		int idx=php_rand(r,0,i);
		string temp=arr.char_at(i);
		arr.replace(i,i+1,arr.char_at(idx));
		arr.replace(idx,idx+1,temp);
	}
}

void mt_shuffle(int[int] arr, rng r){
	for (int i=count(arr)-1;i>0;i--){
		int idx=php_mt_rand(r,0,i);
		int temp=arr[i];
		arr[i]=arr[idx];
		arr[idx]=temp;
	}
}

void mt_shuffle(buffer arr, rng r){
	for (int i=arr.length()-1;i>0;i--){
		int idx=php_mt_rand(r,0,i);
		string temp=arr.char_at(i);
		arr.replace(i,i+1,arr.char_at(idx));
		arr.replace(idx,idx+1,temp);
	}
}

string choose(string[int] arr,rng r){
	int n=count(arr);
	int idx=php_mt_rand(r,0,n-1);
	return arr[idx];
}

string flatten_arr(int[int] arr, string delimiter){
	string rv="";
	foreach idx,val in arr {
		if(idx>0){
			rv+=delimiter;
		}
		rv+=val;
	}
	return rv;
}

string flatten_arr(int[int] arr){
	return flatten_arr(arr,"");
}

boolean is_default(int[int] arr){
	foreach idx,val in arr {
		if(val>0){
			return false;
		}
	}
	return true;
}

boolean is_default(string v){
	string mismatches=v.replace_string("?","").replace_string("_","");
	if(mismatches.length()>0){
		return false;
	}
	return true;
}
