// Seedfinder
// by VeeArr (#2045369)

int RANDMAX = 2147483647;
	
int mt_rand(int min, int max, rng r){
	int range=max-min+1;
	return floor(php_mt_rand(r).to_float()/RANDMAX*range)+min;
}
	
int rand(int min, int max, rng r){
	int range=max-min+1;
	return floor(php_rand(r).to_float()/RANDMAX*range)+min;
}

void shuffle(int[int] arr, rng r){
	for (int i=count(arr)-1;i>0;i--){
		int idx=rand(0,i,r);
		int temp = arr[i];
		arr[i] = arr[idx];
		arr[idx] = temp;
	}
}

void shuffle(buffer arr, rng r){
	for (int i=arr.length()-1;i>0;i--){
		int idx=rand(0,i,r);
		string temp = arr.char_at(i);
		arr.replace(i,i+1,arr.char_at(idx));
		arr.replace(idx,idx+1,temp);
	}
}

string choose(string[int] arr,rng r){
	int n=count(arr);
	int idx=mt_rand(0,n-1,r);
	return arr[idx];
}

string flatten_arr(int[int] arr){
	string rv="";
	foreach idx,val in arr {
		rv+=val;
	}
	return rv;
}
