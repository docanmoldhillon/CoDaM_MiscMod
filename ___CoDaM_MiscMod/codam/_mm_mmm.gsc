/*
 * Misc Mod Misc Mod Misc (mm_mmm)
 */
// fixes names for linux servers so they don't crash
// 22-10-2021 just thinking about this code and realize the redundant code this should be recoded and optimized
/*namefix(normalName)
{
	if(!isDefined(normalName))
		return "";

	allowedChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890!'#/&()=?+`^~*-.,;<>|$�@:[]{}_ ";

	badName = false;

	for(i = 0; i < normalName.size; i++) {
		matchFound = false;

		for(z = 0; z < allowedChars.size; z++) {
			if(normalName[i] == allowedChars[z]) {
				matchFound = true;
				break;
			}
		}

		if(!matchFound) {
			badName = true;
			break;
		}
	}

	if(badName) {
		fixedName = "";

		for(i = 0; i < normalName.size; i++) {
			for(z = 0; z < allowedChars.size; z++) {
				if(normalName[i] == allowedChars[z]) {
					fixedName += normalName[i];
					break;
				}
			}
		}

		//self setClientCvar("name", fixedName);
		return fixedName;
	}

	return normalName;
}*/

// 22-10-2021: new namefix() function
namefix(playername)
{
	if(!isDefined(playername))
		return "";

	allowedchars = " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890!'#[]<>/&()=?+`^~*-_.,;|$@:{}"; // " " (space) moved first as it is more frequent -- "�" removed, unknown what this char is?
	cleanedname = "";

	for(i = 0; i < playername.size; i++) {
		for(z = 0; z < allowedchars.size; z++) {
			if(playername[i] == allowedchars[z]) {
				cleanedname += playername[i];
				break;
			}
		}
	}

	return cleanedname;
}

array_shuffle(arr)
{
	if(!isDefined(arr))
		return undefined;

	for(i = 0; i < arr.size; i++) {
		// Store the current array element in a variable
		_tmp = arr[i];

		// Generate a random number
		rN = randomInt(arr.size);

		// Replace the current with the random
		arr[i] = arr[rN];
		// Replace the random with the current
		arr[rN] = _tmp;
	}

	return arr;
}

in_array(arr, needle)
{
	if(!isDefined(arr) || !isDefined(needle))
		return undefined;

	for(i = 0; i < arr.size; i++)
		if(arr[i] == needle)
			return true;

	return false;
}

array_join(arrTo, arrFrom)
{
	if(!isDefined(arrTo) || !isDefined(arrFrom))
		return undefined;

	for(i = 0; i < arrFrom.size; i++)
		arrTo[arrTo.size] = arrFrom[i];

	return arrTo;
}

array_remove(arr, str, r) // NEED URGENT OPTIMIZE - If set to true, it will remove previous element aswell.
{
	if(!isDefined(arr) || !isDefined(str))
		return undefined;

	if(!isDefined(r))
		r = false;

	x = 0;
	_tmpa = [];
	for(i = 0; i < arr.size; i++) {
		if(arr[i] != str) {
			_tmpa[x] = arr[i];
			x++;
		} else {
			if(r) {
				_tmpa[x - 1] = undefined;
				x--;
			}
		}
	}

	_tmp = _tmpa;

	if(r) {
		y = 0;
		_tmpb = [];
		for(i = 0; i < _tmpa.size; i++) {
			if(isDefined(_tmpa[i])) {
				_tmpb[y] = _tmpa[i];
				y++;
			}
		}

		_tmp = _tmpb;
	}

	return _tmp;
}

strip(s)
{
	if(s == "")
		return "";

	s2 = "";
	s3 = "";

	i = 0;
	while(i < s.size && s[i] == " ")
		i++;

	if(i == s.size)
		return "";

	for(; i < s.size; i++)
		s2 += s[i];

	i = (s2.size - 1);
	while(s2[i] == " " && i > 0)
		i--;

	for(j = 0; j <= i; j++)
		s3 += s2[j];

	return s3;
}

