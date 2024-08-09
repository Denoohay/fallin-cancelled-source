package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;
import Achievements;
import flixel.input.keyboard.FlxKey;
import flixel.util.FlxTimer;

using StringTools;

class Background1SkinState extends MusicBeatSubstate
{
	var curSelected:Int;

	var playHoverSound:Bool;
	var ablePressButton:Bool;

	public static var firstOpening:Bool = false;

	public static var previewingBackgrounds:Bool;
	public static var curBackground:String;

	private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;

	public static var bg1Button:FlxSprite;
	public static var bg2Button:FlxSprite;
	public static var selectBackground:FlxSprite;

	public static var hoverBox:FlxSprite;
	public static var selectedBox:FlxSprite;

	public static var titleText:FlxText;
	public static var seasonText:FlxText;
	public static var descText:FlxText;

	public static var skinIcon:FlxSprite;
	public static var skinIconGroup:FlxTypedGroup<FlxSprite>;
	public static var skinLocked:FlxSprite;
	public static var skinLockedGroup:FlxTypedGroup<FlxSprite>;

	public static var cursor:FlxSprite;

	var camFollow:FlxObject;
	var camFollowPos:FlxObject;
	var debugKeys:Array<FlxKey>;

	var skinStatus:Array<Int> =
	[
		FlxG.save.data.background_default,
		FlxG.save.data.background_defaultBlue,
		FlxG.save.data.background_fire,
		FlxG.save.data.background_flower,
		FlxG.save.data.background_charge,
		FlxG.save.data.background_garden,
		FlxG.save.data.background_rain,
		FlxG.save.data.background_cherry,
		FlxG.save.data.background_cyber,
		FlxG.save.data.background_gold,
		FlxG.save.data.background_fireworks,
		FlxG.save.data.background_lovey,
		FlxG.save.data.background_shamrock,
		FlxG.save.data.background_pastel,
		FlxG.save.data.background_bombPop,
		FlxG.save.data.background_trifecta,
		FlxG.save.data.background_birthday,
		FlxG.save.data.background_winner,
		FlxG.save.data.background_spooky,
		FlxG.save.data.background_merry
	];

	var skinList:Array<String> =
	[
		'default',
		'defaultBlue',
		'fire',
		'flower',
		'charge',
		'garden',
		'rain',
		'cherry',
		'cyber',
		'gold',
		'fireworks',
		'lovey',
		'shamrock',
		'pastel',
		'bombPop',
		'trifecta',
		'birthday',
		'winner',
		'spooky',
		'merry'
	];

	var skinTitle:Array<String> =
	[
		'Season One',
		'Cool Blue',
		'Heated',
		'Flower Field',
		'Charged Up',
		'Garden',
		'Rainy Day',
		'Cherry',
		'Cyber Signal',
		'Citrine',
		'Fireworks',
		'Lovey',
		'Shamrock',
		'Pastel',
		'Bomb Pop',
		'Trifecta',
		'Birthday',
		'Winner',
		'Spooky',
		'Merry'
	];

	var skinSeason:Array<String> =
	[
		'1',
		'1',
		'1',
		'1',
		'1',
		'1',
		'1',
		'1',
		'1',
		'1',
		'1',
		'1',
		'1',
		'1',
		'1',
		'1',
		'1',
		'1',
		'1',
		'1'
	];

	var skinDesc:Array<String> =
	[
		'The original.',
		'Classic blue.',
		'This is fire.',
		'roses are pinurple.',
		'Bzzzzzzz!',
		'of what?',
		'peaceful rainy day [chill lo-fi hip hop beats]',
		'red',
		'omg just like beanbot from fnf',
		'Superstar!',
		'(fnf neo background???)',
		'<3',
		'Grants +200% Luck.',
		'You better paint an egg.',
		"Lime, cherry, and blue raspberry.",
		"Friday Night Fallin'",
		'HAPPY BIRTHDAY DEAR fridanitfallinnnnnnnnnn',
		'Fall Guys',
		'OOGA BOOGA! HA HA HA!',
		'merry fallguysmas'
	];

