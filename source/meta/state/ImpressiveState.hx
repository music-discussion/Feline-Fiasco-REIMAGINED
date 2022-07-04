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

class ImpressiveState extends MusicBeatState
{
	var text1:FlxText;
	var text2:FlxText;
	
	override function create() 
	{
		super.create();
		
		text1 = new FlxText(0, 200, 0, "Impressive...", 72);
		text1.screenCenter(X);
		add(text1);
		
		text2 = new FlxText(0, 0, 1000, "", 48);
		text2.screenCenter();
		add(text2);
		if (!FlxG.save.data.amazingAchievement)
			text2.text = "Now try beating all the songs on hard without any misses for a special surprise!";
		else
			text2.text = "Check your Freeplay Songs, you earned it!";
		text2.y += 100;
	}
	
	override function update(elapsed:Float) 
	{
		if (controls.ACCEPT || controls.BACK)
			Main.switchState(this, new MainMenuState());
		
		super.update(elapsed);
	}
	
}