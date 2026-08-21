enum CollisionGroup {
	PLAYER_HELD = 23,
	WEIGHTED_CUBE = 24
}

function addCube(cube) {
	cube.ValidateScriptScope();
	cube.GetScriptScope().rc_funnel_fix_held <- false;
	cube.__KeyValueFromString("OnPlayerPickup","!self,CallScriptFunction,RCFunnelFixPickup,0");
	cube.__KeyValueFromString("OnPhysGunDrop","!self,CallScriptFunction,RCFunnelFixDrop,0");
}

getroottable().RCFunnelFixPickup <- function() {
	rc_funnel_fix_held <- true;
	self.__KeyValueFromInt("CollisionGroup",CollisionGroup.PLAYER_HELD);
};
getroottable().RCFunnelFixDrop <- function() {
	rc_funnel_fix_held <- false;
	self.__KeyValueFromInt("CollisionGroup",CollisionGroup.WEIGHTED_CUBE);
};
getroottable().RCFunnelFixCubeUpdate <- function() {
	if (rc_funnel_fix_held) { self.__KeyValueFromInt("CollisionGroup",CollisionGroup.PLAYER_HELD); }
	else { self.__KeyValueFromInt("CollisionGroup",CollisionGroup.WEIGHTED_CUBE); }
};

getroottable().RCFunnelFix <- {};
RCFunnelFix.script <- self;

function cubes() {
	local cube = null;
	while (cube = Entities.FindByClassname(cube,"prop_weighted_cube")) {
		yield cube;
	}
	return;
}

function Think() {
	foreach (cube in cubes()) {
		if (cube.LookupAttachment("focus") == 0) { continue; }
		cube.ValidateScriptScope();
		if ("rc_funnel_fix_held" in cube.GetScriptScope()) { }
		else { addCube(cube); }
		cube.GetScriptScope().RCFunnelFixCubeUpdate();
	}
	return 0.015;
}

self.ValidateScriptScope();