	var skinLockedText:Array<String> =
	[
		'ERROR',
		'ERROR',
		'Buy from the shop.',
		'Buy from the shop.',
		'Buy from the shop.',
		'Buy from the shop.',
		'Buy from the shop.',
		'Buy from the shop.',
		'Buy from the shop.',
		'Earn a Gold Medal on every song in Season 1.',
		'Play any day from December 31st to January 2nd.',
		'Play on Feburary 14th.',
		'Play on March 17th.',
		'Play any day from March 25th to April 25.',
		'Play any day from July 3rd to 5th.',
		'Play on [when ever the mod releases].',
		'Play on July 10th.',
		'Play on August 4th.',
		'Play any day from October 29th to 31st.',
		'Play any day from December 24th to 26th.'
	];

	override function create()
	{
		WeekData.loadTheFirstEnabledMod();

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Skins Menu", null);
		#end

		camGame = new FlxCamera();
		camAchievement = new FlxCamera();
		camAchievement.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camAchievement);
		FlxCamera.defaultCameras = [camGame];

		persistentUpdate = persistentDraw = true;

		camFollow = new FlxObject(0, 0, 1, 1);
		camFollowPos = new FlxObject(0, 0, 1, 1);
		add(camFollow);
		add(camFollowPos);
		
		if (firstOpening == false)
		{
			BackgroundState.bgPatternGroup.forEach(function(spr:FlxSprite)
			{
				spr.loadGraphic(Paths.image('fallmen/UI/Menu/Skins/Patterns/' + FlxG.save.data.backgroundTheme));
			});
			BackgroundState.backgroundTheme = FlxG.save.data.backgroundTheme;

			BackgroundState.showBackground();
			firstOpening == true;
		}

		previewingBackgrounds = true;

		cursor = new FlxSprite(0, 0).loadGraphic(Paths.image('fallmen/UI/cursor'));
		cursor.updateHitbox();
		cursor.antialiasing = ClientPrefs.globalAntialiasing;
		
