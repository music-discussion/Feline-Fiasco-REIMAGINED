package meta.state;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxCamera;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.system.ui.FlxSoundTray;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.app.Application;
import meta.MusicBeat.MusicBeatState;
import meta.data.*;
import meta.data.dependency.Discord;
import meta.data.font.Alphabet;
import meta.state.menus.*;
import openfl.Assets;

using StringTools;

/**
	I hate this state so much that I gave up after trying to rewrite it 3 times and just copy pasted the original code
	with like minor edits so it actually runs in forever engine. I'll redo this later, I've said that like 12 times now

	I genuinely fucking hate this code no offense ninjamuffin I just dont like it and I don't know why or how I should rewrite it
	
	"lmao coward" -Tucker 2022
**/
class TitleState extends MusicBeatState
{
	static var initialized:Bool = false;

	var blackScreen:FlxSprite;
	var credGroup:FlxGroup;
	var credTextShit:Alphabet;
	var textGroup:FlxGroup;
	var ngSpr:FlxSprite;
	
	var cam1:FlxCamera;
	var cam2:FlxCamera;
	var defaultCamZoom:Float = 1.05;
	
	var curWacky:Array<String> = [];

	var wackyImage:FlxSprite;

	override public function create():Void
	{
		controls.setKeyboardScheme(None, false);
		curWacky = FlxG.random.getObject(getIntroTextShit());
		super.create();

		startIntro();
	}

	var logoBl:FlxSprite;
	var gfDance:FlxSprite;
	var danceLeft:Bool = false;
	var titleText:FlxSprite;

	function startIntro()
	{
		if (!initialized)
		{
			///*
			#if !html5
			Discord.changePresence('TITLE SCREEN', 'Main Menu');
			#end
			
			ForeverTools.resetMenuMusic(true);

			if (FlxG.save.data.weekCompleted == null)
				FlxG.save.data.weekCompleted = false;
			
			if (FlxG.save.data.amazingAchievement == null)
				FlxG.save.data.amazingAchievement = false;
				
			#if debug
			FlxG.save.data.weekCompleted = true;
			FlxG.save.data.amazingAchievement = true;
			#end
		}

		persistentUpdate = true;

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menus/base/title/bg'));
		// bg.antialiasing = true;
		// bg.setGraphicSize(Std.int(bg.width * 0.6));
		// bg.updateHitbox();
		add(bg);
		
		// create the camera
		cam1 = new FlxCamera();

		// create the other camera (separate for the depth effect)
		cam2 = new FlxCamera();
		cam2.bgColor.alpha = 0;

		FlxG.cameras.reset(cam1);
		FlxG.cameras.add(cam2);
		FlxCamera.defaultCameras = [cam1];
		
		FlxG.camera.zoom = defaultCamZoom;

		logoBl = new FlxSprite(-150, -100);
		logoBl.frames = Paths.getSparrowAtlas('menus/base/title/logoBumpin');
		logoBl.antialiasing = true;
		logoBl.animation.addByPrefix('bump', 'logo bumpin', 24, false);
		logoBl.animation.play('bump');
		logoBl.updateHitbox();
		// logoBl.screenCenter();
		// logoBl.color = FlxColor.BLACK;

		gfDance = new FlxSprite(FlxG.width * 0.5, FlxG.height * 0.08);
		gfDance.frames = Paths.getSparrowAtlas('menus/base/title/gfDanceTitle');
		gfDance.animation.addByPrefix('dance', 'kady idle instance 1', 24, false);
		gfDance.antialiasing = true;
		add(gfDance);
		add(logoBl);

		titleText = new FlxSprite(125, FlxG.height * 0.8);
		titleText.frames = Paths.getSparrowAtlas('menus/base/title/titleEnter');
		titleText.animation.addByPrefix('idle', "Press Enter to Begin", 24);
		titleText.animation.addByPrefix('press', "ENTER PRESSED", 24);
		titleText.antialiasing = true;
		titleText.animation.play('idle');
		titleText.updateHitbox();
		// titleText.screenCenter(X);
		add(titleText);

		// var logo:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menus/base/title/logo'));
		// logo.screenCenter();
		// logo.antialiasing = true;
		// add(logo);
		
		if ((!Init.trueSettings.get('Reduced Movements')))
		{
			FlxTween.tween(logoBl, {y: logoBl.y + 5}, 1.2, {ease: FlxEase.quadInOut, type: PINGPONG});
			FlxTween.tween(gfDance, {y: gfDance.y + 5}, 1.2, {ease: FlxEase.quadInOut, type: PINGPONG, startDelay: 0.3});
			FlxTween.tween(titleText, {angle: 1}, 1.6, {ease: FlxEase.quadInOut, type: PINGPONG});
		}
		// FlxTween.tween(logo, {y: logoBl.y + 50}, 0.6, {ease: FlxEase.quadInOut, type: PINGPONG, startDelay: 0.1});

		credGroup = new FlxGroup();
		add(credGroup);
		textGroup = new FlxGroup();

		blackScreen = new FlxSprite().loadGraphic(Paths.image('menus/base/title/bg'));
		credGroup.add(blackScreen);
		
		FlxG.camera.fade(FlxColor.BLACK, 0.8, true); 

		credTextShit = new Alphabet(0, 0, "ninjamuffin99\nPhantomArcade\nkawaisprite\nevilsk8er", true);
		credTextShit.screenCenter();

		// credTextShit.alignment = CENTER;

		credTextShit.visible = false;

		ngSpr = new FlxSprite(0, FlxG.height * 0.52).loadGraphic(Paths.image('menus/base/title/newgrounds_logo'));
		add(ngSpr);
		ngSpr.visible = false;
		ngSpr.setGraphicSize(Std.int(ngSpr.width * 0.8));
		ngSpr.updateHitbox();
		ngSpr.screenCenter(X);
		ngSpr.antialiasing = true;

		FlxTween.tween(credTextShit, {y: credTextShit.y + 20}, 2.9, {ease: FlxEase.quadInOut, type: PINGPONG});

		if (initialized)
			skipIntro();
		else
			initialized = true;

		// credGroup.add(credTextShit);
	}

