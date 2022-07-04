package meta.state.menus;

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
/**
 * ...
 * woooo credit state! my favorite thing to do!
 */

class CreditState extends MusicBeatState
{
	var bd:FlxBackdrop;
	var nameText:FlxText;
	var descText:FlxText;
	var icon:FlxSprite;
	var leftArrow:FlxSprite;
	var rightArrow:FlxSprite;
	var credits:FlxSprite;
	var curSelected:Int = 0;
	
	var cam1:FlxCamera;
	var cam2:FlxCamera;
	var defaultCamZoom:Float = 1.05;
	
	//dynamic array my beloved
	//how 2 work the array: name, credit for, text name, border name
	var peopleArray:Array<Dynamic> = [
		["TuckerTheTucker", "Creator", FlxColor.fromRGB(0, 165, 19), FlxColor.fromRGB(26, 89, 0)],
		["DEAD SKULLXX", "Voice of Kadycat", FlxColor.WHITE, FlxColor.fromRGB(252, 113, 228)],
		["xeno", "Musician for RivalLife", FlxColor.fromRGB(255, 0, 51), FlxColor.fromRGB(100, 0, 0)],
		["Disscussions", "Bugfixes and help with Kady's notes", FlxColor.fromRGB(113, 254, 114), FlxColor.fromRGB(97, 145, 0)]
	];
	
	override function create() 
	{
		super.create();
		
		ForeverTools.resetMenuMusic();
		
		// create the camera
		cam1 = new FlxCamera();

		// create the other camera (separate for the depth effect)
		cam2 = new FlxCamera();
		cam2.bgColor.alpha = 0;

		FlxG.cameras.reset(cam1);
		FlxG.cameras.add(cam2);
		FlxCamera.defaultCameras = [cam1];
		
		FlxG.camera.zoom = defaultCamZoom;
		
		var ui_tex = Paths.getSparrowAtlas('menus/base/storymenu/campaign_menu_UI_assets');

		//backdrop
		bd = new FlxBackdrop(Paths.image('menus/base/title/backdrop'), 1, 1, true, true);
		add(bd);
		
		nameText = new FlxText(0, 400, 750, '', 36);
		nameText.screenCenter(X);
		nameText.alignment = FlxTextAlign.CENTER;
		nameText.borderStyle = FlxTextBorderStyle.OUTLINE;
		nameText.borderSize = 3;
		nameText.cameras = [cam2];
		add(nameText);
		
		descText = new FlxText(0, 500, 500, '', 36);
		descText.screenCenter(X);
		descText.alignment = FlxTextAlign.CENTER;
		descText.borderStyle = FlxTextBorderStyle.OUTLINE;
		descText.borderSize = 3;
		descText.cameras = [cam2];
		add(descText);
		
		icon = new FlxSprite(570, 100);
		icon.screenCenter(X);
		icon.loadGraphic(Paths.image('menus/base/creditGrid'), true, 150, 150);
		icon.setGraphicSize(Std.int(icon.width * 2));
		icon.antialiasing = true;
		icon.scrollFactor.set();
		icon.updateHitbox();
		icon.animation.add('thegang', [0, 1, 2, 3], 0);
		icon.animation.play('thegang');
		icon.cameras = [cam2];
		icon.x -= 150;
		add(icon);
		
		leftArrow = new FlxSprite(icon.x - 25, 225);
		leftArrow.frames = ui_tex;
		leftArrow.animation.addByPrefix('idle', "arrow left", 24, false);
		leftArrow.animation.addByPrefix('press', "arrow push left", 24, false);
		leftArrow.animation.play('idle');
		leftArrow.scrollFactor.set();
		leftArrow.cameras = [cam2];
		add(leftArrow);
		
		rightArrow = new FlxSprite(icon.x + 275, leftArrow.y);
		
		rightArrow.frames = ui_tex;
		rightArrow.animation.addByPrefix('idle', 'arrow right', 24, false);
		rightArrow.animation.addByPrefix('press', "arrow push right", 24, false);
		rightArrow.animation.play('idle');
		rightArrow.scrollFactor.set();
		rightArrow.cameras = [cam2];
		add(rightArrow);
		
		credits = new FlxSprite(0, 25);
		credits.screenCenter(X);
		credits.frames = Paths.getSparrowAtlas('menus/base/creditTitle');
		credits.animation.addByPrefix('idle', 'credits0', 24, true);
		credits.animation.play('idle');
		credits.scrollFactor.set();
		credits.x -= 165;
		credits.cameras = [cam2];
		add(credits);
		
		changeChar(0);
	}
	
	var swung:Bool = false;
	
	override function update(elapsed:Float) 
	{
		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;
			
		bd.x -= elapsed * 20;
		bd.y -= elapsed * 20;
		
		FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, 0.95);
		cam2.zoom = FlxMath.lerp(defaultCamZoom, cam2.zoom, 0.95);
		
		if (controls.UI_LEFT)
			leftArrow.animation.play('press');
		else
			leftArrow.animation.play('idle');
		if (controls.UI_RIGHT)
			rightArrow.animation.play('press');
		else
			rightArrow.animation.play('idle');
		
		if (controls.UI_LEFT_P)
		{
			changeChar(-1);
			FlxG.sound.play(Paths.sound('scrollMenu'));
		}
		if (controls.UI_RIGHT_P)
		{
			changeChar(1);
			FlxG.sound.play(Paths.sound('scrollMenu'));
		}
		
		if (controls.BACK)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			Main.switchState(this, new MainMenuState());
		}
		
		super.update(elapsed);
	}
	
	override function beatHit()
	{
		if ((!Init.trueSettings.get('Reduced Movements')))
		{
			FlxG.camera.zoom += 0.015;
			cam2.zoom += 0.03;
			
			swung = !swung;
			icon.angle = (swung ? 3 : -3);
		}
		
		super.beatHit();
	}
	
	function changeChar(change:Int)
	{
		curSelected += change;
		
		if (curSelected > 3)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = 3;
		
		nameText.text = peopleArray[curSelected][0];
		descText.text = peopleArray[curSelected][1];
		nameText.color = peopleArray[curSelected][2];
		descText.color = peopleArray[curSelected][2];
		nameText.borderColor = peopleArray[curSelected][3];
		descText.borderColor = peopleArray[curSelected][3];
		
		icon.animation.curAnim.curFrame = curSelected;
	}
	
}