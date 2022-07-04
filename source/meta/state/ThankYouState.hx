package meta.state;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.addons.display.FlxBackdrop;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.util.FlxColor;
import meta.MusicBeat.MusicBeatState;
import meta.data.dependency.Discord;
import meta.data.*;
import meta.data.font.Alphabet;
import meta.state.menus.*;
import openfl.Assets;
import lime.utils.Assets;

using StringTools;

class ThankYouState extends MusicBeatState
{
	var text1:FlxText;
	
	override function create() 
	{
		super.create();
		text1 = new FlxText(0, 0, 1000, "Thank you for Playing Feline Fiasco <3", 72);
		text1.screenCenter();
		add(text1);
	}
	
	override function update(elapsed:Float) 
	{
		if (controls.ACCEPT || controls.BACK)
			Main.switchState(this, new MainMenuState());
		
		super.update(elapsed);
	}
	
}