strTok(text, separator) // new attemt to fix double, tripple delimiter, etc
{
	token = 0;
	tokens = [];

	for(i = 0; i < text.size; i++) {
		if(text[i] != separator) {
			if(!isDefined(tokens[token]))
				tokens[token] = "";

			tokens[token] += text[i];
		} else {
			if(isDefined(tokens[token]))
				token++;
		}
	}

	return tokens;
}

/*strTok(longStr, separator)
{
	sepcount = 0; // seperations count, -1 is default
	string = [];
	longStr += ""; // turn it into a string if it isn't already
	for(i = 0; i < longStr.size; i++) {
		if(longStr[i] == separator)
			sepcount++;
		else {
			if(!isDefined(string[sepcount]))
				string[sepcount] = "";

			string[sepcount] += longStr[i];
		}
	}

	return string;
}*/

strTru(str, len, ind)
{
	if(!isDefined(ind))
		ind = " >";

	len = len + ind.size;
	if(str.size <= len)
		return str;

	len = len - ind.size;

	new = "";
	for(i = 0; i < len; i++)
		new = new + str[i];

	return new + ind;
}

isBoltWeapon(sWeapon)
{
	switch(sWeapon) {
		case "enfield_mp":
		//case "fg42_mp":
		//case "fg42_semi_mp":
		case "kar98k_mp":
		case "kar98k_sniper_mp":
		case "mosin_nagant_mp":
		case "mosin_nagant_sniper_mp":
		case "springfield_mp":
		return true;
	}

	return false;
}

// Spawn an object and attach a sound to it, POWERSERVER
PlaySoundAtLocation(sound, location, iTime)
{
	org = spawn("script_model", location);
	wait 0.05;
	org show();
	org playSound(sound);
	wait iTime;
	org delete();
	return;
}

compassdb(id) // -1 on no id available
{
	if(!isDefined(level.compassdb)) {
		level.compassdb = [];
		for(i = 0; i < 15; i++)
			level.compassdb[i] = -1;
	}

	if(!isDefined(id))
		id = 0;

	if(id == 0) {
		compassid = -1;
		for(i = 3; i < level.compassdb.size; i++) { // bomb zones
			if(level.compassdb[i] == -1) {
				level.compassdb[i] = i;
				compassid = level.compassdb[i];
				break;
			}
		}

		return compassid;
	} else if(id > 0) {
		level.compassdb[id] = -1;
	} else if(id == -1) {
		for(i = 0; i < 15; i++)
			level.compassdb[i] = -1;
	}

	return;
}

weaponremoval() // from Cheese
{
	deletePlacedEntity("mpweapon_m1carbine");
	deletePlacedEntity("mpweapon_m1garand");
	deletePlacedEntity("mpweapon_thompson");
	deletePlacedEntity("mpweapon_bar");
	deletePlacedEntity("mpweapon_springfield");
	deletePlacedEntity("mpweapon_enfield");
	deletePlacedEntity("mpweapon_sten");
	deletePlacedEntity("mpweapon_bren");
	deletePlacedEntity("mpweapon_mosinnagant");
	deletePlacedEntity("mpweapon_ppsh");
	deletePlacedEntity("mpweapon_mosinnagantsniper");
	deletePlacedEntity("mpweapon_kar98k");
	deletePlacedEntity("mpweapon_mp40");
	deletePlacedEntity("mpweapon_mp44");
	deletePlacedEntity("mpweapon_kar98k_scoped");
	deletePlacedEntity("mpweapon_fg42");
	deletePlacedEntity("mpweapon_panzerfaust");
	deletePlacedEntity("mpweapon_stielhandgranate");
	deletePlacedEntity("mpweapon_fraggrenade");
	deletePlacedEntity("mpweapon_mk1britishfrag");
	deletePlacedEntity("mpweapon_russiangrenade");
	deletePlacedEntity("mpweapon_colt");
	deletePlacedEntity("mpweapon_luger");

	deletePlacedEntity("item_ammo_stielhandgranate_closed");
	deletePlacedEntity("item_ammo_stielhandgranate_open");
	deletePlacedEntity("item_health");
	deletePlacedEntity("item_health_large");
	deletePlacedEntity("item_health_small");

	deletePlacedEntity("misc_mg42");
	deletePlacedEntity("misc_turret");
}

