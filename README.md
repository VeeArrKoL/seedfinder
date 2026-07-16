# seedfinder
KoLmafia script for finding the current [ascension seed](https://wiki.kingdomofloathing.com/Ascension_Seed). This seed is used for randomizing various ascension-specific things, including:
* Effects of [bang potions](https://wiki.kingdomofloathing.com/Dungeons_of_Doom_potion)
* The order of [Daily Dungeon](https://wiki.kingdomofloathing.com/The_Daily_Dungeon) rooms
* [Dreadscroll](https://wiki.kingdomofloathing.com/Mer-kin_dreadscroll) answers
* [Seahorse](https://wiki.kingdomofloathing.com/Wild_seahorse) names
* The order of [Leprecondo](https://wiki.kingdomofloathing.com/Leprechaun%27s_Condo) needs

## Installation
Install seedfinder into KoLmafia by using this command in the gCLI:
```
git checkout VeeArrKoL/seedfinder
```

Note that seedfinder includes a large pre-computed seed data file, and takes up around 75MB of disk space.

## Usage
First, identify all of the bang potions by either consuming them or using them in combat. Seedfinder can still attempt to find a seed if your bang potions are not identified, but it will be very slow and will be unlikely to meaningfully narrow down your seed without this information.

To list data about all of the seeds that could apply to your current ascension, based on the information available, run:
```
seedfinder find
```

Each row represents a seed, along with the calculated data for that seed, including:
* Bang potion effect ordering
* Daily Dungeon room order
* Dreadscroll answers
* Seahorse name

## API
It is possible to call the underlying seedfinder functions directly and get strucutred data as a response. The most common use, I expect, will be to find all of the seeds that the current user could have, along with the data for each of those seeds:
```
import <seedfinder/seedfinder.ash>;

// Find possible seeds
SeedData[int] possibleSeeds=find_seeds();

foreach idx, seed in possibleSeeds {
	// Read information from the SeedData for this seed
	//
	// record SeedData {
	//   int seed;
	//   int[8] dreadscroll;
	//   string bang_potions;
	//   string seahorse_name;
	//   ...
	// };
}
```

Alternatively, you can construct a `SeedCriteria` to get seeds matching specific criteria. The usual caveat that this will be very slow unless all of the bang potion fields are filled out applies.
```
import <seedfinder/seedfinder.ash>;

SeedCriteria criteria=blank_criteria();
criteria.bang_potions="citdembhs";
criteria.dreadscroll={0,0,0,1,0,0,0,0};

SeedData[int] possibleSeeds=find_seeds(criteria);
```
