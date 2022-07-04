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
	This is the main menu state! Not a lot is going to change about it so it'll remain similar to the original, but I do want to condense some code and such.
	Get as expressive as you can with this, create your own menu!
**/
class MainMenuState extends MusicBeatState
{
	var menuItems:FlxTypedGroup<FlxSprite>;
	var curSelected:Int = 3; //if its 0, it starts at credits and not story mode

	var bg:FlxSprite; // the background has been separated for more control
	var bd:FlxBackdrop;
	var magenta:FlxSprite;
	var logo:FlxSprite;
	var promoChars:FlxSprite;
	var versionShit:FlxText;
	var camFollow:FlxObject;
	
	var cam1:FlxCamera;
	var cam2:FlxCamera;
	var defaultCamZoom:Float = 1.05;
	
	var infoText:FlxText;

	var optionShit:Array<String> = ['credits', 'options', 'freeplay', 'story mode']; //the options button overlaps the freeplay button if i dont reverse it
	var canSnap:Array<Float> = [];
	
	var descText:Array<String> = [
		'Take a look at all the people whose made this mod possible!',
		'Change your options to best suit how you play the mod!',
		'Check out all the songs seperately with autoplay and charting!',
		'Play the songs in order with dialogue to check out!   '
	];

	// the create 'state'
	override function create()
	{
		super.create();
		
		// create the camera
		cam1 = new FlxCamera();

		// create the other camera (separate for the depth effect)
		cam2 = new FlxCamera();
		cam2.bgColor.alpha = 0;

		FlxG.cameras.reset(cam1);
		FlxG.cameras.add(cam2);
		FlxCamera.defaultCameras = [cam1];
		
		FlxG.camera.zoom = defaultCamZoom;

		// set the transitions to the previously set ones
		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		// make sure the music is playing
		ForeverTools.resetMenuMusic();
		
		persistentUpdate = true;

		#if !html5
		Discord.changePresence('MENU SCREEN', 'Main Menu');
		#end

		// uh
		persistentUpdate = persistentDraw = true;
		
		//backdrop
		bd = new FlxBackdrop(Paths.image('menus/base/title/backdrop'), 1, 1, true, true);
		bd.scrollFactor.set();
		bd.updateHitbox();
		add(bd);

		// background
		bg = new FlxSprite(-85);
		bg.loadGraphic(Paths.image('menus/base/menuBG'));
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0;
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);

		magenta = new FlxSprite(-85).loadGraphic(Paths.image('menus/base/menuBGMagenta'));
		magenta.scrollFactor.x = 0;
		magenta.scrollFactor.y = 0;
		magenta.setGraphicSize(Std.int(magenta.width * 1.1));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = true;
		add(magenta);
		
		logo = new FlxSprite(10, 10);
		logo.frames = Paths.getSparrowAtlas('menus/base/title/logoBumpin');
		logo.animation.addByPrefix('bump', 'logo bumpin', 24, false);
		logo.setGraphicSize(Std.int(logo.width * 0.2));
		logo.scrollFactor.set();
		logo.updateHitbox();
		logo.cameras = [cam2];
		add(logo);
		
		promoChars = new FlxSprite(300, -275).loadGraphic(Paths.image('menus/base/promochar'));
		promoChars.setGraphicSize(Std.int(promoChars.width * 0.6));
		promoChars.alpha = 0;
		promoChars.cameras = [cam2];
		promoChars.scrollFactor.set();
		add(promoChars);
		
		// from the base game lol
		versionShit = new FlxText(35, FlxG.height - 50, 0, "FF v1.0.0", 12);
		versionShit.color = FlxColor.WHITE;
		versionShit.borderStyle = FlxTextBorderStyle.OUTLINE;
		versionShit.borderColor = FlxColor.BLACK;
		versionShit.borderSize = 2;
		versionShit.cameras = [cam2];
		versionShit.scrollFactor.set();
		add(versionShit);
		
