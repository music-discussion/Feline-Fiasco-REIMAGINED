package gameObjects;

import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.util.FlxTimer;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import gameObjects.background.*;
import meta.CoolUtil;
import meta.data.Conductor;
import meta.data.dependency.FNFSprite;
import meta.state.PlayState;

using StringTools;

/**
	This is the stage class. It sets up everything you need for stages in a more organised and clean manner than the
	base game. It's not too bad, just very crowded. I'll be adding stages as a separate
	thing to the weeks, making them not hardcoded to the songs.
**/
class Stage extends FlxTypedGroup<FlxBasic>
{
	var halloweenBG:FNFSprite;
	var phillyCityLights:FlxTypedGroup<FNFSprite>;
	var phillyTrain:FNFSprite;
	var trainSound:FlxSound;

	public var limo:FNFSprite;

	public var grpLimoDancers:FlxTypedGroup<BackgroundDancer>;

	var fastCar:FNFSprite;

	var upperBoppers:FNFSprite;
	var bottomBoppers:FNFSprite;
	var santa:FNFSprite;

	var bgGirls:BackgroundGirls;
	
	var sky:FNFSprite;
	var city:FNFSprite;
	var cityLights:FNFSprite;
	var clouds:FNFSprite;
	var grass:FNFSprite;
	
	public var jace:FNFSprite;
	public var tyler:FNFSprite;
	public var apple:FNFSprite;
	
	public var congrats:FlxText;
	
	public var nyoomCar:FNFSprite;
	
	public var stage:FNFSprite;
	
	var charTex = Paths.getSparrowAtlas('backgrounds/outside/kadysfriends');
	
	var lightvalue:Int = FlxG.random.int(1, 5);
	var prevlight:Int = 1;
	var carValue:Int = FlxG.random.int(1, 5);
	var nyoomCarCanDrive:Bool = true;

	public var curStage:String;

	var daPixelZoom = PlayState.daPixelZoom;

	public var foreground:FlxTypedGroup<FlxBasic>;

