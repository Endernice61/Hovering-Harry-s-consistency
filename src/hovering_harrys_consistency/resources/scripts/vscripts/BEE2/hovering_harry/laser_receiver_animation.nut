PlaybackRate <- 0
PlaybackAccelerate <- 0

function SetAnimation(accel) {
	if (PlaybackAccelerate == 0) {
		PlaybackAccelerate <- accel;
		AnimateFrame();
		return;
	}
	PlaybackAccelerate <- accel;
}

function AnimateFrame() {
	PlaybackRate += PlaybackAccelerate.tofloat()/33;
	if (PlaybackRate < 0) {
		PlaybackRate <- 0;
		PlaybackAccelerate <- 0;
		EntFireByHandle(self, "SetPlaybackRate", "0", 0, null, null);
		return;
	}
	if (PlaybackRate > 1) {
		PlaybackRate <- 1;
		PlaybackAccelerate <- 0;
		EntFireByHandle(self, "SetPlaybackRate", "1", 0, null, null);
		return;
	}
	EntFireByHandle(self, "SetPlaybackRate", PlaybackRate.tostring(), 0, null, null);
	EntFireByHandle(self, "RunScriptCode", "AnimateFrame()", 0.015, null, null);
}