		infoText = new FlxText(0, FlxG.height - 120, 0, '', 32);
		infoText.screenCenter(X);
		infoText.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		infoText.scrollFactor.set();
		infoText.cameras = [cam2];
		add(infoText);
		
		FlxTween.tween(promoChars, {y: promoChars.y += 10, alpha: 1}, 1.2, {
			ease: FlxEase.quadInOut,
			onComplete: function(twn:FlxTween)
			{
				FlxTween.tween(promoChars, {angle: 1}, 2, {ease: FlxEase.quadInOut, type: PINGPONG});
			}
		});

		// add the camera
		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		// add the menu items
		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		// create the menu items themselves
		var tex = Paths.getSparrowAtlas('menus/base/title/FNF_main_menu_assets');

		// loop through the menu options
		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite(0, 80 + (i * 200));
			menuItem.frames = tex;
			// add the animations in a cool way (real
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			canSnap[i] = -1;
			// set the id
			menuItem.ID = i;
			// menuItem.alpha = 0;
			// if the id is divisible by 2
			if (menuItem.ID % 2 == 0)
				menuItem.x += 1000;
			else
				menuItem.x -= 1000;

			// actually add the item
			menuItems.add(menuItem);
			menuItem.scrollFactor.set();
			menuItem.cameras = [cam2];
			menuItem.antialiasing = true;
			menuItem.updateHitbox();

