function OnPostSpawn() {
	catcher <- Entities.FindByClassnameNearest("prop_laser_catcher",self.GetCenter(),32);
	fw <- catcher.GetForwardVector();
	fwdir <- fw.Dot(Vector(1,1,1));
	fw <- fw*fwdir*8;
	back <- fw;
	if (fwdir > 0) {
		fw *= 2;
	} else {
		back *= 2;
	}
	up <- catcher.GetUpVector();
	up <- up*up.Dot(Vector(32,32,32));
	left <- catcher.GetLeftVector();
	left <- left*left.Dot(Vector(40,40,40));
	bound_mins <- Vector(0,0,0)-back-up-left;
	bound_maxs <- fw+up+left;
	catcher <- Entities.FindByClassnameNearest("point_laser_target",self.GetCenter(),32);
	catcher.SetSize(bound_mins,bound_maxs);
}