		bg1Button = new FlxSprite(368, 621).loadGraphic(Paths.image('fallmen/UI/Menu/Skins/Menus/Interface/Background/bg1ButtonSel'));
		bg1Button.scrollFactor.set();
		bg1Button.updateHitbox();
		bg1Button.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg1Button);

		bg2Button = new FlxSprite(644, 621).loadGraphic(Paths.image('fallmen/UI/Menu/Skins/Menus/Interface/Background/bg2Button'));
		bg2Button.scrollFactor.set();
		bg2Button.updateHitbox();
		bg2Button.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg2Button);

		selectBackground = new FlxSprite(15, 28).loadGraphic(Paths.image('fallmen/UI/Menu/Skins/Menus/Interface/Background/background'));
		selectBackground.scrollFactor.set();
		selectBackground.updateHitbox();
		selectBackground.antialiasing = ClientPrefs.globalAntialiasing;
		add(selectBackground);

		hoverBox = new FlxSprite();
		hoverBox.loadGraphic(Paths.image('fallmen/UI/Menu/Skins/Menus/boxHover'));
		hoverBox.scrollFactor.set();
		hoverBox.alpha = 0;
		hoverBox.updateHitbox();
		hoverBox.antialiasing = ClientPrefs.globalAntialiasing;
		add(hoverBox);

		selectedBox = new FlxSprite();
		selectedBox.loadGraphic(Paths.image('fallmen/UI/Menu/Skins/Menus/boxSelect'));
		selectedBox.scrollFactor.set();
		selectedBox.updateHitbox();
		selectedBox.antialiasing = ClientPrefs.globalAntialiasing;
		add(selectedBox);

		skinIconGroup = new FlxTypedGroup<FlxSprite>();
		add(skinIconGroup);

		skinLockedGroup = new FlxTypedGroup<FlxSprite>();
		add(skinLockedGroup);
		
		var currentX:Float = 48;
		var currentY:Float = 53;
		for (i in 0...skinList.length)
		{
			if (i == 0)
			{
				skinIcon = new FlxSprite(48, 53);
			}
			else
			{
				currentX = currentX + 138;
				skinIcon = new FlxSprite(currentX, currentY);
			}

			if (i == 2 || i == 4 || i == 6 || i == 8)
			{
				currentY = currentY + 127;
				currentX = 48;
				skinIcon = new FlxSprite(currentX, currentY);
			}
			else if (i == 10)
			{
				currentY = 53;
				currentX = 982;
				skinIcon = new FlxSprite(currentX, currentY);
			}
			else if (i == 12 || i == 14 || i == 16 || i == 18)
			{
				currentY = currentY + 127;
				currentX = 982;
				skinIcon = new FlxSprite(currentX, currentY);
			}
			skinIcon.makeGraphic(FlxG.width, FlxG.height, FlxColor.TRANSPARENT);
			skinIcon.scrollFactor.x = 0;
			skinIcon.scrollFactor.y = 0;
			skinIcon.loadGraphic(Paths.image('fallmen/UI/Menu/Skins/Icons/Background/' + skinList[i]));
			skinIcon.antialiasing = ClientPrefs.globalAntialiasing;
			skinIconGroup.add(skinIcon);

			if (SkinsSelState.devSkinMode == false)
			{
				if (skinStatus[i] == 0)
				{
					skinIcon.color = 0xFF000000;
					skinLocked = new FlxSprite(currentX, currentY);
					skinLocked.makeGraphic(FlxG.width, FlxG.height, FlxColor.TRANSPARENT);
					skinLocked.scrollFactor.x = 0;
					skinLocked.scrollFactor.y = 0;
					skinLocked.loadGraphic(Paths.image('fallmen/UI/Menu/Skins/Menus/lockedBox'));
					skinLocked.antialiasing = ClientPrefs.globalAntialiasing;
					skinLockedGroup.add(skinLocked);
				}
			}

			//trace(i + ' x:' + currentX + ', y:' + currentY);
		}

		titleText = new FlxText(0, 110, 350, "");
		titleText.scrollFactor.set();
		titleText.setFormat(Paths.font("fall.ttf"), 43, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE);
		titleText.borderSize = 3;
		titleText.borderColor = 0xFFFF00A4;
		titleText.screenCenter(X);
		titleText.antialiasing = ClientPrefs.globalAntialiasing;
		add(titleText);

		seasonText = new FlxText(0, 163, 350, "");
		seasonText.scrollFactor.set();
		seasonText.setFormat(Paths.font("fall.ttf"), 15, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE);
		seasonText.borderSize = 1.5;
		seasonText.borderColor = 0xFFFF00A4;
		seasonText.screenCenter(X);
		seasonText.antialiasing = ClientPrefs.globalAntialiasing;
		add(seasonText);

		descText = new FlxText(0, 183, 350, "");
		descText.scrollFactor.set();
		descText.setFormat(Paths.font("phantom.ttf"), 20, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE);
		descText.borderSize = 1.5;
		descText.borderColor = 0xFFFF00A4;
		descText.screenCenter(X);
		descText.antialiasing = ClientPrefs.globalAntialiasing;
		add(descText);
		
		for (i in 0...skinList.length)
		{
			if (FlxG.save.data.backgroundTheme == skinList[i])
			{
				curSelected = i;
			}
			else
			{
				curSelected = -1;
			}
		}

		super.create();
	}

	public static function menuTrans(INorOUT)
	{
		if (ClientPrefs.menuTrans)
		{
			BackgroundState.transitioning = true;

			if (INorOUT == 0)
			{
				BackgroundState.transitioning = false;
				FlxG.mouse.visible = true;
				FlxG.mouse.load(cursor.pixels);
			}
			else
			{
				FlxTween.tween(bg1Button, {x: bg1Button.x - 1280}, 2, {ease: FlxEase.quadInOut, type: FlxTweenType.ONESHOT});
				
				FlxTween.tween(bg2Button, {x: bg2Button.x - 1280}, 2, {ease: FlxEase.quadInOut, type: FlxTweenType.ONESHOT});
				
				FlxTween.tween(selectBackground, {x: selectBackground.x - 1280}, 2, {ease: FlxEase.quadInOut, type: FlxTweenType.ONESHOT});
				
				FlxTween.tween(hoverBox, {x: hoverBox.x - 1280}, 2, {ease: FlxEase.quadInOut, type: FlxTweenType.ONESHOT});
				
				FlxTween.tween(selectedBox, {x: selectedBox.x - 1280}, 2, {ease: FlxEase.quadInOut, type: FlxTweenType.ONESHOT});
				
				skinIconGroup.forEach(function(spr:FlxSprite)
				{
					FlxTween.tween(spr, {x: spr.x - 1280}, 2, {ease: FlxEase.quadInOut, type: FlxTweenType.ONESHOT});
				});
				
				skinLockedGroup.forEach(function(spr:FlxSprite)
				{
					FlxTween.tween(spr, {x: spr.x - 1280}, 2, {ease: FlxEase.quadInOut, type: FlxTweenType.ONESHOT});
				});
				
				FlxTween.tween(titleText, {x: titleText.x - 1280}, 2, {ease: FlxEase.quadInOut, type: FlxTweenType.ONESHOT});
				
				FlxTween.tween(seasonText, {x: seasonText.x - 1280}, 2, {ease: FlxEase.quadInOut, type: FlxTweenType.ONESHOT});
				
				FlxTween.tween(descText, {x: descText.x - 1280}, 2, {ease: FlxEase.quadInOut, type: FlxTweenType.ONESHOT});

				FlxG.mouse.visible = false;
			}
		}
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.keys.justPressed.F)
		{
			FlxG.fullscreen = !FlxG.fullscreen;
		}

		var lerpVal:Float = CoolUtil.boundTo(elapsed * 7.5, 0, 1);
		camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));
		
		for (i in 0...skinList.length)
		{
			if(selectedBox.x == 0)
			{
				if (FlxG.save.data.backgroundTheme == "default")
				{
					selectedBox.x = skinIconGroup.members[0].x - 7;
					selectedBox.y = skinIconGroup.members[0].y - 7;
					selectedBox.alpha = 1;
				}
				else if (FlxG.save.data.backgroundTheme == skinList[i])
				{
					selectedBox.x = skinIconGroup.members[i].x - 7;
					selectedBox.y = skinIconGroup.members[i].y - 7;
					selectedBox.alpha = 1;
				}
			}

			if(titleText.text == "")
			{
				if (FlxG.save.data.backgroundTheme == skinList[i])
				{
					titleText.text = skinTitle[i].toUpperCase();
					seasonText.text = "SEASON " + skinSeason[i].toUpperCase();
					descText.text = skinDesc[i];
				}
			}
		}

		if (!selectedSomethin && BackgroundState.transitioning == false)
		{
			for (i in 0...skinList.length)
			{
				if (FlxG.mouse.overlaps(skinIconGroup.members[i]))
				{					
					hoverBox.x = skinIconGroup.members[i].x - 7;
					hoverBox.y = skinIconGroup.members[i].y - 7;
					hoverBox.alpha = 1;

					curSelected = i;
					
					if (SkinsSelState.devSkinMode == false)
					{
						if (skinStatus[i] == 1)
						{
							titleText.text = skinTitle[i].toUpperCase();
							seasonText.text = "SEASON " + skinSeason[i].toUpperCase();
							descText.text = skinDesc[i];
						}
						else
						{
							titleText.text = "???";
							seasonText.text = "SEASON " + skinSeason[i].toUpperCase();
							descText.text = "HOW TO UNLOCK:\n" + skinLockedText[i];
						}
					}
					else
					{
						titleText.text = skinTitle[i].toUpperCase();
						seasonText.text = "SEASON " + skinSeason[i].toUpperCase();
						descText.text = skinDesc[i];
					}

					if (SkinsSelState.devSkinMode == false)
					{
						if (skinStatus[curSelected] == 1)
						{
							curBackground = skinList[i];
						}
						else
						{
							curBackground = "locked";
						}
					}
					else
					{
						curBackground = skinList[i];
					}

					BackgroundState.showBackground();

					if (FlxG.mouse.justPressed)
					{
						if (SkinsSelState.devSkinMode == false)
						{
							if (skinStatus[curSelected] == 1)
							{
								selectedBox.x = skinIconGroup.members[i].x - 7;
								selectedBox.y = skinIconGroup.members[i].y - 7;
								selectedBox.alpha = 1;

								FlxG.save.data.backgroundTheme = skinList[i];

								FlxG.sound.play(Paths.sound('confirmMenu2'));
							}
							else
							{
								FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), 0.2);
								camGame.shake(0.005, 0.2);
							}
						}
						else
						{
							selectedBox.x = skinIconGroup.members[i].x - 7;
							selectedBox.y = skinIconGroup.members[i].y - 7;
							selectedBox.alpha = 1;

							FlxG.save.data.backgroundTheme = skinList[i];

							FlxG.sound.play(Paths.sound('confirmMenu2'));
						}
					}
				}
			}

			if (FlxG.mouse.overlaps(skinIconGroup))
			{
				if (playHoverSound == true)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					playHoverSound = false;
				}
			}
			else if (FlxG.mouse.overlaps(bg2Button))
			{
				if (playHoverSound == true)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					playHoverSound = false;
				}
				bg2Button.setGraphicSize(Std.int(bg2Button.width * 1.06636501));
				if (FlxG.mouse.justPressed)
				{
					selectedSomethin = true;
					previewingBackgrounds = false;
					FlxG.sound.play(Paths.sound('confirmMenu2'));
					close();
					BackgroundState.curMenu = "Skins: Background 2";
					BackgroundState.showBackground();
					BackgroundState.doneSwitching = false;
				}
			}
			else if (FlxG.mouse.overlaps(BackgroundState.buttonHome))
			{
				hoverBox.alpha = 0;
				if (playHoverSound == true)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					playHoverSound = false;
				}
				BackgroundState.buttonHome.setGraphicSize(Std.int(BackgroundState.buttonHome.width * 1.06636501));
				if (FlxG.mouse.justPressed)
				{
					BackgroundState.buttonHome.loadGraphic(Paths.image('fallmen/UI/Menu/buttonMainSel'));
					BackgroundState.buttonSkins.loadGraphic(Paths.image('fallmen/UI/Menu/buttonSkins'));
					selectedSomethin = true;
					previewingBackgrounds = false;
					BackgroundState.stayingOnMenu = true;
					menuTrans(1);
					FlxG.sound.play(Paths.sound('confirmMenu2'));
					if (ClientPrefs.menuTrans)
					{
						new FlxTimer().start(2, function(tmr:FlxTimer)
						{
							close();
							BackgroundState.curMenu = "Main";
							BackgroundState.fadeBackground();
							BackgroundState.doneSwitching = false;
						});
					}
					else
					{
						close();
						BackgroundState.curMenu = "Main";
						BackgroundState.fadeBackground();
						BackgroundState.doneSwitching = false;
					}
				}
			}
			else
			{
				bg2Button.setGraphicSize(Std.int(bg2Button.width * 1));
				BackgroundState.buttonHome.setGraphicSize(Std.int(BackgroundState.buttonHome.width * 1));
				playHoverSound = true;
				hoverBox.alpha = 0;
			}

			if (FlxG.mouse.overlaps(BackgroundState.buttonSkins))
			{
				if (FlxG.mouse.justPressed)
				{
					selectedSomethin = true;
					previewingBackgrounds = false;
					SkinsSelState.skinMenuMoveBack = true;
					FlxG.sound.play(Paths.sound('confirmMenu2'));
					close();
					BackgroundState.curMenu = "Skins";
					BackgroundState.showBackground();
					BackgroundState.doneSwitching = false;
				}
			}

			if (controls.BACK)
			{
				selectedSomethin = true;
				previewingBackgrounds = false;
				SkinsSelState.skinMenuMoveBack = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				close();
				BackgroundState.curMenu = "Skins";
				BackgroundState.showBackground();
				BackgroundState.doneSwitching = false;
			}

			if (FlxG.keys.justPressed.LBRACKET)
			{
				selectedSomethin = true;
				previewingBackgrounds = false;
				BackgroundState.stayingOnMenu = true;
				menuTrans(1);
				FlxG.sound.play(Paths.sound('confirmMenu2'));
				if (ClientPrefs.menuTrans)
				{
					new FlxTimer().start(2, function(tmr:FlxTimer)
					{
						close();
						BackgroundState.curMenu = "Main";
						BackgroundState.fadeBackground();
						BackgroundState.doneSwitching = false;
					});
				}
				else
				{
					close();
					BackgroundState.curMenu = "Main";
					BackgroundState.fadeBackground();
					BackgroundState.doneSwitching = false;
				}
			}
		}

		super.update(elapsed);
	}
}
