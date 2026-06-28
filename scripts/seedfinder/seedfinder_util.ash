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

string flatten_arr(int[int] arr){
	string rv="";
	foreach idx,val in arr {
		rv+=val;
	}
	return rv;
}
