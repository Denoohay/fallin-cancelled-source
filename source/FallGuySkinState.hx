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

class FallGuySkinState extends MusicBeatSubstate
{
	var curSelected:Int;

	var playHoverSound:Bool;
	var ablePressButton:Bool;
	var switchHoverChar:Bool;

	private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;

	public static var bfButton:FlxSprite;
	public static var gfButton:FlxSprite;
	public static var fgButton:FlxSprite;
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

	public static var platform:FlxSprite;
	public static var player:Character;

	public static var cursor:FlxSprite;

	var camFollow:FlxObject;
	var camFollowPos:FlxObject;
	var debugKeys:Array<FlxKey>;

	var skinStatus:Array<Int> =
	[
		FlxG.save.data.fallguy_default,
		FlxG.save.data.fallguy_bolts,
		FlxG.save.data.fallguy_furry,
		FlxG.save.data.fallguy_hotDog,
		FlxG.save.data.fallguy_longGuy,
		FlxG.save.data.fallguy_sonic,
		FlxG.save.data.fallguy_tankGuy,
		FlxG.save.data.fallguy_cheesus,
		FlxG.save.data.fallguy_sus,
		FlxG.save.data.fallguy_rookie,
		FlxG.save.data.fallguy_plush,
		FlxG.save.data.fallguy_beta,
		FlxG.save.data.fallguy_demo,
		FlxG.save.data.fallguy_legacy1,
		FlxG.save.data.fallguy_legacy2
	];

	var skinList:Array<String> =
	[
		'default',
		'bolts',
		'furry',
		'hotDog',
		'longGuy',
		'sonic',
		'tankGuy',
		'cheesus',
		'sus',
		'rookie',
		'plush',
		'beta',
		'demo',
		'legacy1',
		'legacy2'
	];

	var skinTitle:Array<String> =
	[
		'Fall Guy',
		'Lightning',
		'Big Bad',
		'Hot Dog',
		"Long Guy",
		'Sonic the Hedgehog',
		'Tank Guy',
		"Bein' Cheesy",
		'Eggscellent',
		'Rookie',
		'Plush Guy',
		'Beta Fall Guy',
		'Demo Fall Guy',
		'Legacy Fall Guy #1',
		'Legacy Fall Guy #2'
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
		'1 (Exclusive)',
		'1 (Exclusive)',
		'1',
		'1',
		'1',
		'1',
		'1'
	];

	var skinDesc:Array<String> =
	[
		'Funky Charging Summer\nAritst: Denoohay',
		'Charged up.\nMade by: Mediatonic',
		"Don't say it.\nMade by: Mediatonic",
		'Yum!\nMade by: Mediatonic',
		'Uh oh...\nMade by: Mediatonic',
		'Chilly dog or something.\nMade by: Mediatonic',
		'Fall Guys x Newgrounds when??\nAritst: Denoohay',
		'Mr. Cheese.\nMade by: Mediatonic',
		'This is so Sussus Moogus they could Sabotage the whole thing...I might have a Meltdown.\nMade by: Mediatonic',
		'A classic Fall Guys costume!\nMade by: Mediatonic',
		'Get real.\nMade by: Denoohay',
		"The first ever Fall Guy sprites made for Friday Night Fallin'.\nAritst: Denoohay",
		"Sprites were made as a cleaned up version of the beta sprites before the demo released.\nAritst: Denoohay",
		"The first redition of the Fall Guy for Friday Night Fallin' Legacy.\nAritst: Denoohay",
		"The second redition of the Fall Guy for Friday Night Fallin' Legacy.\nAritst: Denoohay"
	];

