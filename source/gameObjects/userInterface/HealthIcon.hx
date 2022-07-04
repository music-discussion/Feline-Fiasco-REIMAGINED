package gameObjects.userInterface;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.FlxGraphic;
import sys.FileSystem;

using StringTools;

class HealthIcon extends FlxSprite
{
	// rewrite using da new icon system as ninjamuffin would say it
	public var sprTracker:FlxSprite;
	public var initialWidth:Float = 0;
	public var initialHeight:Float = 0;

	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		super();
		updateIcon(char, isPlayer);
	}

	public function updateIcon(char:String = 'bf', isPlayer:Bool = false)
	{
		var trimmedCharacter:String = char;
		if (trimmedCharacter.contains('-'))
			trimmedCharacter = trimmedCharacter.substring(0, trimmedCharacter.indexOf('-'));
		
		var iconPath = char;
		
		//manually changing the icons because damn
		if (char == 'bf-kadyhair')
			iconPath = 'bf-kady';
			
		if (char == 'kady-hairblow')
			iconPath = 'kady';
		
		while (!FileSystem.exists(Paths.getPath('images/icons/icon-' + iconPath + '.png', IMAGE))) {
			if (iconPath != trimmedCharacter)
				iconPath = trimmedCharacter;
			else
				iconPath = 'face';
			trace('$char icon trying $iconPath instead you fuck');
		}

		antialiasing = true;
		var iconGraphic:FlxGraphic = Paths.image('icons/icon-' + iconPath);
		loadGraphic(iconGraphic, true, 150, 150);

		initialWidth = width;
		initialHeight = height;
		
		if (iconPath == 'bf-kady' || iconPath == 'bf-tucker')
			animation.add('icon', [0, 1, 2], 0, false, isPlayer);
		else
			animation.add('icon', [0, 1], 0, false, isPlayer);
		animation.play('icon');
		scrollFactor.set();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}
}
