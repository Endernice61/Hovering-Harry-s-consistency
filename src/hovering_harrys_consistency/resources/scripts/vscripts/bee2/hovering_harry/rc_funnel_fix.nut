//DoIncludeScript("hovering_harry/cuboid.nut",this);

cubes <- [];

enum Solid { BBOX = 3 }
enum CollisionGroup {
	IN_VEHICLE = 10,//Solid to nothing
	PLAYER_HELD = 23,
	WEIGHTED_CUBE = 24
}

function createTrigger() {
	local trigger = Entities.CreateByClassname("trigger_multiple");
	trigger.__KeyValueFromInt("solid",Solid.BBOX);
	trigger.__KeyValueFromInt("CollisionGroup",CollisionGroup.IN_VEHICLE);//Don't collide with anything
	return trigger;
}

function createMapTrigger() {
	local trigger = createTrigger();
	trigger.SetSize(Vector(-9000000,-9000000,-9000000),Vector(9000000,9000000,9000000));//Cover the whole map
	return trigger;
}

function createCubeTrigger() {
	local trigger = createMapTrigger();
	trigger.__KeyValueFromInt("spawnflags",8);//Trigger on physics
	trigger.__KeyValueFromString("filtername",EntityGroup[0].GetName());//Filter to cubes that have just spawned
	
	trigger.__KeyValueFromString("OnStartTouch","!activator,CallScriptFunction,RCFunnelFixCubeSpawned,0");
	EntFireByHandle(trigger,"Enable","",0,null,null);
	return trigger;
}

function addCube(cube) {
	cubes.push(cube);
	cube.ValidateScriptScope();
	cube.GetScriptScope().rc_funnel_fix_held <- false;
	EntFireByHandle(cube,"AddContext","rc_funnel_fix_rc:1",0,null,null);//Add to rc filter
	cube.__KeyValueFromString("OnPlayerPickup","!self,CallScriptFunction,RCFunnelFixPickup,0");
	cube.__KeyValueFromString("OnPhysGunDrop","!self,CallScriptFunction,RCFunnelFixDrop,0");
}

function cubeSpawned(cube) {
	EntFireByHandle(cube,"AddContext","rc_funnel_fix_spawned:1",0,null,null);//Remove from cube trigger filter
	if (cube.LookupAttachment("focus")) { addCube(cube); } //"focus" attachment should be defined for reflection cubes
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
RCFunnelFix.cube_trigger <- createCubeTrigger();

getroottable().RCFunnelFixCubeSpawned <- function() { RCFunnelFix.script.GetScriptScope().cubeSpawned(self); };

function Think() {
	for (local i = 0; i<cubes.len(); ) {
		if (cubes[i].IsValid()) {
			cubes[i].GetScriptScope().RCFunnelFixCubeUpdate();
			++i;
		} else {
			cubes[i] = cubes[cubes.len()-1];
			cubes.pop();
		}
	}
	return 0.015;
}

self.ValidateScriptScope();

/*function Think() {
	foreach (funnel in funnels()) {
		funnel.ValidateScriptScope();
		if ("rc_funnel_fix_trigger" in funnel.GetScriptScope()) { }
		else {
			funnel.GetScriptScope().rc_funnel_fix_trigger <- createFunnelTrigger(funnel);
		}
	}
	for (local i = 0; i<funnel_triggers.len(); ) {
		if (funnel_triggers[i].IsValid()) {
			updateFunnelTrigger(funnel_triggers[i]);
			++i;
		} else {
			funnel_triggers[i] = funnel_triggers[funnel_triggers.len()-1];
			funnel_triggers.pop();
		}
	}
	return 0.015;
}*/

/*function funnels() {
	local funnel = null;
	while (funnel = Entities.FindByClassname(funnel,"trigger_tractorbeam")) {
		yield funnel;
	}
	return;
}

funnel_triggers <- [];

function createFunnelTrigger(funnel) {
	local trigger = createTrigger();
	trigger.__KeyValueFromInt("spawnflags",8);//Trigger on physics
	trigger.__KeyValueFromInt("CollisionGroup",10);//It works
	trigger.__KeyValueFromString("filtername",EntityGroup[1].GetName());
	
	trigger.__KeyValueFromString("OnStartTouch","!activator,CallScriptFunction,RCFunnelFixCubeUpdate,0.01");
	trigger.__KeyValueFromString("OnEndTouch","!activator,CallScriptFunction,RCFunnelFixCubeUpdate,0.01");
	
	trigger.SetOrigin(funnel.GetOrigin());
	trigger.SetAbsOrigin(funnel.GetOrigin());
	local angles = funnel.GetAngles();
	trigger.SetAngles(angles.x,angles.y,angles.z);
	EntFireByHandle(trigger,"SetParent","!activator",0,funnel,null);
	funnel_triggers.push(trigger);
	
	EntFireByHandle(trigger,"Enable","",0,null,null);
	
	return trigger;
}

function updateFunnelTrigger(trigger) {
	local funnel = trigger.GetMoveParent();
	trigger.SetSize(funnel.GetBoundingMins(),funnel.GetBoundingMaxs());
}*/