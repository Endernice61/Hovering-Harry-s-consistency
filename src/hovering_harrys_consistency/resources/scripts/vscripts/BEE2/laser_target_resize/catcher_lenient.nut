catcher <- EntityGroup[0];
up <- catcher.GetUpVector();
updir <- up.Dot(Vector(1,1,1));
up <- up*up.Dot(Vector(8,8,8));
down <- up;
if (updir < 0) {
	up <- up*2;
} else {
	down <- down*2;
}
fw <- catcher.GetForwardVector();
fw <- fw*fw.Dot(Vector(32,32,32));
left <- catcher.GetLeftVector();
left <- left*left.Dot(Vector(40,40,40));
bound_mins <- Vector(0,0,0)-down-fw-left;
bound_maxs <- up+fw+left;
catcher.SetSize(bound_mins,bound_maxs);