	function getIntroTextShit():Array<Array<String>>
	{
		var swagGoodArray:Array<Array<String>> = [];
		if (Assets.exists(Paths.txt('introText')))
		{
			var fullText:String = Assets.getText(Paths.txt('introText'));
			var firstArray:Array<String> = fullText.split('\n');

			for (i in firstArray)
				swagGoodArray.push(i.split('--'));
		}

		return swagGoodArray;
	}

	var transitioning:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;
		// FlxG.watch.addQuick('amp', FlxG.sound.music.amplitude);
		
		FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, 0.95);
		cam2.zoom = FlxMath.lerp(defaultCamZoom, cam2.zoom, 0.95);

		var pressedEnter:Bool = FlxG.keys.justPressed.ENTER;

		#if mobile
		for (touch in FlxG.touches.list)
		{
			if (touch.justPressed)
			{
				pressedEnter = true;
			}
		}
		#end

		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

		if (gamepad != null)
		{
			if (gamepad.justPressed.START)
				pressedEnter = true;

			#if switch
			if (gamepad.justPressed.B)
				pressedEnter = true;
			#end
		}

		if (pressedEnter && !transitioning && skippedIntro)
		{
			titleText.animation.play('press');

			FlxG.camera.flash(FlxColor.WHITE, 1);
			FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);

			transitioning = true;
			// FlxG.sound.music.stop();

			new FlxTimer().start(1.2, function(tmr:FlxTimer)
			{
				Main.switchState(this, new MainMenuState());
			});
			// FlxG.sound.play(Paths.music('titleShoot'), 0.7);
		}

		// hi game, please stop crashing its kinda annoyin, thanks!
		if (pressedEnter && !skippedIntro && initialized)
		{
			skipIntro();
		}

		super.update(elapsed);
	}

	function createCoolText(textArray:Array<String>)
	{
		for (i in 0...textArray.length)
		{
			var money:Alphabet = new Alphabet(0, 0, textArray[i], true, false);
			money.cameras = [cam2];
			money.screenCenter(X);
			money.y += (i * 60) + 200;
			credGroup.add(money);
			textGroup.add(money);
		}
	}

	function addMoreText(text:String)
	{
		var coolText:Alphabet = new Alphabet(0, 0, text, true, false);
		coolText.cameras = [cam2];
		coolText.screenCenter(X);
		coolText.y += (textGroup.length * 60) + 200;
		credGroup.add(coolText);
		textGroup.add(coolText);
	}

	function deleteCoolText()
	{
		while (textGroup.members.length > 0)
		{
			credGroup.remove(textGroup.members[0], true);
			textGroup.remove(textGroup.members[0], true);
		}
	}

	override function beatHit()
	{
		super.beatHit();
		
		if ((!Init.trueSettings.get('Reduced Movements')))
		{
			FlxG.camera.zoom += 0.015;
			cam2.zoom += 0.03;
		}

		logoBl.animation.play('bump');

		gfDance.animation.play('dance');

		FlxG.log.add(curBeat);

		switch (curBeat)
		{
			case 1:
				createCoolText(['tuckerthetucker', 'DEAD SKULLXX', 'xeno', 'discussions']);

			// credTextShit.visible = true;
			case 3:
				addMoreText('present');
			// credTextShit.text += '\npresent...';
			// credTextShit.addText();
			case 4:
				deleteCoolText();
			// credTextShit.visible = false;
			// credTextShit.text = 'In association \nwith';
			// credTextShit.screenCenter();
			case 5:
				createCoolText(['First time', 'using']);
			case 7:
				addMoreText('Forever Engine');
			// credTextShit.text += '\nNewgrounds';

			case 8:
				deleteCoolText();
				ngSpr.visible = false;
			// credTextShit.visible = false;

			// credTextShit.text = 'Shoutouts Tom Fulp';
			// credTextShit.screenCenter();
			case 9:
				createCoolText([curWacky[0]]);
			// credTextShit.visible = true;
			case 11:
				addMoreText(curWacky[1]);
			// credTextShit.text += '\nlmao';
			case 12:
				deleteCoolText();
			// credTextShit.visible = false;
			// credTextShit.text = "Friday";
			// credTextShit.screenCenter();
			case 13:
				addMoreText('FNF');
			// credTextShit.visible = true;
			case 14:
				addMoreText('FELINE');
			// credTextShit.text += '\nNight';
			case 15:
				addMoreText('FIASCO'); // credTextShit.text += '\nFunkin';

			case 16:
				skipIntro();
		}
	}

	var skippedIntro:Bool = false;

	function skipIntro():Void
	{
		if (!skippedIntro)
		{
			remove(ngSpr);

			FlxG.camera.flash(FlxColor.WHITE, 4);
			remove(credGroup);
			skippedIntro = true;
		}
		//
	}
}