			/*
				FlxTween.tween(menuItem, {alpha: 1, x: ((FlxG.width / 2) - (menuItem.width / 2))}, 0.35, {
					ease: FlxEase.smootherStepInOut,
					onComplete: function(tween:FlxTween)
					{
						canSnap[i] = 0;
					}
			});*/
		}
		
		menuItems.forEach(function(spr:FlxSprite)
		{
			if (spr.ID == 3) //story mode
			{
				spr.x = 100;
				spr.y = 250;
			}
			
			if (spr.ID == 2) //freeplay
			{
				spr.x = 150;
				spr.y = 350;
			}
			
			if (spr.ID == 1) //settings
			{
				spr.x = 300;
				spr.y = 350;
			}
			
			if (spr.ID == 0) //credits
			{
				spr.x = 175;
				spr.y = 425;
			}
		});

		// set the camera to actually follow the camera object that was created before
		var camLerp = Main.framerateAdjust(0.10);
		FlxG.camera.follow(camFollow, null, camLerp);

		updateSelection();
	}

	// var colorTest:Float = 0;
	var selectedSomethin:Bool = false;
	var counterControl:Float = 0;
	var finalText:String;
	var textValue:String = '';
	var infoTimer:FlxTimer;
	
	override function update(elapsed:Float)
	{		
		bd.x -= elapsed * 20;
		bd.y -= elapsed * 20;
		
		if (descText[curSelected] != null)
		{
			var textValue = descText[curSelected];
			if (textValue == null)
					textValue = "";

			if (finalText != textValue)
			{
				// trace('call??');
				// trace(textValue);
				regenInfoText();

				var textSplit = [];
				finalText = textValue;
				textSplit = finalText.split("");

				var loopTimes = 0;
				infoTimer = new FlxTimer().start(0.025, function(tmr:FlxTimer)
				{
					//
					infoText.text += textSplit[loopTimes];
					infoText.screenCenter(X);

					loopTimes++;
				}, textSplit.length);
			}
		}
		
		#if debug
		if (FlxG.keys.justPressed.FIVE)
			Main.switchState(this, new OffsetState('gf-kadyhair', false));
		#end
		
		// colorTest += 0.125;
		// bg.color = FlxColor.fromHSB(colorTest, 100, 100, 0.5);
		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;
		
		FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, 0.95);
		cam2.zoom = FlxMath.lerp(defaultCamZoom, cam2.zoom, 0.95);

		var up = controls.UI_UP;
		var down = controls.UI_DOWN;
		var up_p = controls.UI_UP_P;
		var down_p = controls.UI_DOWN_P;
		var controlArray:Array<Bool> = [up, down, up_p, down_p];

		if ((controlArray.contains(true)) && (!selectedSomethin))
		{
			for (i in 0...controlArray.length)
			{
				// here we check which keys are pressed
				if (controlArray[i] == true)
				{
					// if single press
					if (i > 1)
					{
						// up is 2 and down is 3
						// paaaaaiiiiiiinnnnn
						if (i == 2)
							curSelected++; // i swapped them since i reversed the order
						else if (i == 3)
							curSelected--;

						FlxG.sound.play(Paths.sound('scrollMenu'));
					}
					/* idk something about it isn't working yet I'll rewrite it later
						else
						{
							// paaaaaaaiiiiiiiinnnn
							var curDir:Int = 0;
							if (i == 0)
								curDir = -1;
							else if (i == 1)
								curDir = 1;

							if (counterControl < 2)
								counterControl += 0.05;

							if (counterControl >= 1)
							{
								curSelected += (curDir * (counterControl / 24));
								if (curSelected % 1 == 0)
									FlxG.sound.play(Paths.sound('scrollMenu'));
							}
					}*/

					if (curSelected < 0)
						curSelected = optionShit.length - 1;
					else if (curSelected >= optionShit.length)
						curSelected = 0;
				}
				//
			}
		}
		else
		{
			// reset variables
			counterControl = 0;
		}

		if ((controls.ACCEPT) && (!selectedSomethin))
		{
			//
			selectedSomethin = true;
			FlxG.sound.play(Paths.sound('confirmMenu'));

			FlxFlicker.flicker(magenta, 0.8, 0.1, false);

			menuItems.forEach(function(spr:FlxSprite)
			{
				if (curSelected != spr.ID)
				{
					FlxTween.tween(spr, {alpha: 0}, 0.4, {
						ease: FlxEase.quadOut,
						onComplete: function(twn:FlxTween)
						{
							spr.kill();
						}
					});
				}
				else
				{
					FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
					{
						var daChoice:String = optionShit[Math.floor(curSelected)];

						switch (daChoice)
						{
							case 'story mode':
								Main.switchState(this, new StoryMenuState());
							case 'freeplay':
								Main.switchState(this, new FreeplayState());
							case 'options':
								transIn = FlxTransitionableState.defaultTransIn;
								transOut = FlxTransitionableState.defaultTransOut;
								Main.switchState(this, new OptionsMenuState());
							case 'credits':
								Main.switchState(this, new CreditState());
						}
					});
				}
			});
		}

		if (Math.floor(curSelected) != lastCurSelected)
			updateSelection();

		super.update(elapsed);
	}

	var lastCurSelected:Int = 0;
	
	override function beatHit()
	{
		super.beatHit();
		
		logo.animation.play('bump');
		
		if ((!Init.trueSettings.get('Reduced Movements')))
		{
			FlxG.camera.zoom += 0.015;
			cam2.zoom += 0.03;
		}
	}
	
	private function regenInfoText()
	{
		if (infoTimer != null)
			infoTimer.cancel();
		if (infoText != null)
			infoText.text = "";
	}

	private function updateSelection()
	{
		// reset all selections
		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');
			spr.updateHitbox();
		});

		// set the sprites and all of the current selection
		camFollow.setPosition(menuItems.members[Math.floor(curSelected)].getGraphicMidpoint().x,
			menuItems.members[Math.floor(curSelected)].getGraphicMidpoint().y);

		if (menuItems.members[Math.floor(curSelected)].animation.curAnim.name == 'idle')
			menuItems.members[Math.floor(curSelected)].animation.play('selected');

		menuItems.members[Math.floor(curSelected)].updateHitbox();

		lastCurSelected = Math.floor(curSelected);
	}
}
