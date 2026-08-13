// Seedfinder
// by VeeArr (#2045369)

since r29108;

int SEED_RANGE_MIN=1000000;
int SEED_RANGE_MAX=9999999;
int SEED_RANGE_CNT=SEED_RANGE_MAX-SEED_RANGE_MIN+1;

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

string B64_KEY="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

string to_b64(int v, int chars){
	string rv;
	while(v>0){
		int dv=v%64;
		string c=B64_KEY.char_at(dv);
		rv=c+rv;
		v/=64;
	}
	while(rv.length()<chars){
		rv="A"+rv;
	}
	return rv;
}

int from_b64(string v){
	int rv;
	for(int i=0;i<v.length();i++){
		rv=64*rv+B64_KEY.index_of(v.char_at(i));
	}
	return rv;
}

string compress(int[int] array, int chars){
	int prev=999999;
	int min_step=64**chars-1;
	string rv=`{chars}:`;
	foreach idx, val in array{
		int diff=val-prev;
		while(diff>min_step){
			rv+=to_b64(min_step,chars);
			diff-=min_step;
		}
		if(diff>0){
			rv+=to_b64(diff,chars);
		}
		prev=val;
	}
	return rv;
}

string compress(int[int] array){
	int bestChars=-1;
	int bestSize=-1;
	int entries=array.count();
	for(int i=1;i<=4;i++){
		int size=i*entries*(1+SEED_RANGE_CNT/(entries*64**i));
		if(bestSize==-1||size<bestSize){
			bestSize=size;
			bestChars=i;
		}
	}
	
	string rv=compress(array,bestChars);
	return rv;
}

int[int] decompress(string val){
	int[int] rv;
	int chars=to_int(val.char_at(0));
	int prev=999999;
	int ptr=2;
	while(ptr<val.length()){
		int diff=from_b64(val.substring(ptr,ptr+chars));
		ptr+=chars;
		prev+=diff;
		rv[rv.count()]=prev;
	}
	return rv;
}

void write_seeds(int[string,int] data,string file){
	print(`Compressing {file} ...`);
	string[string] write_data;
	int idx;
	int size=data.count();
	foreach key in data{
		idx++;
		if(idx%(size/10)==0){
			print(idx/(size/100)+"% complete...");
		}
		write_data[key]=compress(data[key]);
	}
	
	print(`Writing to {file}.txt ...`);
	map_to_file(write_data,`seedfinder/{file}.txt`);
}

int[int] load_seeds(string file,string key){
	string[string] data;
	file_to_map(`seedfinder/{file}.txt`,data);
	return decompress(data[key]);
}