monotone(str, loop)
{
	if(!isDefined(str))
		return "";

	_str = "";
	for(i = 0; i < str.size; i++) {
		if(str[i] == "^" &&
			((i + 1) < str.size &&
				(validate_number(str[i + 1]))
			)) {
			i++;
			continue;
		}

		_str += str[i];
	}

	if(!isDefined(loop))
		_str = monotone(_str, true);

	return _str;
}

getPlayersByName(n1)
{
	a = [];
	p = getOnlinePlayers();
	for(i = 0; i < p.size; i++) {
		n2 = monotone(p[i].name);
		n2 = strip(n2);
		if(n2.size >= n1.size) {
			if(pmatch(tolower(n2), tolower(n1)))
				a[a.size] = p[i];
		}
	}

	return a;
}

/*contains(sString, sOtherString) // from Cheese
{
	// loop through the string to check
	for(i = 0; i < sString.size; i++) {
		x = 0;
		tmp = "";

		// string to check against
		for(j = 0; j < sOtherString.size; j++) {
				cur = sOtherString[j];

				if((i + j) > sString.size)
					break;

				next = sString[i + j];

				if(cur == next) {
					tmp += cur;
					x++;
					continue;
				}

				break;
		}

		// looped through entire string, found it
		if(x == sOtherString.size && tmp == sOtherString)
			return true;
	}

	return false;
}*/

pmatch(s, p) // my attempt! Cheeses crashes out of index !!!! Should it be: if((i + j) >= sString.size -1) ????
{
	if(p.size > s.size)
		return false;

	o = 0;
	while(o <= (s.size - p.size)) {
		for(i = 0; i < p.size; i++)
			if(p[i] != s[i + o])
				break;

		if(i == p.size)
			return true;

		o++;
	}

	return false;
}

validate_number(input, isfloat)
{
	if(!isDefined(input))
		return false;

	input += ""; // convert to str

	if(!isDefined(isfloat))
		isfloat = false;

	hasdot = false;
	for(i = 0; i < input.size; i++) {
		switch(input[i]) {
			case "0": case "1": case "2":
			case "3": case "4": case "5":
			case "6": case "7": case "8":
			case "9":
			break;
			case ".": // 0.1..., no need for .1 etc yet... but could be validated by removing i == 0
				if(!isfloat || i == 0 || (i + 1) == input.size || hasdot)
					return false;

				hasdot = true;
			break;
			case "-": // allow "negative" numbers
				if(i == 0 && input.size > 1) //if(i == 0 && input.size > 1 && input[i] == "-")
					break;
			default:
				return false;
		}
	}

	return true;
}

getOnlinePlayers() // get all online players, apparently getEntArray doesn't list 999/connecting players
{
	p = [];

	maxclients = GetCvarInt("sv_maxClients");
	if(maxclients < 0 || maxclients > 64)
		return p;

	for(i = 0; i < maxclients; i++) {
		player = GetEntByNum(i);
		if(isDefined(player))
			p[p.size] = player;
	}

	return p;
}

deletePlacedEntity(sEntityType)
{
	eEntities = getEntArray(sEntityType, "classname");
	for(i = 0; i < eEntities.size; i++)
		eEntities[i] delete();
}