	var skinLockedText:Array<String> =
	[
		'ERROR',
		'Buy from the shop.',
		"Buy from the shop.",
		'Buy from the shop.',
		'Buy from the shop.',
		'Buy from the shop.',
		'Buy from the shop.',
		'Buy from the shop.',
		'Reach Fame Level 15.',
		'Reach Fame Level 5.',
		"Earn a Silver Medal or better on Everybody Falls in Friday Night Fallin' Legacy.",
		"Have save data for Friday Night Fallin' Demo V1.",
		"Have save data for Friday Night Fallin' Demo V2.",
		"Have save data for Friday Night Fallin' Legacy.",
		"Have save data for Friday Night Fallin' Legacy."
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

		cursor = new FlxSprite(0, 0).loadGraphic(Paths.image('fallmen/UI/cursor'));
		cursor.updateHitbox();
		cursor.antialiasing = ClientPrefs.globalAntialiasing;
		
		platform = new FlxSprite(71, 493).loadGraphic(Paths.image('fallmen/UI/Menu/plat1'));
		platform.scrollFactor.set();
		platform.updateHitbox();
		platform.antialiasing = ClientPrefs.globalAntialiasing;
		add(platform);
		
		if (FlxG.save.data.FGskin == "bolts")
		{
			player = new Character(-70 + 25, 95, 'fall-guy');
		}
		else if (FlxG.save.data.FGskin == "furry")
		{
			player = new Character(-70 + 29, 95 - 29, 'fall-guy');
		}
		else if (FlxG.save.data.FGskin == "hotDog")
		{
			player = new Character(-70 + 47, 95 - 25, 'fall-guy');
		}
		else if (FlxG.save.data.FGskin == "longGuy")
		{
			player = new Character(-70 + 32, 95 - 119, 'fall-guy');
		}
		else if (FlxG.save.data.FGskin == "sonic")
		{
			player = new Character(-70 - 57, 95 - 74, 'fall-guy');
		}
		else if (FlxG.save.data.FGskin == "tankGuy")
		{
			player = new Character(-70, 95, 'fall-guy');
		}
		else if (FlxG.save.data.FGskin == "cheesus")
		{
			player = new Character(-70 + 22, 95 - 138, 'fall-guy');
		}
		else if (FlxG.save.data.FGskin == "sus")
		{
			player = new Character(-70 + 24, 95 - 17, 'fall-guy');
		}
		else if (FlxG.save.data.FGskin == "rookie")
		{
			player = new Character(-70 + 20, 95, 'fall-guy');
		}
		else if (FlxG.save.data.FGskin == "plush")
		{
			player = new Character(-70 - 83, 95 - 171, 'fall-guy');
		}
		else if (FlxG.save.data.FGskin == "beta" || FlxG.save.data.FGskin == "demo" || FlxG.save.data.FGskin == "legacy1" || FlxG.save.data.FGskin == "legacy2")
		{
			player = new Character(-70 - 236, 95 - 200, 'fall-guy');
		}
		else
		{
			player = new Character(-70, 95, 'fall-guy-default');
		}

		player.setGraphicSize(Std.int(player.width * 0.58));
		add(player);

		bfButton = new FlxSprite(404, 99).loadGraphic(Paths.image('fallmen/UI/Menu/Skins/Menus/Costumes/bfButton'));
		bfButton.scrollFactor.set();
		bfButton.updateHitbox();
		bfButton.antialiasing = ClientPrefs.globalAntialiasing;
		add(bfButton);

		gfButton = new FlxSprite(684, 100).loadGraphic(Paths.image('fallmen/UI/Menu/Skins/Menus/Costumes/gfButton'));
		gfButton.scrollFactor.set();
		gfButton.updateHitbox();
		gfButton.antialiasing = ClientPrefs.globalAntialiasing;
		add(gfButton);

		fgButton = new FlxSprite(965, 100).loadGraphic(Paths.image('fallmen/UI/Menu/Skins/Menus/Costumes/fgButtonSel'));
		fgButton.scrollFactor.set();
		fgButton.updateHitbox();
		fgButton.antialiasing = ClientPrefs.globalAntialiasing;
		add(fgButton);

		selectBackground = new FlxSprite(399, 183).loadGraphic(Paths.image('fallmen/UI/Menu/Skins/Menus/Costumes/Background'));
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
		
		var currentX:Float = 449;
		var currentY:Float = 293;
		for (i in 0...skinList.length)
		{
			if (i == 0)
			{
				skinIcon = new FlxSprite(449, 293);
			}
			else
			{
				currentX = currentX + 156;
				skinIcon = new FlxSprite(currentX, currentY);
			}

			if (i == 5 || i == 10)
			{
				currentY = currentY + 124;
				currentX = 449;
				skinIcon = new FlxSprite(currentX, currentY);
			}
			skinIcon.makeGraphic(FlxG.width, FlxG.height, FlxColor.TRANSPARENT);
			skinIcon.scrollFactor.x = 0;
			skinIcon.scrollFactor.y = 0;
			skinIcon.loadGraphic(Paths.image('fallmen/UI/Menu/Skins/Icons/Fall Guy/' + skinList[i]));
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

		titleText = new FlxText(31, 60, 340, "");
		titleText.scrollFactor.set();
		titleText.setFormat(Paths.font("fall.ttf"), 43, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE);
		titleText.borderSize = 3;
		titleText.borderColor = 0xFFFF00A4;
		titleText.antialiasing = ClientPrefs.globalAntialiasing;
		add(titleText);

		seasonText = new FlxText(31, 163, 340, "");
		seasonText.scrollFactor.set();
		seasonText.setFormat(Paths.font("fall.ttf"), 15, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE);
		seasonText.borderSize = 1.5;
		seasonText.borderColor = 0xFFFF00A4;
		seasonText.antialiasing = ClientPrefs.globalAntialiasing;
		add(seasonText);

		descText = new FlxText(31, 183, 340, "");
		descText.scrollFactor.set();
		descText.setFormat(Paths.font("phantom.ttf"), 20, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE);
		descText.borderSize = 1.5;
		descText.borderColor = 0xFFFF00A4;
		descText.antialiasing = ClientPrefs.globalAntialiasing;
		add(descText);
		
		for (i in 0...skinList.length)
		{
			if (FlxG.save.data.FGskin == skinList[i])
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
				FlxTween.tween(platform, {y: platform.y + 720}, 1, {ease: FlxEase.quadInOut, type: FlxTweenType.ONESHOT});

				FlxTween.tween(player, {y: player.y + 720}, 1, {ease: FlxEase.quadInOut, type: FlxTweenType.ONESHOT});
			
				FlxTween.tween(bfButton, {x: bfButton.x - 1280}, 2, {ease: FlxEase.quadInOut, type: FlxTweenType.ONESHOT});
				
				FlxTween.tween(gfButton, {x: gfButton.x - 1280}, 2, {ease: FlxEase.quadInOut, type: FlxTweenType.ONESHOT});
				
				FlxTween.tween(fgButton, {x: fgButton.x - 1280}, 2, {ease: FlxEase.quadInOut, type: FlxTweenType.ONESHOT});
				
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
		player.dance();

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
				if (FlxG.save.data.FGskin == "")
				{
					selectedBox.x = skinIconGroup.members[0].x - 7;
					selectedBox.y = skinIconGroup.members[0].y - 7;
					selectedBox.alpha = 1;
				}
				else if (FlxG.save.data.FGskin == skinList[i])
				{
					selectedBox.x = skinIconGroup.members[i].x - 7;
					selectedBox.y = skinIconGroup.members[i].y - 7;
					selectedBox.alpha = 1;
				}
			}

			if(titleText.text == "")
			{
				if (FlxG.save.data.FGskin == "")
				{
					titleText.text = skinTitle[0].toUpperCase();
					seasonText.text = "SEASON " + skinSeason[0].toUpperCase();
					descText.text = skinDesc[0];
				}
				else if (FlxG.save.data.FGskin == skinList[i])
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
					if (curSelected != i)
					{
						switchHoverChar = true;
					}
					
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

					if (switchHoverChar == true)
					{
						remove(player);

						if (skinList[curSelected] == "bolts")
						{
							player = new Character(-70 + 25, 95, 'fall-guy-' + skinList[curSelected]);
						}
						else if (skinList[curSelected] == "furry")
						{
							player = new Character(-70 + 29, 95 - 29, 'fall-guy-' + skinList[curSelected]);
						}
						else if (skinList[curSelected] == "hotDog")
						{
							player = new Character(-70 + 47, 95 - 25, 'fall-guy-' + skinList[curSelected]);
						}
						else if (skinList[curSelected] == "longGuy")
						{
							player = new Character(-70 + 32, 95 - 119, 'fall-guy-' + skinList[curSelected]);
						}
						else if (skinList[curSelected] == "sonic")
						{
							player = new Character(-70 - 57, 95 - 74, 'fall-guy-' + skinList[curSelected]);
						}
						else if (skinList[curSelected] == "tankGuy")
						{
							player = new Character(-70, 95, 'fall-guy-' + skinList[curSelected]);
						}
						else if (skinList[curSelected] == "cheesus")
						{
							player = new Character(-70 + 22, 95 - 138, 'fall-guy-' + skinList[curSelected]);
						}
						else if (skinList[curSelected] == "sus")
						{
							player = new Character(-70 + 24, 95 - 17, 'fall-guy-' + skinList[curSelected]);
						}
						else if (skinList[curSelected] == "rookie")
						{
							player = new Character(-70 + 20, 95, 'fall-guy-' + skinList[curSelected]);
						}
						else if (skinList[curSelected] == "plush")
						{
							player = new Character(-70 - 83, 95 - 171, 'fall-guy-' + skinList[curSelected]);
						}
						else if (skinList[curSelected] == "beta" || skinList[curSelected] == "demo" || skinList[curSelected] == "legacy1" || skinList[curSelected] == "legacy2")
						{
							player = new Character(-70 - 236, 95 - 200, 'fall-guy-' + skinList[curSelected]);
						}
						else
						{
							player = new Character(-70, 95, 'fall-guy-default');
						}

						if (skinStatus[curSelected] == 0 && SkinsSelState.devSkinMode == false)
						{
							player.color = 0xFF000000;
						}
						player.setGraphicSize(Std.int(player.width * 0.58));
						add(player);
						switchHoverChar = false;
						//trace('fall-guy-' + skinList[curSelected]);
					}
					if (FlxG.mouse.justPressed)
					{
						if (SkinsSelState.devSkinMode == false)
						{
							if (skinStatus[curSelected] == 1)
							{
								selectedBox.x = skinIconGroup.members[i].x - 7;
								selectedBox.y = skinIconGroup.members[i].y - 7;
								selectedBox.alpha = 1;

								FlxG.sound.play(Paths.sound('confirmMenu2'));
								if (skinList[curSelected] == "default")
								{
									FlxG.save.data.FGskin = "";
								}
								else
								{
									FlxG.save.data.FGskin = skinList[curSelected];
								}
								trace(FlxG.save.data.FGskin);
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

							FlxG.sound.play(Paths.sound('confirmMenu2'));
							if (skinList[curSelected] == "default")
							{
								FlxG.save.data.FGskin = "";
							}
							else
							{
								FlxG.save.data.FGskin = skinList[curSelected];
							}
							trace(FlxG.save.data.FGskin);
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
			else if (FlxG.mouse.overlaps(bfButton))
			{
				if (playHoverSound == true)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					playHoverSound = false;
				}
				bfButton.setGraphicSize(Std.int(bfButton.width * 1.06636501));
				gfButton.setGraphicSize(Std.int(gfButton.width * 1));
				if (FlxG.mouse.justPressed)
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu2'));
					close();
					BackgroundState.curMenu = "Skins: Boyfriend";
					BackgroundState.fadeBackground();
					BackgroundState.doneSwitching = false;
				}
			}
			else if (FlxG.mouse.overlaps(gfButton))
			{
				if (playHoverSound == true)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					playHoverSound = false;
				}
				bfButton.setGraphicSize(Std.int(bfButton.width * 1));
				gfButton.setGraphicSize(Std.int(gfButton.width * 1.06636501));
				if (FlxG.mouse.justPressed)
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu2'));
					close();
					BackgroundState.curMenu = "Skins: Girlfriend";
					BackgroundState.fadeBackground();
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
				bfButton.setGraphicSize(Std.int(bfButton.width * 1));
				gfButton.setGraphicSize(Std.int(gfButton.width * 1));
				BackgroundState.buttonHome.setGraphicSize(Std.int(BackgroundState.buttonHome.width * 1));
				playHoverSound = true;
				hoverBox.alpha = 0;
			}

			if (FlxG.mouse.overlaps(BackgroundState.buttonSkins))
			{
				if (FlxG.mouse.justPressed)
				{
					selectedSomethin = true;
					SkinsSelState.skinMenuMoveBack = true;
					FlxG.sound.play(Paths.sound('confirmMenu2'));
					close();
					BackgroundState.curMenu = "Skins";
					BackgroundState.fadeBackground();
					BackgroundState.doneSwitching = false;
				}
			}

			if (controls.BACK)
			{
				selectedSomethin = true;
				SkinsSelState.skinMenuMoveBack = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				close();
				BackgroundState.curMenu = "Skins";
				BackgroundState.fadeBackground();
				BackgroundState.doneSwitching = false;
			}

			if (FlxG.keys.justPressed.LBRACKET)
			{
				selectedSomethin = true;
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
