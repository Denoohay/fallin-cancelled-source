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

class GirlfriendSkinState extends MusicBeatSubstate
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
	public static var defaultButton:FlxSprite;

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

	var GFbopping:FlxTween;

	var camFollow:FlxObject;
	var camFollowPos:FlxObject;
	var debugKeys:Array<FlxKey>;

	var skinStatus:Array<Int> =
	[
		FlxG.save.data.gf_nothing,
		FlxG.save.data.gf_default,
		FlxG.save.data.gf_trackstar,
		FlxG.save.data.gf_og,
		FlxG.save.data.gf_fallguy,
		FlxG.save.data.gf_FgFan,
		FlxG.save.data.gf_hotDog,
		FlxG.save.data.gf_pegwin,
		FlxG.save.data.gf_miku,
		FlxG.save.data.gf_robot
	];

	var skinList:Array<String> =
	[
		'nothing',
		'default',
		'trackstar',
		'og-small',
		'fallguy',
		'FgFan',
		'hotDog',
		'pegwin',
		'miku',
		'robot'
	];

	var skinTitle:Array<String> =
	[
		'No Girlfriend',
		'Girlfriend',
		'Trackstar',
		"Friday Night Funkin' GF",
		'Fallfriend',
		'Fall Guy Fan GF',
		'Hot Dog',
		'Pegwin',
		'Hatsune Miku',
		'Robo GF'
	];

	var skinSeason:Array<String> =
	[
		'0',
		'1',
		'1',
		'1',
		'1',
		'1',
		'1',
		'1 (Exclusive)',
		'1 (Exclusive)',
		'1'
	];

	var skinDesc:Array<String> =
	[
		'misogynist.',
		'THE Girlfriend!\nAritst: Denoohay',
		'stickers\nAritst: Denoohay',
		"The original Girlfriend from Friday Night Funkin'.\nAritst: PhantomArcade",
		"Fall Guys x Friday Night Funkin' Girlfriend costume.\nAritst:Denoohay",
		'She possibly likes Fall Guys.\nAritst: Denoohay',
		'Fresh out the toaster.\nMade by: Denoohay',
		'quack\nMade by: Denoohay',
		'Like from that one FNF mod.\nMade by: Denoohay',
		'01000111 01000110 01000110 01001110 0100011.\nMade by: Denoohay'
	];

	var skinLockedText:Array<String> =
	[
		'ERROR',
		'ERROR',
		"ERROR",
		"Have save data for Friday Night Funkin'.",
		'Beat Free Falling, Splash Zone, and Royal Rumble.',
		'Buy from the shop.',
		'Buy from the shop.',
		'Reach Fame Level 10.',
		'Reach Fame Level 18.',
		'Earn a Silver Medal or better on Short Circut.'
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

		if (FlxG.save.data.GFskin == "songDefault")
		{
			if (MainMenuState.curSong == 'free falling' || MainMenuState.curSong == 'splash zone' || MainMenuState.curSong == 'royal rumble' || MainMenuState.curSong == 'short circut')
			{
				player = new Character(56, 128 - 31, 'gf');
			}
			else
			{
				player = new Character(56, 128, 'gf');
			}
		}
		else if (FlxG.save.data.GFskin == "og")
		{
			player = new Character(56 - 48, 128, 'gf-og-small');
		}
		else if (FlxG.save.data.GFskin == "og-small")
		{
			player = new Character(56 - 48, 128, 'gf');
		}
		else if (FlxG.save.data.GFskin == "trackstar")
		{
			player = new Character(56, 128 - 31, 'gf');
		}
		else if (FlxG.save.data.GFskin == "fallguy")
		{
			player = new Character(56 - 150, 128 - 130, 'gf');
		}
		else if (FlxG.save.data.GFskin == "FgFan")
		{
			player = new Character(56 + 17, 128, 'gf');
		}
		else if (FlxG.save.data.GFskin == "hotDog")
		{
			player = new Character(56 - 160, 128 - 152, 'gf');
		}
		else if (FlxG.save.data.GFskin == "pegwin")
		{
			player = new Character(56 + 27, 128 + 287, 'gf');
		}
		else if (FlxG.save.data.GFskin == "miku")
		{
			player = new Character(56 + 56, 128 + 33, 'gf');
		}
		else if (FlxG.save.data.GFskin == "robot")
		{
			player = new Character(56 - 40, 128 - 52, 'gf');
		}
		else
		{
			player = new Character(56, 128, 'gf-default');
		}

		player.scale.set(0.58, 0.58);
		add(player);

		GFbopping = FlxTween.tween(player, {alpha: 1}, 0.5, {type: LOOPING,
		onComplete: function(twn:FlxTween)
		{
			player.dance();
		}
		});

		bfButton = new FlxSprite(404, 99).loadGraphic(Paths.image('fallmen/UI/Menu/Skins/Menus/Costumes/bfButton'));
		bfButton.scrollFactor.set();
		bfButton.updateHitbox();
		bfButton.antialiasing = ClientPrefs.globalAntialiasing;
		add(bfButton);

		gfButton = new FlxSprite(684, 100).loadGraphic(Paths.image('fallmen/UI/Menu/Skins/Menus/Costumes/gfButtonSel'));
		gfButton.scrollFactor.set();
		gfButton.updateHitbox();
		gfButton.antialiasing = ClientPrefs.globalAntialiasing;
		add(gfButton);

		fgButton = new FlxSprite(965, 100).loadGraphic(Paths.image('fallmen/UI/Menu/Skins/Menus/Costumes/fgButton'));
		fgButton.scrollFactor.set();
		fgButton.updateHitbox();
		fgButton.antialiasing = ClientPrefs.globalAntialiasing;
		add(fgButton);

		selectBackground = new FlxSprite(399, 183).loadGraphic(Paths.image('fallmen/UI/Menu/Skins/Menus/Costumes/Background'));
		selectBackground.scrollFactor.set();
		selectBackground.updateHitbox();
		selectBackground.antialiasing = ClientPrefs.globalAntialiasing;
		add(selectBackground);

		defaultButton = new FlxSprite(447, 203).loadGraphic(Paths.image('fallmen/UI/Menu/Skins/Menus/Costumes/stageDefault'));
		defaultButton.scrollFactor.set();
		defaultButton.updateHitbox();
		defaultButton.antialiasing = ClientPrefs.globalAntialiasing;
		add(defaultButton);

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
			skinIcon.loadGraphic(Paths.image('fallmen/UI/Menu/Skins/Icons/Girlfriend/' + skinList[i]));
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
			if (FlxG.save.data.GFskin == skinList[i])
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
				
				FlxTween.tween(defaultButton, {x: defaultButton.x - 1280}, 2, {ease: FlxEase.quadInOut, type: FlxTweenType.ONESHOT});
				
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
				if (FlxG.save.data.GFskin == "songDefault")
				{
					selectedBox.alpha = 0;
				}
				else if (FlxG.save.data.GFskin == "")
				{
					selectedBox.x = skinIconGroup.members[1].x - 7;
					selectedBox.y = skinIconGroup.members[1].y - 7;
					selectedBox.alpha = 1;
				}
				else if (FlxG.save.data.GFskin == skinList[i])
				{
					selectedBox.x = skinIconGroup.members[i].x - 7;
					selectedBox.y = skinIconGroup.members[i].y - 7;
					selectedBox.alpha = 1;
				}
			}

			if(titleText.text == "")
			{
				if (FlxG.save.data.GFskin == "")
				{
					titleText.text = skinTitle[1].toUpperCase();
					if (curSelected == 0)
					{
						seasonText.text = "";
					}
					else
					{
						seasonText.text = "SEASON " + skinSeason[i].toUpperCase();
					}
					descText.text = skinDesc[1];
				}
				else if (FlxG.save.data.GFskin == "songDefault")
				{
					titleText.text = "SONG DEFAULT";
					seasonText.text = "";
					descText.text = "Uses the song's default costume.";
				}
				else if (FlxG.save.data.GFskin == skinList[i])
				{
					titleText.text = skinTitle[i].toUpperCase();
					if (curSelected == 0)
					{
						seasonText.text = "";
					}
					else
					{
						seasonText.text = "SEASON " + skinSeason[i].toUpperCase();
					}
					descText.text = skinDesc[i];
				}
			}
		}

		if (FlxG.save.data.GFskin == "songDefault")
		{
			defaultButton.loadGraphic(Paths.image('fallmen/UI/Menu/Skins/Menus/Costumes/stageDefaultSel'));
		}
		else
		{
			defaultButton.loadGraphic(Paths.image('fallmen/UI/Menu/Skins/Menus/Costumes/stageDefault'));
		}

		if (!selectedSomethin && BackgroundState.transitioning == false)
		{
			for (i in 0...skinList.length)
			{
				if (skinList[curSelected] == "nothing")
				{
					player.alpha = 0;
				}
				else
				{
					player.alpha = 1;
				}

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
							if (curSelected == 0)
							{
								seasonText.text = "";
							}
							else
							{
								seasonText.text = "SEASON " + skinSeason[i].toUpperCase();
							}
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
						if (curSelected == 0)
						{
							seasonText.text = "";
						}
						else
						{
							seasonText.text = "SEASON " + skinSeason[i].toUpperCase();
						}
						descText.text = skinDesc[i];
					}

					if (switchHoverChar == true)
					{
						GFbopping.cancel();
						remove(player);

						if (skinList[curSelected] == "og-small")
						{
							player = new Character(56 - 48, 128, 'gf-' + skinList[curSelected]);
						}
						else if (skinList[curSelected] == "trackstar")
						{
							player = new Character(56, 128 - 31, 'gf-' + skinList[curSelected]);
						}
						else if (skinList[curSelected] == "fallguy")
						{
							player = new Character(56 - 150, 128 - 130, 'gf-' + skinList[curSelected]);
						}
						else if (skinList[curSelected] == "FgFan")
						{
							player = new Character(56 + 17, 128, 'gf-' + skinList[curSelected]);
						}
						else if (skinList[curSelected] == "hotDog")
						{
							player = new Character(56 - 160, 128 - 152, 'gf-' + skinList[curSelected]);
						}
						else if (skinList[curSelected] == "pegwin")
						{
							player = new Character(56 + 27, 128 + 287, 'gf-' + skinList[curSelected]);
						}
						else if (skinList[curSelected] == "miku")
						{
							player = new Character(56 + 56, 128 + 33, 'gf-' + skinList[curSelected]);
						}
						else if (skinList[curSelected] == "robot")
						{
							player = new Character(56 - 40, 128 - 52, 'gf-' + skinList[curSelected]);
						}
						else
						{
							player = new Character(56, 128, 'gf-default');
						}

						if (skinStatus[curSelected] == 0 && SkinsSelState.devSkinMode == false)
						{
							player.color = 0xFF000000;
						}
						player.scale.set(0.58, 0.58);
						add(player);
						GFbopping = FlxTween.tween(player, {alpha: 1}, 0.5, {type: LOOPING,
						onComplete: function(twn:FlxTween)
						{
							player.dance();
						}
						});
						switchHoverChar = false;
						//trace('gf-' + skinList[curSelected]);
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
									FlxG.save.data.GFskin = "";
								}
								else
								{
									FlxG.save.data.GFskin = skinList[curSelected];
								}
								trace(FlxG.save.data.GFskin);
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
								FlxG.save.data.GFskin = "";
							}
							else
							{
								FlxG.save.data.GFskin = skinList[curSelected];
							}
							trace(FlxG.save.data.GFskin);
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
			else if (FlxG.mouse.overlaps(defaultButton))
			{
				if (playHoverSound == true)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					playHoverSound = false;
				}

				if (FlxG.save.data.GFskin != "songDefault")
				{
					defaultButton.setGraphicSize(Std.int(defaultButton.width * 1.06636501));
				}
				else
				{
					defaultButton.setGraphicSize(Std.int(defaultButton.width * 1));
				}

				if (FlxG.mouse.justPressed)
				{
					ablePressButton = true;
					if (ablePressButton == true)
					{
						selectedBox.alpha = 0;

						titleText.text = "SONG DEFAULT";
						seasonText.text = "";
						descText.text = "Uses the song's default costume.";
						curSelected = -1;
						FlxG.sound.play(Paths.sound('confirmMenu2'));
						ablePressButton = false;
						FlxG.save.data.GFskin = "songDefault";
						GFbopping.cancel();
						remove(player);
						if (MainMenuState.curSong == 'free falling' || MainMenuState.curSong == 'splash zone' || MainMenuState.curSong == 'royal rumble' || MainMenuState.curSong == 'short circut')
						{
							player = new Character(56, 128 - 31, 'gf');
						}
						else
						{
							player = new Character(56, 128, 'gf');
						}
						player.scale.set(0.58, 0.58);
						add(player);
						GFbopping = FlxTween.tween(player, {alpha: 1}, 0.5, {type: LOOPING,
						onComplete: function(twn:FlxTween)
						{
							player.dance();
						}
						});
						trace(FlxG.save.data.GFskin);
						ablePressButton = false;
					}
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
				fgButton.setGraphicSize(Std.int(fgButton.width * 1));
				defaultButton.setGraphicSize(Std.int(defaultButton.width * 1));
				if (FlxG.mouse.justPressed)
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu2'));
					GFbopping.cancel();
					close();
					BackgroundState.curMenu = "Skins: Boyfriend";
					BackgroundState.fadeBackground();
					BackgroundState.doneSwitching = false;
				}
			}
			else if (FlxG.mouse.overlaps(fgButton))
			{
				if (playHoverSound == true)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					playHoverSound = false;
				}
				bfButton.setGraphicSize(Std.int(bfButton.width * 1));
				fgButton.setGraphicSize(Std.int(fgButton.width * 1.06636501));
				defaultButton.setGraphicSize(Std.int(defaultButton.width * 1));
				if (FlxG.mouse.justPressed)
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu2'));
					GFbopping.cancel();
					close();
					BackgroundState.curMenu = "Skins: Fall Guy";
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
					GFbopping.cancel();
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
				fgButton.setGraphicSize(Std.int(fgButton.width * 1));
				defaultButton.setGraphicSize(Std.int(defaultButton.width * 1));
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
					GFbopping.cancel();
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
				GFbopping.cancel();
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
				GFbopping.cancel();
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