// _newspawn(position, angles, recursive)
// {
// 	newspawn = [];
//
// 	// doublecheck and recode...
// 	for(i = 0; i < 360; i += 36) {
// 		angle = (0, i, 0);
//
// 		trace = bulletTrace(position, position + maps\mp\_utility::vectorscale(anglesToForward(angle), 48), true, self); // vectorscale change from 40 to 42
// 		if(trace["fraction"] == 1 && !positionWouldTelefrag(trace["position"]) && _canspawnat(trace["position"])) {
// 			self spawn(trace["position"], angles);
// 			return trace["position"];
// 		}
//
// 		newspawn[newspawn.size] = trace["position"];
// 		wait 0.05;
// 	}
//
// 	// doublecheck and recode...
// 	if(!isDefined(recursive)) {
// 		for(j = 0; j < newspawn.size; j++) {
// 			if(isDefined(newspawn[j]))
// 				self thread _newspawn(newspawn[j], angles, true);
// 		}
//
// 		wait 3;
//
// 		return position; // giving up, push anyways
// 	}
// }

_newspawn(position, angles, recursive) // 2022 code: threads for recursive?
{
	newspawn = [];

	for(i = 0; i < 360; i += 36) {
		angle = (0, i, 0);

		trace = bulletTrace(position, position + maps\mp\_utility::vectorscale(anglesToForward(angle), 48), true, self);
		if(trace["fraction"] == 1 && !positionWouldTelefrag(trace["position"]) && _canspawnat(trace["position"])) {
			self spawn(trace["position"], angles);
			return trace["position"];
		}

		newspawn[newspawn.size] = trace["position"];
		wait 0.05;
	}

	if(!isDefined(recursive)) {
		for(j = 0; j < newspawn.size; j++) {
			if(isDefined(newspawn[j]))
				_newspawn(newspawn[j], angles, true);
		}

		return position; // giving up, push anyways
	}
}

// _canspawnat(position)
// {
// 	position = position + (-32, -32, 0);
//
// 	trace = [];
// 	for(x = 0; x < 32; x++) {
// 		for(y = 0; y < 32; y++) {
// 			trace[y] = bulletTrace(position + (x, y, 0), position + (x, y, 72), true, self);
//
// 			if(trace[y]["fraction"] != 1)
// 				return false;
// 		}
// 	}
//
// 	return true;
// }

_canspawnat(position) // 2022 code: this fixes bug introduced by original coder, like 12+ years ago...
{
	position = position + (-32, -32, 0);
	for(x = 0; x < 64; x++) {
		for(y = 0; y < 64; y++) {
			trace = bulletTrace(position + (x, y, 0), position + (x, y, 72), true, self);

			if(trace["fraction"] != 1)
				return false;
		}
	}

	return true;
}

freezePlayer(time)
{
	object = spawn("script_origin", self.origin);
	self linkTo(object);

	while(time != 0) {
		wait 1;
		time--;
	}

	self unlink();
	object delete();
}

_tmpHudsForFunEvent()
{
	wait 0.5;
	if(!isDefined(level.tmpHudsForFunEvent)) {
		level.tmpHudsForFunEvent = newHudElem();
		level.tmpHudsForFunEvent.archived = false;
		level.tmpHudsForFunEvent.x = 320;
		level.tmpHudsForFunEvent.y = 40;
		level.tmpHudsForFunEvent.alignX = "center";
		level.tmpHudsForFunEvent.alignY = "middle";
		level.tmpHudsForFunEvent.sort = 9500;
		level.tmpHudsForFunEvent.fontScale = 3.0;
		level.tmpHudsForFunEvent.color = (1, 0.2, 0);
		level.tmpHudsForFunEvent setText(&"Please wait...");

		players = getEntArray("player", "classname");
		for(i = 0; i < players.size; i++) {
			players[i].sessionstate = "spectator";
			players[i].spectatorclient = -1;

			resettimeout();

			players[i] setClientCvar("g_scriptMainMenu", "");
			players[i] closeMenu();
		}
	} else
		level.tmpHudsForFunEvent destroy();
}

vectorScale(vec, scale) {
	vec = (vec[0] * scale, vec[1] * scale, vec[2] * scale);
	return vec;
}

