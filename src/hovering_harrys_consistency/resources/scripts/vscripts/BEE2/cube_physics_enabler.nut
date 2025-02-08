function WakeAllCubes() {
	local ent = null;
	while (ent = Entities.FindByClassname(ent, "prop_weighted_cube")) {
		EntFireByHandle(ent, "wake", "", 0, null, null);
	}
}