	public function new(curStage)
	{
		super();
		this.curStage = curStage;

		/// get hardcoded stage type if chart is fnf style
		if (PlayState.determinedChartType == "FNF")
		{
			// this is because I want to avoid editing the fnf chart type
			// custom stage stuffs will come with forever charts
			switch (CoolUtil.spaceToDash(PlayState.SONG.song.toLowerCase()))
			{
				case 'spookeez' | 'south' | 'monster':
					curStage = 'spooky';
				case 'pico' | 'blammed' | 'philly-nice':
					curStage = 'philly';
				case 'milf' | 'satin-panties' | 'high':
					curStage = 'highway';
				case 'cocoa' | 'eggnog':
					curStage = 'mall';
				case 'winter-horrorland':
					curStage = 'mallEvil';
				case 'senpai' | 'roses':
					curStage = 'school';
				case 'thorns':
					curStage = 'schoolEvil';
				case 'ganghan' | 'balam' | 'keunsilsu' | 'goyangi':
					curStage = 'outside';
				case 'rivallife':
					curStage = 'outside-day';
				case 'secret':
					curStage = 'gummistage';
				default:
					curStage = 'stage';
			}

			PlayState.curStage = curStage;
		}

		// to apply to foreground use foreground.add(); instead of add();
		foreground = new FlxTypedGroup<FlxBasic>();

		//
		switch (curStage)
		{
			case 'spooky':
				curStage = 'spooky';
				// halloweenLevel = true;

				var hallowTex = Paths.getSparrowAtlas('backgrounds/' + curStage + '/halloween_bg');

				halloweenBG = new FNFSprite(-200, -100);
				halloweenBG.frames = hallowTex;
				halloweenBG.animation.addByPrefix('idle', 'halloweem bg0');
				halloweenBG.animation.addByPrefix('lightning', 'halloweem bg lightning strike', 24, false);
				halloweenBG.animation.play('idle');
				halloweenBG.antialiasing = true;
				add(halloweenBG);

			// isHalloween = true;
			case 'philly':
				curStage = 'philly';

				var bg:FNFSprite = new FNFSprite(-100).loadGraphic(Paths.image('backgrounds/' + curStage + '/sky'));
				bg.scrollFactor.set(0.1, 0.1);
				add(bg);

				var city:FNFSprite = new FNFSprite(-10).loadGraphic(Paths.image('backgrounds/' + curStage + '/city'));
				city.scrollFactor.set(0.3, 0.3);
				city.setGraphicSize(Std.int(city.width * 0.85));
				city.updateHitbox();
				add(city);

				phillyCityLights = new FlxTypedGroup<FNFSprite>();
				add(phillyCityLights);

				for (i in 0...5)
				{
					var light:FNFSprite = new FNFSprite(city.x).loadGraphic(Paths.image('backgrounds/' + curStage + '/win' + i));
					light.scrollFactor.set(0.3, 0.3);
					light.visible = false;
					light.setGraphicSize(Std.int(light.width * 0.85));
					light.updateHitbox();
					light.antialiasing = true;
					phillyCityLights.add(light);
				}

				var streetBehind:FNFSprite = new FNFSprite(-40, 50).loadGraphic(Paths.image('backgrounds/' + curStage + '/behindTrain'));
				add(streetBehind);

				phillyTrain = new FNFSprite(2000, 360).loadGraphic(Paths.image('backgrounds/' + curStage + '/train'));
				add(phillyTrain);

				trainSound = new FlxSound().loadEmbedded(Paths.sound('train_passes'));
				FlxG.sound.list.add(trainSound);

				// var cityLights:FNFSprite = new FNFSprite().loadGraphic(AssetPaths.win0.png);

				var street:FNFSprite = new FNFSprite(-40, streetBehind.y).loadGraphic(Paths.image('backgrounds/' + curStage + '/street'));
				add(street);
			case 'highway':
				curStage = 'highway';
				PlayState.defaultCamZoom = 0.90;

				var skyBG:FNFSprite = new FNFSprite(-120, -50).loadGraphic(Paths.image('backgrounds/' + curStage + '/limoSunset'));
				skyBG.scrollFactor.set(0.1, 0.1);
				add(skyBG);

				var bgLimo:FNFSprite = new FNFSprite(-200, 480);
				bgLimo.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/bgLimo');
				bgLimo.animation.addByPrefix('drive', "background limo pink", 24);
				bgLimo.animation.play('drive');
				bgLimo.scrollFactor.set(0.4, 0.4);
				add(bgLimo);

				grpLimoDancers = new FlxTypedGroup<BackgroundDancer>();
				add(grpLimoDancers);

				for (i in 0...5)
				{
					var dancer:BackgroundDancer = new BackgroundDancer((370 * i) + 130, bgLimo.y - 400);
					dancer.scrollFactor.set(0.4, 0.4);
					grpLimoDancers.add(dancer);
				}

				var overlayShit:FNFSprite = new FNFSprite(-500, -600).loadGraphic(Paths.image('backgrounds/' + curStage + '/limoOverlay'));
				overlayShit.alpha = 0.5;
				// add(overlayShit);

				// var shaderBullshit = new BlendModeEffect(new OverlayShader(), FlxColor.RED);

				// FlxG.camera.setFilters([new ShaderFilter(cast shaderBullshit.shader)]);

				// overlayShit.shader = shaderBullshit;

				var limoTex = Paths.getSparrowAtlas('backgrounds/' + curStage + '/limoDrive');

				limo = new FNFSprite(-120, 550);
				limo.frames = limoTex;
				limo.animation.addByPrefix('drive', "Limo stage", 24);
				limo.animation.play('drive');
				limo.antialiasing = true;

				fastCar = new FNFSprite(-300, 160).loadGraphic(Paths.image('backgrounds/' + curStage + '/fastCarLol'));
			// loadArray.add(limo);
			case 'mall':
				curStage = 'mall';
				PlayState.defaultCamZoom = 0.80;

				var bg:FNFSprite = new FNFSprite(-1000, -500).loadGraphic(Paths.image('backgrounds/' + curStage + '/bgWalls'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.2, 0.2);
				bg.active = false;
				bg.setGraphicSize(Std.int(bg.width * 0.8));
				bg.updateHitbox();
				add(bg);

				upperBoppers = new FNFSprite(-240, -90);
				upperBoppers.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/upperBop');
				upperBoppers.animation.addByPrefix('bop', "Upper Crowd Bob", 24, false);
				upperBoppers.antialiasing = true;
				upperBoppers.scrollFactor.set(0.33, 0.33);
				upperBoppers.setGraphicSize(Std.int(upperBoppers.width * 0.85));
				upperBoppers.updateHitbox();
				add(upperBoppers);

				var bgEscalator:FNFSprite = new FNFSprite(-1100, -600).loadGraphic(Paths.image('backgrounds/' + curStage + '/bgEscalator'));
				bgEscalator.antialiasing = true;
				bgEscalator.scrollFactor.set(0.3, 0.3);
				bgEscalator.active = false;
				bgEscalator.setGraphicSize(Std.int(bgEscalator.width * 0.9));
				bgEscalator.updateHitbox();
				add(bgEscalator);

				var tree:FNFSprite = new FNFSprite(370, -250).loadGraphic(Paths.image('backgrounds/' + curStage + '/christmasTree'));
				tree.antialiasing = true;
				tree.scrollFactor.set(0.40, 0.40);
				add(tree);

				bottomBoppers = new FNFSprite(-300, 140);
				bottomBoppers.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/bottomBop');
				bottomBoppers.animation.addByPrefix('bop', 'Bottom Level Boppers', 24, false);
				bottomBoppers.antialiasing = true;
				bottomBoppers.scrollFactor.set(0.9, 0.9);
				bottomBoppers.setGraphicSize(Std.int(bottomBoppers.width * 1));
				bottomBoppers.updateHitbox();
				add(bottomBoppers);

				var fgSnow:FNFSprite = new FNFSprite(-600, 700).loadGraphic(Paths.image('backgrounds/' + curStage + '/fgSnow'));
				fgSnow.active = false;
				fgSnow.antialiasing = true;
				add(fgSnow);

				santa = new FNFSprite(-840, 150);
				santa.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/santa');
				santa.animation.addByPrefix('idle', 'santa idle in fear', 24, false);
				santa.antialiasing = true;
				add(santa);
			case 'mallEvil':
				curStage = 'mallEvil';
				var bg:FNFSprite = new FNFSprite(-400, -500).loadGraphic(Paths.image('backgrounds/mall/evilBG'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.2, 0.2);
				bg.active = false;
				bg.setGraphicSize(Std.int(bg.width * 0.8));
				bg.updateHitbox();
				add(bg);

				var evilTree:FNFSprite = new FNFSprite(300, -300).loadGraphic(Paths.image('backgrounds/mall/evilTree'));
				evilTree.antialiasing = true;
				evilTree.scrollFactor.set(0.2, 0.2);
				add(evilTree);

				var evilSnow:FNFSprite = new FNFSprite(-200, 700).loadGraphic(Paths.image("backgrounds/mall/evilSnow"));
				evilSnow.antialiasing = true;
				add(evilSnow);
			case 'school':
				curStage = 'school';

				// defaultCamZoom = 0.9;

				var bgSky = new FNFSprite().loadGraphic(Paths.image('backgrounds/' + curStage + '/weebSky'));
				bgSky.scrollFactor.set(0.1, 0.1);
				add(bgSky);

				var repositionShit = -200;

				var bgSchool:FNFSprite = new FNFSprite(repositionShit, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/weebSchool'));
				bgSchool.scrollFactor.set(0.6, 0.90);
				add(bgSchool);

				var bgStreet:FNFSprite = new FNFSprite(repositionShit).loadGraphic(Paths.image('backgrounds/' + curStage + '/weebStreet'));
				bgStreet.scrollFactor.set(0.95, 0.95);
				add(bgStreet);

				var fgTrees:FNFSprite = new FNFSprite(repositionShit + 170, 130).loadGraphic(Paths.image('backgrounds/' + curStage + '/weebTreesBack'));
				fgTrees.scrollFactor.set(0.9, 0.9);
				add(fgTrees);

				var bgTrees:FNFSprite = new FNFSprite(repositionShit - 380, -800);
				var treetex = Paths.getPackerAtlas('backgrounds/' + curStage + '/weebTrees');
				bgTrees.frames = treetex;
				bgTrees.animation.add('treeLoop', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18], 12);
				bgTrees.animation.play('treeLoop');
				bgTrees.scrollFactor.set(0.85, 0.85);
				add(bgTrees);

				var treeLeaves:FNFSprite = new FNFSprite(repositionShit, -40);
				treeLeaves.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/petals');
				treeLeaves.animation.addByPrefix('leaves', 'PETALS ALL', 24, true);
				treeLeaves.animation.play('leaves');
				treeLeaves.scrollFactor.set(0.85, 0.85);
				add(treeLeaves);

				var widShit = Std.int(bgSky.width * 6);

				bgSky.setGraphicSize(widShit);
				bgSchool.setGraphicSize(widShit);
				bgStreet.setGraphicSize(widShit);
				bgTrees.setGraphicSize(Std.int(widShit * 1.4));
				fgTrees.setGraphicSize(Std.int(widShit * 0.8));
				treeLeaves.setGraphicSize(widShit);

				fgTrees.updateHitbox();
				bgSky.updateHitbox();
				bgSchool.updateHitbox();
				bgStreet.updateHitbox();
				bgTrees.updateHitbox();
				treeLeaves.updateHitbox();

				bgGirls = new BackgroundGirls(-100, 190);
				bgGirls.scrollFactor.set(0.9, 0.9);

				if (PlayState.SONG.song.toLowerCase() == 'roses')
					bgGirls.getScared();

				bgGirls.setGraphicSize(Std.int(bgGirls.width * daPixelZoom));
				bgGirls.updateHitbox();
				add(bgGirls);
			case 'schoolEvil':
				var posX = 400;
				var posY = 200;
				var bg:FNFSprite = new FNFSprite(posX, posY);
				bg.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/animatedEvilSchool');
				bg.animation.addByPrefix('idle', 'background 2', 24);
				bg.animation.play('idle');
				bg.scrollFactor.set(0.8, 0.9);
				bg.scale.set(6, 6);
				add(bg);
				
			case 'outside':
				curStage = 'outside';
				PlayState.defaultCamZoom = 0.9;
				
				if (PlayState.SONG.song.toLowerCase() == 'goyangi')
				{
					sky = new FNFSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/nightsky-sunset'));
					sky.setGraphicSize(Std.int(sky.width * 1.2));
					sky.scrollFactor.set();
					add(sky);
				}
				else
				{
					sky = new FNFSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/nightsky'));
					sky.setGraphicSize(Std.int(sky.width * 1.2));
					sky.scrollFactor.set();
					add(sky);
				}
				
				city = new FNFSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/cityscape'));
				city.setGraphicSize(Std.int(city.width * 1.2));
				city.scrollFactor.set(0.4, 0.4);
				add(city);
				
				//cool philly lights as seen in week 3, except forEach can suck my di-
				cityLights = new FNFSprite(0, 0);
				cityLights.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/citylights');
				cityLights.setGraphicSize(Std.int(cityLights.width * 1.2));
				cityLights.animation.addByPrefix('light1', 'lights10', 24, false);
				cityLights.animation.addByPrefix('light2', 'lights20', 24, false);
				cityLights.animation.addByPrefix('light3', 'lights30', 24, false);
				cityLights.animation.addByPrefix('light4', 'lights40', 24, false);
				cityLights.animation.addByPrefix('light5', 'lights50', 24, false);
				cityLights.animation.play('light' + lightvalue);
				cityLights.scrollFactor.set(0.4, 0.4);
				add(cityLights);

				//i am smrt
				if (PlayState.SONG.song.toLowerCase() == 'balam')
				{
					clouds = new FNFSprite(-50, -180).loadGraphic(Paths.image('backgrounds/' + curStage + '/moonclouds-dark'));
					clouds.setGraphicSize(Std.int(clouds.width * 1.5));
					clouds.scrollFactor.set(1.2, 1);
					add(clouds);
				
					grass = new FNFSprite(10, 80);
					grass.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/grassgotouch-windy');
					grass.animation.addByPrefix('idle', 'stage0', 24);
					grass.animation.play('idle');
					grass.setGraphicSize(Std.int(grass.width * 1.6));
					grass.scrollFactor.set(1, 1);
					add(grass);
					
					jace = new FNFSprite(-400, 220);
					jace.frames = charTex;
					jace.animation.addByPrefix('idle', 'Idle Blow Jace', 24, false);
					jace.animation.play('idle');
					add(jace);
					
					tyler = new FNFSprite(-120, 240);
					tyler.frames = charTex;
					tyler.animation.addByPrefix('idle', 'Idle Blow Tyler', 24, false);
					tyler.animation.play('idle');
					add(tyler);
					
					apple = new FNFSprite(-250, 360);
					apple.frames = charTex;
					apple.animation.addByPrefix('idle', 'Idle Blow Apple', 24, false);
					apple.animation.play('idle');
					add(apple);
				}
				else
				{
					clouds = new FNFSprite(-110, 120).loadGraphic(Paths.image('backgrounds/' + curStage + '/moonclouds'));
					clouds.setGraphicSize(Std.int(clouds.width * 1.5));
					clouds.scrollFactor.set(1.2, 1);
					add(clouds);
					
					grass = new FNFSprite(10, 80).loadGraphic(Paths.image('backgrounds/' + curStage + '/grassgotouch'));
					grass.setGraphicSize(Std.int(grass.width * 1.6));
					grass.scrollFactor.set(1, 1);
					add(grass);
				
					if (PlayState.SONG.song.toLowerCase() == 'keunsilsu')
					{
						jace = new FNFSprite(-400, 220);
						jace.frames = charTex;
						jace.animation.addByPrefix('idle', 'Idle Worried Jace', 24, false);
						jace.animation.play('idle');
						add(jace);
						
						tyler = new FNFSprite(-120, 240);
						tyler.frames = charTex;
						tyler.animation.addByPrefix('idle', 'Idle Tyler', 24, false);
						tyler.animation.play('idle');
						add(tyler);
						
						apple = new FNFSprite(-250, 360);
						apple.frames = charTex;
						apple.animation.addByPrefix('idle', 'Idle Worried Apple', 24, false);
						apple.animation.play('idle');
						add(apple);
					}
					else
					{
						jace = new FNFSprite(-400, 220);
						jace.frames = charTex;
						jace.animation.addByPrefix('idle', 'Idle Jace', 24, false);
						jace.animation.play('idle');
						add(jace);
					
						tyler = new FNFSprite(-120, 240);
						tyler.frames = charTex;
						tyler.animation.addByPrefix('idle', 'Idle Tyler', 24, false);
						tyler.animation.play('idle');
						add(tyler);
						
						apple = new FNFSprite(-250, 360);
						apple.frames = charTex;
						apple.animation.addByPrefix('idle', 'Idle Apple', 24, false);
						apple.animation.play('idle');
						add(apple);
					}
					
					
				}
				
				nyoomCar = new FNFSprite( 12600, 400);
				nyoomCar.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/cars');
				nyoomCar.animation.addByPrefix('car1', 'car1', 24, false);
				nyoomCar.animation.addByPrefix('car2', 'car2', 24, false);
				nyoomCar.animation.addByPrefix('car3', 'car3', 24, false);
				nyoomCar.animation.addByPrefix('car4', 'car4', 24, false);
				nyoomCar.animation.addByPrefix('car5', 'car5', 24, false);
				nyoomCar.setGraphicSize(Std.int(nyoomCar.width * 1.5));
				nyoomCar.scrollFactor.set(1, 1);
				foreground.add(nyoomCar);
				nyoomCar.animation.play('car' + carValue);
				
			case 'outside-day':
				curStage = 'outside-day';
				PlayState.defaultCamZoom = 0.9;
				
				sky = new FNFSprite(0, 0).loadGraphic(Paths.image('backgrounds/outside/day/daysky'));
				sky.setGraphicSize(Std.int(sky.width * 1.2));
				sky.scrollFactor.set();
				add(sky);
				
				city = new FNFSprite(0, 0).loadGraphic(Paths.image('backgrounds/outside/day/cityscape'));
				city.setGraphicSize(Std.int(city.width * 1.2));
				city.scrollFactor.set(0.4, 0.4);
				add(city);
				
				cityLights = new FNFSprite(0, 0).loadGraphic(Paths.image('backgrounds/outside/day/citylight'));
				cityLights.setGraphicSize(Std.int(cityLights.width * 1.2));
				cityLights.scrollFactor.set(0.4, 0.4);
				add(cityLights);
				
				clouds = new FNFSprite(-110, 120).loadGraphic(Paths.image('backgrounds/outside/day/sunclouds'));
				clouds.setGraphicSize(Std.int(clouds.width * 1.5));
				clouds.scrollFactor.set(1.2, 1);
				add(clouds);
				
				grass = new FNFSprite(10, 80).loadGraphic(Paths.image('backgrounds/outside/day/grassgotouch'));
				grass.setGraphicSize(Std.int(grass.width * 1.6));
				grass.scrollFactor.set(1, 1);
				add(grass);
				
				nyoomCar = new FNFSprite( 12600, 400);
				nyoomCar.frames = Paths.getSparrowAtlas('backgrounds/outside/cars');
				nyoomCar.animation.addByPrefix('car1', 'car1', 24, false);
				nyoomCar.animation.addByPrefix('car2', 'car2', 24, false);
				nyoomCar.animation.addByPrefix('car3', 'car3', 24, false);
				nyoomCar.animation.addByPrefix('car4', 'car4', 24, false);
				nyoomCar.animation.addByPrefix('car5', 'car5', 24, false);
				nyoomCar.setGraphicSize(Std.int(nyoomCar.width * 1.5));
				nyoomCar.scrollFactor.set(1, 1);
				foreground.add(nyoomCar);
				nyoomCar.animation.play('car' + carValue);
				
			case 'gummistage':
				curStage = 'gummistage';
				PlayState.defaultCamZoom = 0.9;

				var sky:FNFSprite = new FNFSprite(0, -800).loadGraphic(Paths.image('backgrounds/' + curStage + '/sky'));
				sky.screenCenter(X);
				sky.setGraphicSize(Std.int(sky.width * 1.2));
				sky.scrollFactor.set(0.25, 0.25);
				add(sky);
				
				stage = new FNFSprite(-999, 596).loadGraphic(Paths.image('backgrounds/' + curStage + '/stage'));
				stage.scrollFactor.set(1, 1);
				add(stage);
				
				congrats = new FlxText(750, 0, 0, "CONGRATULATIONS!", 48);
				congrats.color = 0xFFFFD886;
				congrats.borderStyle = FlxTextBorderStyle.OUTLINE;
				congrats.borderColor = 0xFF965C3A;
				congrats.borderSize = 2;
				congrats.screenCenter(Y);
				foreground.add(congrats);
				
			default:
				PlayState.defaultCamZoom = 0.9;
				curStage = 'stage';
				var bg:FNFSprite = new FNFSprite(-600, -200).loadGraphic(Paths.image('backgrounds/' + curStage + '/stageback'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;

				// add to the final array
				add(bg);

				var stageFront:FNFSprite = new FNFSprite(-650, 600).loadGraphic(Paths.image('backgrounds/' + curStage + '/stagefront'));
				stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
				stageFront.updateHitbox();
				stageFront.antialiasing = true;
				stageFront.scrollFactor.set(0.9, 0.9);
				stageFront.active = false;

				// add to the final array
				add(stageFront);

				var stageCurtains:FNFSprite = new FNFSprite(-500, -300).loadGraphic(Paths.image('backgrounds/' + curStage + '/stagecurtains'));
				stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
				stageCurtains.updateHitbox();
				stageCurtains.antialiasing = true;
				stageCurtains.scrollFactor.set(1.3, 1.3);
				stageCurtains.active = false;

				// add to the final array
				add(stageCurtains);
		}
	}

	// return the girlfriend's type
	public function returnGFtype(curStage)
	{
		var gfVersion:String = 'gf';

		switch (curStage)
		{
			case 'highway':
				gfVersion = 'gf-car';
			case 'mall' | 'mallEvil':
				gfVersion = 'gf-christmas';
			case 'school':
				gfVersion = 'gf-pixel';
			case 'schoolEvil':
				gfVersion = 'gf-pixel';
			case 'outside':
				if (PlayState.SONG.song.toLowerCase() == 'balam')
					gfVersion = 'gf-kadyhair';
				else
					gfVersion = 'gf-kady';
			case 'outside-day' | 'gummistage':
				gfVersion = 'gf-boombox';
		}

		return gfVersion;
	}

	// get the dad's position
	public function dadPosition(curStage, boyfriend:Character, dad:Character, gf:Character, camPos:FlxPoint):Void
	{
		var characterArray:Array<Character> = [dad, boyfriend];
		for (char in characterArray) {
			switch (char.curCharacter)
			{
				case 'gf':
					char.setPosition(gf.x, gf.y);
					gf.visible = false;
				/*
					if (isStoryMode)
					{
						camPos.x += 600;
						tweenCamIn();
				}*/
				/*
				case 'spirit':
					var evilTrail = new FlxTrail(char, null, 4, 24, 0.3, 0.069);
					evilTrail.changeValuesEnabled(false, false, false, false);
					add(evilTrail);
					*/
			}
		}
	}

	public function repositionPlayers(curStage, boyfriend:Character, dad:Character, gf:Character):Void
	{
		// REPOSITIONING PER STAGE
		switch (curStage)
		{
			case 'highway':
				boyfriend.y -= 220;
				boyfriend.x += 260;

			case 'mall':
				boyfriend.x += 200;
				dad.x -= 400;
				dad.y += 20;

			case 'mallEvil':
				boyfriend.x += 320;
			case 'school':
				boyfriend.x += 200;
				boyfriend.y += 220;
				dad.x += 200;
				dad.y += 580;
				gf.x += 200;
				gf.y += 320;
			case 'schoolEvil':
				dad.x -= 150;
				dad.y += 50;
				boyfriend.x += 200;
				boyfriend.y += 220;
				gf.x += 180;
				gf.y += 300;
			case 'outside':
				boyfriend.x += 50;
				gf.y += 200;
			case 'outside-day':
				gf.y += 525;
			case 'gummistage':
				boyfriend.screenCenter(X);
				gf.x += 400;
				gf.y += 525;
		}
	}

	var curLight:Int = 0;
	var trainMoving:Bool = false;
	var trainFrameTiming:Float = 0;

	var trainCars:Int = 8;
	var trainFinishing:Bool = false;
	var trainCooldown:Int = 0;
	var startedMoving:Bool = false;
	
	var mm:Int = 1;

	public function stageUpdate(curBeat:Int, boyfriend:Boyfriend, gf:Character, dadOpponent:Character)
	{
		// trace('update backgrounds');
		switch (PlayState.curStage)
		{
			case 'highway':
				// trace('highway update');
				grpLimoDancers.forEach(function(dancer:BackgroundDancer)
				{
					dancer.dance();
				});
			case 'mall':
				upperBoppers.animation.play('bop', true);
				bottomBoppers.animation.play('bop', true);
				santa.animation.play('idle', true);

			case 'school':
				bgGirls.dance();

			case 'philly':
				if (!trainMoving)
					trainCooldown += 1;

				if (curBeat % 4 == 0)
				{
					var lastLight:FlxSprite = phillyCityLights.members[0];

					phillyCityLights.forEach(function(light:FNFSprite)
					{
						// Take note of the previous light
						if (light.visible == true)
							lastLight = light;

						light.visible = false;
					});

					// To prevent duplicate lights, iterate until you get a matching light
					while (lastLight == phillyCityLights.members[curLight])
					{
						curLight = FlxG.random.int(0, phillyCityLights.length - 1);
					}

					phillyCityLights.members[curLight].visible = true;
					phillyCityLights.members[curLight].alpha = 1;

					FlxTween.tween(phillyCityLights.members[curLight], {alpha: 0}, Conductor.stepCrochet * .016);
				}

				if (curBeat % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 8)
				{
					trainCooldown = FlxG.random.int(-4, 0);
					trainStart();
				}
			case 'outside':
				if (curBeat % 1 == 0)
				{
					jace.animation.play('idle');
					tyler.animation.play('idle');
					apple.animation.play('idle');
				}
				
				if (FlxG.random.bool(10) && nyoomCarCanDrive)
					nyoomCarDrive();
				
				//light shit
				if (curBeat % 4 == 0)
				{
					prevlight = lightvalue;
					
					//the old way was just terrible and i never want yall to see how that worked
					while (prevlight == lightvalue)
					{
						lightvalue = FlxG.random.int(1, 5);
					}
					
					//trace('Light Value: ' + lightvalue + ', Last Light: ' + prevlight);
						
					cityLights.animation.play('light' + lightvalue);
				}
				
			case 'outside-day':
				if (FlxG.random.bool(10) && nyoomCarCanDrive)
					nyoomCarDrive();
		}
	}

	public function stageUpdateConstant(elapsed:Float, boyfriend:Boyfriend, gf:Character, dadOpponent:Character)
	{
		switch (PlayState.curStage)
		{
			case 'philly':
				if (trainMoving)
				{
					trainFrameTiming += elapsed;

					if (trainFrameTiming >= 1 / 24)
					{
						updateTrainPos(gf);
						trainFrameTiming = 0;
					}
				}
		}
	}
	
	function resetNyoomCar():Void
	{
		nyoomCar.x = 12600;
		nyoomCar.y = FlxG.random.int(380, 420);
		nyoomCar.velocity.x = 0;
		carValue = FlxG.random.int(1, 5);
		nyoomCar.animation.play('car' + carValue);
		nyoomCarCanDrive = true;
		
	}
	
	function nyoomCarDrive()
	{
		FlxG.sound.play(Paths.soundRandom('carPass', 0, 1), 0.7);

		nyoomCar.velocity.x = -(FlxG.random.int(240, 320) / FlxG.elapsed) * 3;
		//trace("NYOOOOOOOOOOOOOOOOOM");
		nyoomCarCanDrive = false;
		new FlxTimer().start(2, function(tmr:FlxTimer)
		{
			resetNyoomCar();
		});
	}

	// PHILLY STUFFS!
	function trainStart():Void
	{
		trainMoving = true;
		if (!trainSound.playing)
			trainSound.play(true);
	}

	function updateTrainPos(gf:Character):Void
	{
		if (trainSound.time >= 4700)
		{
			startedMoving = true;
			gf.playAnim('hairBlow');
		}

		if (startedMoving)
		{
			phillyTrain.x -= 400;

			if (phillyTrain.x < -2000 && !trainFinishing)
			{
				phillyTrain.x = -1150;
				trainCars -= 1;

				if (trainCars <= 0)
					trainFinishing = true;
			}

			if (phillyTrain.x < -4000 && trainFinishing)
				trainReset(gf);
		}
	}

	function trainReset(gf:Character):Void
	{
		gf.playAnim('hairFall');
		phillyTrain.x = FlxG.width + 200;
		trainMoving = false;
		// trainSound.stop();
		// trainSound.time = 0;
		trainCars = 8;
		trainFinishing = false;
		startedMoving = false;
	}

	override function add(Object:FlxBasic):FlxBasic
	{
		if (Init.trueSettings.get('Disable Antialiasing') && Std.isOfType(Object, FlxSprite))
			cast(Object, FlxSprite).antialiasing = false;
		return super.add(Object);
	}
}