isPrimaryWeapon(sWeapon)
{
	if(!isDefined(sWeapon)) return false;
	switch(sWeapon) {
		// rifles
		case "mosin_nagant_mp":
		case "kar98k_mp":
		case "enfield_mp":
		// snipers
		case "mosin_nagant_sniper_mp":
		case "kar98k_sniper_mp":
		case "springfield_mp":
		// semi auto
		case "m1carbine_mp":
		case "m1garand_mp":
		// full auto
		case "ppsh_mp":
		case "thompson_mp":
		case "mp40_mp":
		case "sten_mp":
		// heavy
		case "mp44_mp":
		case "bar_mp":
		case "bren_mp":
		// extra
		case "fg42_mp":
		case "panzerfaust_mp":
			return true;
	}

	return false;
}

isSecondaryWeapon(sWeapon)
{
	if(!isDefined(sWeapon)) return false;
	switch(sWeapon) {
		case "colt_mp":
		case "luger_mp":
			return true;
	}

	return false;
}

isGrenade(sWeapon)
{
	if(!isDefined(sWeapon)) return false;
	switch(sWeapon) {
		// german
		case "stielhandgranate_mp":
		// russian
		case "rgd-33russianfrag_mp":
		// british
		case "mk1britishfrag_mp":
		// american
		case "fraggrenade_mp":
			return true;
	}

	return false;
}

mmlog(msg)
{
	printconsole(msg + "\n");
	logPrint(msg + "\n");
}

/*mmlogfile(data, type) // data = str,arr | type = "str","arr"
{
	if(!isDefined(data))
		return;

	if(isDefined(level.mmlogfile))
		level waittil("mmlogactive");

	if(!isDefined(type))
		type = "str";

	if(!isDefined(level.mmlogfile))
		level.mmlogfile = "miscmod_cmdlog.dat"; // ident: <log data> e.g login: username - password

	level.mmlogactive = true;
	filename = level.workingdir + level.mmlogfile;
	if(fexists(filename)) {
		file = fopen(filename, "a"); // append
		if(file != -1) {
			if(type == "str")
				fwrite(data, file);
			else {
				for(i = 0; i < data.size; i++)
					fwrite(data[i], file);
			}
		}

		fclose(file);
	}

	level.mmlogactive = undefined;
}*/

/*getPlayerByNameOrNum(input) // not in use currently
{
	if(validate_number(input)) {
		player = GetEntByNum(input);
		if(!isDefined(player))
			message_player("^1ERROR: ^7No matches for numeric argument '" + input + "'.");
		return player;
	}

	players = getPlayersByName(input);

	if(players.size == 1)
		return players[0];

	if(players.size == 0) {
		message_player("^1ERROR: ^7No matches for string argument '" + input + "'.");
	} else {
		message_player("^1ERROR: ^7Too many matches for string argument '" + input + "'.");
		message_player("-------------------- --------------------------------");
		for(i = 0; i < players.size; i++) {
			if(i < 9) spaces = "   ";
			else spaces = "  ";

			for(s = spaces.size; s < 20; s++)
				spaces += " ";

			message_player(players[i] getEntityNumber() + ":" + spaces + namefix(players[i].name) + " ^1[^7Score: " + players[i].score + " | Ping: " + players[i] getping() + "^1]^7");
		}
	}

	return undefined;
}*/

message_player(msg, player)
{
	if(!isDefined(player))
		player = self;

	player sendservercommand("i \"^7^7" + level.nameprefix + ": ^7" + msg + "\""); // ^7^7 fixes spaces problem
}

message(msg)
{
	sendservercommand("i \"^7^7" + level.nameprefix + ": ^7" + msg + "\""); // ^7^7 fixes spaces problem
}

playerByNum(num)
{
	if(validate_number(num)) {
		if(((int)num >= 0 || (int)num <= 64)) {
			player = GetEntByNum(num);
			if(isPlayer(player))
				return player;
		}
	}

	return undefined;
}
