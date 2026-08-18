enabled <- 1;

function EnableWaker() {
	enabled <- 1;
	WakeAllCubes();
}

function DisableWaker() {
	enabled <- 0;
}

function WakeAllCubes() {
	if (enabled) {
		local ent = null;
		while (ent = Entities.FindByClassname(ent, "prop_weighted_cube")) {
			EntFireByHandle(ent, "wake", "", 0, null, null);
		}
	}
}