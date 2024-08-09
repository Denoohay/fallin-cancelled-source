package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.display.FlxBackdrop;
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
import editors.MasterEditorMenu;
import flixel.input.keyboard.FlxKey;
import flixel.util.FlxTimer;
import flixel.util.FlxGradient;

using StringTools;

class BackgroundState extends MusicBeatState
{
	public static var curMenu:String = "Main";

	public static var backgroundTheme:String = "Main";

	public static var transitioning:Bool = false;

	public static var transitionFromNonMenu:Bool = false;

	public static var stayingOnMenu:Bool = false;

	public static var doneSwitching:Bool = true;
	public static var weirdSwitch:Bool = false;

	var menuItems:FlxTypedGroup<FlxSprite>;
	private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;

	var camFollow:FlxObject;
	var camFollowPos:FlxObject;
	var debugKeys:Array<FlxKey>;

	public static var bg:FlxSprite;
	public static var bgPattern:FlxSprite;
	public static var bgPatternGroup:FlxTypedGroup<FlxSprite>;
	public static var bigring:FlxSprite;
	public static var samring:FlxSprite;
	public static var bigring2:FlxSprite;
	public static var samring2:FlxSprite;
	public static var bigring3:FlxSprite;
	public static var samring3:FlxSprite;
	public static var bigring4:FlxSprite;
	public static var samring4:FlxSprite;
	public static var bigring5:FlxSprite;
	public static var samring5:FlxSprite;
	public static var bigring6:FlxSprite;
	public static var samring6:FlxSprite;
	public static var bigring7:FlxSprite;
	public static var samring7:FlxSprite;
	public static var bigring8:FlxSprite;
	public static var samring8:FlxSprite;
	public static var bigringInplace:FlxSprite;
	public static var samringInplace:FlxSprite;
	public static var bigringInplace2:FlxSprite;
	public static var samringInplace2:FlxSprite;
	public static var bigringInplace3:FlxSprite;
	public static var samringInplace3:FlxSprite;
	public static var FrontalGrad:FlxSprite;

	public static var topBar:FlxSprite;
	public static var buttonHome:FlxSprite;
	public static var buttonSkins:FlxSprite;
	public static var buttonOptions:FlxSprite;

	public static var coverscreen:FlxSprite;
		
	public static var backColor:FlxColor;
	public static var patColor:FlxColor;
	public static var bigRingColor:FlxColor;
	public static var samRingColor:FlxColor;
	public static var gradColor:FlxColor;
	public static var gradAlpha:Float;

	override function create()
	{
		debugKeys = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_1'));
		
		camGame = new FlxCamera();
		camAchievement = new FlxCamera();
		camAchievement.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camAchievement);
		FlxCamera.defaultCameras = [camGame];

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

//$ This whole section is just for the background

		bg = new FlxSprite();
		bg.makeGraphic(FlxG.width, FlxG.height, 0xFFFFFFFF);
		bg.color = backColor;
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0;
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		bgPatternGroup = new FlxTypedGroup<FlxSprite>();
		add(bgPatternGroup);

		var currentY:Float = 0;
		var currentX:Float = 0;
		for (i in 0...40)
		{
			if (i == 0)
			{
				bgPattern = new FlxSprite(0, 0);
			}
			else
			{
				currentX = currentX + 160;
				bgPattern = new FlxSprite(currentX, currentY);
			}

			if (i == 8 || i == 16 || i == 24 || i == 32 || i == 40)
			{
				currentY = currentY + 160;
				currentX = 0;
				bgPattern = new FlxSprite(currentX, currentY);
			}

			bgPattern.makeGraphic(FlxG.width, FlxG.height, FlxColor.TRANSPARENT);
			bgPattern.scrollFactor.x = 0;
			bgPattern.scrollFactor.y = 0;
			bgPattern.loadGraphic(Paths.image('fallmen/UI/Menu/Skins/Patterns/' + FlxG.save.data.backgroundTheme));
			bgPattern.color = patColor;
			bgPattern.antialiasing = ClientPrefs.globalAntialiasing;
			bgPatternGroup.add(bgPattern);
			//trace(i + ' x:' + currentX + ', y:' + currentY);
		}

		bigring = new FlxSprite().loadGraphic(Paths.image('fallmen/UI/Menu/smircleBig'));
		bigring.scrollFactor.x = 0;
		bigring.scrollFactor.y = 0;
		bigring.setGraphicSize(Std.int(bigring.width * 0.001));
		bigring.updateHitbox();
		bigring.screenCenter();
		bigring.antialiasing = ClientPrefs.globalAntialiasing;
		bigring.color = bigRingColor;
		add(bigring);

		samring = new FlxSprite().loadGraphic(Paths.image('fallmen/UI/Menu/smircleSam'));
		samring.scrollFactor.x = 0;
		samring.scrollFactor.y = 0;
		samring.setGraphicSize(Std.int(samring.width * 0.001));
		samring.updateHitbox();
		samring.screenCenter();
		samring.antialiasing = ClientPrefs.globalAntialiasing;
		samring.color = samRingColor;
		add(samring);
		
		bigring2 = new FlxSprite().loadGraphic(Paths.image('fallmen/UI/Menu/smircleBig'));
		bigring2.scrollFactor.x = 0;
		bigring2.scrollFactor.y = 0;
		bigring2.setGraphicSize(Std.int(bigring2.width * 0.001));
		bigring2.updateHitbox();
		bigring2.screenCenter();
		bigring2.antialiasing = ClientPrefs.globalAntialiasing;
		bigring2.color = bigRingColor;
		add(bigring2);

		samring2 = new FlxSprite().loadGraphic(Paths.image('fallmen/UI/Menu/smircleSam'));
		samring2.scrollFactor.x = 0;
		samring2.scrollFactor.y = 0;
		samring2.setGraphicSize(Std.int(samring2.width * 0.001));
		samring2.updateHitbox();
		samring2.screenCenter();
		samring2.antialiasing = ClientPrefs.globalAntialiasing;
		samring2.color = samRingColor;
		add(samring2);
		
		bigring3 = new FlxSprite().loadGraphic(Paths.image('fallmen/UI/Menu/smircleBig'));
		bigring3.scrollFactor.x = 0;
		bigring3.scrollFactor.y = 0;
		bigring3.setGraphicSize(Std.int(bigring3.width * 0.001));
		bigring3.updateHitbox();
		bigring3.screenCenter();
		bigring3.antialiasing = ClientPrefs.globalAntialiasing;
		bigring3.color = bigRingColor;
		add(bigring3);

		samring3 = new FlxSprite().loadGraphic(Paths.image('fallmen/UI/Menu/smircleSam'));
		samring3.scrollFactor.x = 0;
		samring3.scrollFactor.y = 0;
		samring3.setGraphicSize(Std.int(samring3.width * 0.001));
		samring3.updateHitbox();
		samring3.screenCenter();
		samring3.antialiasing = ClientPrefs.globalAntialiasing;
		samring3.color = samRingColor;
		add(samring3);
		
		bigring4 = new FlxSprite().loadGraphic(Paths.image('fallmen/UI/Menu/smircleBig'));
		bigring4.scrollFactor.x = 0;
		bigring4.scrollFactor.y = 0;
		bigring4.setGraphicSize(Std.int(bigring4.width * 0.001));
		bigring4.updateHitbox();
		bigring4.screenCenter();
		bigring4.antialiasing = ClientPrefs.globalAntialiasing;
		bigring4.color = bigRingColor;
		add(bigring4);

		samring4 = new FlxSprite().loadGraphic(Paths.image('fallmen/UI/Menu/smircleSam'));
		samring4.scrollFactor.x = 0;
		samring4.scrollFactor.y = 0;
		samring4.setGraphicSize(Std.int(samring4.width * 0.001));
		samring4.updateHitbox();
		samring4.screenCenter();
		samring4.antialiasing = ClientPrefs.globalAntialiasing;
		samring4.color = samRingColor;
		add(samring4);

		bigring5 = new FlxSprite().loadGraphic(Paths.image('fallmen/UI/Menu/smircleBig'));
		bigring5.scrollFactor.x = 0;
		bigring5.scrollFactor.y = 0;
		bigring5.setGraphicSize(Std.int(bigring5.width * 0.001));
		bigring5.updateHitbox();
		bigring5.screenCenter();
		bigring5.antialiasing = ClientPrefs.globalAntialiasing;
		bigring5.color = bigRingColor;
		add(bigring5);

		samring5 = new FlxSprite().loadGraphic(Paths.image('fallmen/UI/Menu/smircleSam'));
		samring5.scrollFactor.x = 0;
		samring5.scrollFactor.y = 0;
		samring5.setGraphicSize(Std.int(samring5.width * 0.001));
		samring5.updateHitbox();
		samring5.screenCenter();
		samring5.antialiasing = ClientPrefs.globalAntialiasing;
		samring5.color = samRingColor;
		add(samring5);
		
		bigring6 = new FlxSprite().loadGraphic(Paths.image('fallmen/UI/Menu/smircleBig'));
		bigring6.scrollFactor.x = 0;
		bigring6.scrollFactor.y = 0;
		bigring6.setGraphicSize(Std.int(bigring6.width * 0.001));
		bigring6.updateHitbox();
		bigring6.screenCenter();
		bigring6.antialiasing = ClientPrefs.globalAntialiasing;
		bigring6.color = bigRingColor;
		add(bigring6);

		samring6 = new FlxSprite().loadGraphic(Paths.image('fallmen/UI/Menu/smircleSam'));
		samring6.scrollFactor.x = 0;
		samring6.scrollFactor.y = 0;
		samring6.setGraphicSize(Std.int(samring6.width * 0.001));
		samring6.updateHitbox();
		samring6.screenCenter();
		samring6.antialiasing = ClientPrefs.globalAntialiasing;
		samring6.color = samRingColor;
		add(samring6);
		
		bigring7 = new FlxSprite().loadGraphic(Paths.image('fallmen/UI/Menu/smircleBig'));
		bigring7.scrollFactor.x = 0;
		bigring7.scrollFactor.y = 0;
		bigring7.setGraphicSize(Std.int(bigring7.width * 0.001));
		bigring7.updateHitbox();
		bigring7.screenCenter();
		bigring7.antialiasing = ClientPrefs.globalAntialiasing;
		bigring7.color = bigRingColor;
		add(bigring7);

		samring7 = new FlxSprite().loadGraphic(Paths.image('fallmen/UI/Menu/smircleSam'));
		samring7.scrollFactor.x = 0;
		samring7.scrollFactor.y = 0;
		samring7.setGraphicSize(Std.int(samring7.width * 0.001));
		samring7.updateHitbox();
		samring7.screenCenter();
		samring7.antialiasing = ClientPrefs.globalAntialiasing;
		samring7.color = samRingColor;
		add(samring7);
		
		bigring8 = new FlxSprite().loadGraphic(Paths.image('fallmen/UI/Menu/smircleBig'));
		bigring8.scrollFactor.x = 0;
		bigring8.scrollFactor.y = 0;
		bigring8.setGraphicSize(Std.int(bigring8.width * 0.001));
		bigring8.updateHitbox();
		bigring8.screenCenter();
		bigring8.antialiasing = ClientPrefs.globalAntialiasing;
		bigring8.color = bigRingColor;
		add(bigring8);

		samring8 = new FlxSprite().loadGraphic(Paths.image('fallmen/UI/Menu/smircleSam'));
		samring8.scrollFactor.x = 0;
		samring8.scrollFactor.y = 0;
		samring8.setGraphicSize(Std.int(samring8.width * 0.001));
		samring8.updateHitbox();
		samring8.screenCenter();
		samring8.antialiasing = ClientPrefs.globalAntialiasing;
		samring8.color = samRingColor;
		add(samring8);

		FlxTween.tween(bigring.scale, {x:1, y:1}, 39, { ease: FlxEase.quadInOut, type: FlxTweenType.LOOPING } );
		FlxTween.tween(samring.scale, {x:1.1, y:1.1}, 39, { ease: FlxEase.quadInOut, type: FlxTweenType.LOOPING } );
		
		new FlxTimer().start(6, function(tmr:FlxTimer)
		{
			FlxTween.tween(bigring2.scale, {x:1, y:1}, 39, { ease: FlxEase.quadInOut, type: FlxTweenType.LOOPING } );
			FlxTween.tween(samring2.scale, {x:1.1, y:1.1}, 39, { ease: FlxEase.quadInOut, type: FlxTweenType.LOOPING } );
		});
		
		new FlxTimer().start(10, function(tmr:FlxTimer)
		{
			FlxTween.tween(bigring3.scale, {x:1, y:1}, 39, { ease: FlxEase.quadInOut, type: FlxTweenType.LOOPING } );
			FlxTween.tween(samring3.scale, {x:1.1, y:1.1}, 39, { ease: FlxEase.quadInOut, type: FlxTweenType.LOOPING } );
		});
		
		new FlxTimer().start(16, function(tmr:FlxTimer)
		{
			FlxTween.tween(bigring4.scale, {x:1, y:1}, 39, { ease: FlxEase.quadInOut, type: FlxTweenType.LOOPING } );
			FlxTween.tween(samring4.scale, {x:1.1, y:1.1}, 39, { ease: FlxEase.quadInOut, type: FlxTweenType.LOOPING } );
		});
		new FlxTimer().start(22, function(tmr:FlxTimer)
		{
			FlxTween.tween(bigring5.scale, {x:1, y:1}, 39, { ease: FlxEase.quadInOut, type: FlxTweenType.LOOPING } );
			FlxTween.tween(samring5.scale, {x:1.1, y:1.1}, 39, { ease: FlxEase.quadInOut, type: FlxTweenType.LOOPING } );
		});
		
		new FlxTimer().start(26, function(tmr:FlxTimer)
		{
			FlxTween.tween(bigring6.scale, {x:1, y:1}, 39, { ease: FlxEase.quadInOut, type: FlxTweenType.LOOPING } );
			FlxTween.tween(samring6.scale, {x:1.1, y:1.1}, 39, { ease: FlxEase.quadInOut, type: FlxTweenType.LOOPING } );
		});
		
		new FlxTimer().start(32, function(tmr:FlxTimer)
		{
			FlxTween.tween(bigring7.scale, {x:1, y:1}, 39, { ease: FlxEase.quadInOut, type: FlxTweenType.LOOPING } );
			FlxTween.tween(samring7.scale, {x:1.1, y:1.1}, 39, { ease: FlxEase.quadInOut, type: FlxTweenType.LOOPING } );
		});

		new FlxTimer().start(36, function(tmr:FlxTimer)
		{
			FlxTween.tween(bigring8.scale, {x:1, y:1}, 39, { ease: FlxEase.quadInOut, type: FlxTweenType.LOOPING } );
			FlxTween.tween(samring8.scale, {x:1.1, y:1.1}, 39, { ease: FlxEase.quadInOut, type: FlxTweenType.LOOPING } );
		});
		
		bigringInplace = new FlxSprite().loadGraphic(Paths.image('fallmen/UI/Menu/smircleBig'));
		bigringInplace.scrollFactor.x = 0;
		bigringInplace.scrollFactor.y = 0;
		bigringInplace.setGraphicSize(Std.int(bigringInplace.width * 0.7));
		bigringInplace.updateHitbox();
		bigringInplace.screenCenter();
		bigringInplace.antialiasing = ClientPrefs.globalAntialiasing;
		bigringInplace.color = bigRingColor;
		add(bigringInplace);

		samringInplace = new FlxSprite().loadGraphic(Paths.image('fallmen/UI/Menu/smircleSam'));
		samringInplace.scrollFactor.x = 0;
		samringInplace.scrollFactor.y = 0;
		samringInplace.setGraphicSize(Std.int(samringInplace.width * 0.75));
		samringInplace.updateHitbox();
		samringInplace.screenCenter();
		samringInplace.antialiasing = ClientPrefs.globalAntialiasing;
		samringInplace.color = samRingColor;
		add(samringInplace);

		bigringInplace2 = new FlxSprite().loadGraphic(Paths.image('fallmen/UI/Menu/smircleBig'));
		bigringInplace2.scrollFactor.x = 0;
		bigringInplace2.scrollFactor.y = 0;
		bigringInplace2.setGraphicSize(Std.int(bigringInplace2.width * 0.4));
		bigringInplace2.updateHitbox();
		bigringInplace2.screenCenter();
		bigringInplace2.antialiasing = ClientPrefs.globalAntialiasing;
		bigringInplace2.color = bigRingColor;
		add(bigringInplace2);

		samringInplace2 = new FlxSprite().loadGraphic(Paths.image('fallmen/UI/Menu/smircleSam'));
		samringInplace2.scrollFactor.x = 0;
		samringInplace2.scrollFactor.y = 0;
		samringInplace2.setGraphicSize(Std.int(samringInplace2.width * 0.45));
		samringInplace2.updateHitbox();
		samringInplace2.screenCenter();
		samringInplace2.antialiasing = ClientPrefs.globalAntialiasing;
		samringInplace2.color = samRingColor;
		add(samringInplace2);

		bigringInplace3 = new FlxSprite().loadGraphic(Paths.image('fallmen/UI/Menu/smircleBig'));
		bigringInplace3.scrollFactor.x = 0;
		bigringInplace3.scrollFactor.y = 0;
		bigringInplace3.setGraphicSize(Std.int(bigringInplace3.width * 0.15));
		bigringInplace3.updateHitbox();
		bigringInplace3.screenCenter();
		bigringInplace3.antialiasing = ClientPrefs.globalAntialiasing;
		bigringInplace3.color = bigRingColor;
		add(bigringInplace3);

		samringInplace3 = new FlxSprite().loadGraphic(Paths.image('fallmen/UI/Menu/smircleSam'));
		samringInplace3.scrollFactor.x = 0;
		samringInplace3.scrollFactor.y = 0;
		samringInplace3.setGraphicSize(Std.int(samringInplace3.width * 0.2));
		samringInplace3.updateHitbox();
		samringInplace3.screenCenter();
		samringInplace3.antialiasing = ClientPrefs.globalAntialiasing;
		samringInplace3.color = samRingColor;
		add(samringInplace3);

		FlxTween.tween(bigringInplace.scale, {x:1, y:1}, 12, { ease: FlxEase.quadInOut, type: FlxTweenType.ONESHOT } );
		FlxTween.tween(samringInplace.scale, {x:1.1, y:1.1}, 12, { ease: FlxEase.quadInOut, type: FlxTweenType.ONESHOT } );

		FlxTween.tween(bigringInplace2.scale, {x:1, y:1}, 20, { ease: FlxEase.quadInOut, type: FlxTweenType.ONESHOT } );
		FlxTween.tween(samringInplace2.scale, {x:1.1, y:1.1}, 20, { ease: FlxEase.quadInOut, type: FlxTweenType.ONESHOT } );

		FlxTween.tween(bigringInplace3.scale, {x:1, y:1}, 30, { ease: FlxEase.quadInOut, type: FlxTweenType.ONESHOT } );
		FlxTween.tween(samringInplace3.scale, {x:1.1, y:1.1}, 30, { ease: FlxEase.quadInOut, type: FlxTweenType.ONESHOT } );
		
		FrontalGrad = new FlxSprite().loadGraphic(Paths.image('fallmen/UI/Menu/smunstupidGrad'));
		FrontalGrad.scrollFactor.x = 0;
		FrontalGrad.scrollFactor.y = 0;
		FrontalGrad.updateHitbox();
		FrontalGrad.screenCenter();
		FrontalGrad.antialiasing = ClientPrefs.globalAntialiasing;
		FrontalGrad.alpha = gradAlpha;
		FrontalGrad.color = gradColor;
		add(FrontalGrad);

//$ and the background section ends here. ughghughhh

		topBar = new FlxSprite().loadGraphic(Paths.image('fallmen/UI/Menu/topblackbar'));
		topBar.x = 406;
		topBar.y = 0;
		topBar.scrollFactor.x = 0;
		topBar.scrollFactor.y = 0;
		topBar.updateHitbox();
		topBar.antialiasing = ClientPrefs.globalAntialiasing;
		add(topBar);

		buttonHome = new FlxSprite().loadGraphic(Paths.image('fallmen/UI/Menu/buttonMain'));
		buttonHome.x = 461;
		buttonHome.y = 13;
		buttonHome.scrollFactor.x = 0;
		buttonHome.scrollFactor.y = 0;
		buttonHome.updateHitbox();
		buttonHome.antialiasing = ClientPrefs.globalAntialiasing;
		add(buttonHome);

		buttonSkins = new FlxSprite().loadGraphic(Paths.image('fallmen/UI/Menu/buttonSkins'));
		buttonSkins.x = 654;
		buttonSkins.y = 13;
		buttonSkins.scrollFactor.x = 0;
		buttonSkins.scrollFactor.y = 0;
		buttonSkins.updateHitbox();
		buttonSkins.antialiasing = ClientPrefs.globalAntialiasing;
		add(buttonSkins);

		buttonOptions = new FlxSprite().loadGraphic(Paths.image('fallmen/UI/Menu/settings'));
		buttonOptions.x = 1109;
		buttonOptions.y = 20;
		buttonOptions.scrollFactor.x = 0;
		buttonOptions.scrollFactor.y = 0;
		buttonOptions.updateHitbox();
		buttonOptions.antialiasing = ClientPrefs.globalAntialiasing;
		add(buttonOptions);

		coverscreen = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		coverscreen.alpha = 0;
		coverscreen.scrollFactor.x = 0;
		coverscreen.scrollFactor.y = 0;
		add(coverscreen);

		camFollow = new FlxObject(0, 0, 1, 1);
		camFollowPos = new FlxObject(0, 0, 1, 1);
		add(camFollow);
		add(camFollowPos);

		FlxG.camera.follow(camFollowPos, null, 1);
		
		new FlxTimer().start(0, function(tmr:FlxTimer)
		{
			if (curMenu == "Main")
			{
				openSubState(new MainMenuState());
			}
		});
	
		showBackground();

		super.create();
	}

	public static function updateBackground()
	{
		if (Background1SkinState.previewingBackgrounds == true)
		{
			bgPatternGroup.forEach(function(spr:FlxSprite)
			{
				spr.loadGraphic(Paths.image('fallmen/UI/Menu/Skins/Patterns/' + Background1SkinState.curBackground));
			});
			backgroundTheme = Background1SkinState.curBackground;
		}
		else if (Background2SkinState.previewingBackgrounds == true)
		{
			bgPatternGroup.forEach(function(spr:FlxSprite)
			{
				spr.loadGraphic(Paths.image('fallmen/UI/Menu/Skins/Patterns/' + Background2SkinState.curBackground));
			});
			backgroundTheme = Background2SkinState.curBackground;
		}
		else
		{
			if (curMenu == "Main" || curMenu == "Skins: Background 1" || curMenu == "Freeplay")
			{
				bgPatternGroup.forEach(function(spr:FlxSprite)
				{
					spr.loadGraphic(Paths.image('fallmen/UI/Menu/Skins/Patterns/' + FlxG.save.data.backgroundTheme));
				});
				backgroundTheme = FlxG.save.data.backgroundTheme;
			}
			else if (curMenu == "Skins" || curMenu == "Skins: Boyfriend" || curMenu == "Skins: Girlfriend" || curMenu == "Skins: Fall Guy" || curMenu == "Skins: Background 2" || curMenu == "Settings" || curMenu == "Options" || curMenu == "Credits" || curMenu == "Challenges")
			{
				bgPatternGroup.forEach(function(spr:FlxSprite)
				{
					spr.loadGraphic(Paths.image('fallmen/UI/Menu/Skins/Patterns/' + FlxG.save.data.backgroundTheme2));
				});
				backgroundTheme = FlxG.save.data.backgroundTheme2;
			}
		}
		
		if (backgroundTheme == "default")
		{
			backColor = 0xFFFFC300;
			patColor = 0xFFFFD200;
			bigRingColor = 0xFFFFD200;
			samRingColor = 0xFFFFDC49;
			gradColor = 0xFFFFE48E;
			gradAlpha = 0.5;
		}
		else if (backgroundTheme == "defaultBlue")
		{
			backColor = 0xFF5296E1;
			patColor = 0xFF639CE3;
			bigRingColor = 0xFF639CE3;
			samRingColor = 0xFF7EA7E9;
			gradColor = 0xFFCCDFFF;
			gradAlpha = 0.5;
		}
		else if (backgroundTheme == "fire")
		{
			backColor = 0xFFF5452D;
			patColor = 0xFFF5632D;
			bigRingColor = 0xFFF45F1A;
			samRingColor = 0xFFF3250B;
			gradColor = 0xFFF5632D;
			gradAlpha = 1;
		}
		else if (backgroundTheme == "flower")
		{
			backColor = 0xFFF0B5FF;
			patColor = 0xFFEDC8FF;
			bigRingColor = 0xFFE1A5FF;
			samRingColor = 0xFFEA9EFF;
			gradColor = 0xFFEDC8FF;
			gradAlpha = 1;
		}
		else if (backgroundTheme == "charge")
		{
			backColor = 0xFF5E8CFF;
			patColor = 0xFF36ADF7;
			bigRingColor = 0xFF0080FF;
			samRingColor = 0xFF00D4FF;
			gradColor = 0xFF00D4FF;
			gradAlpha = 1;
		}
		else if (backgroundTheme == "garden")
		{
			backColor = 0xFF7FD890;
			patColor = 0xFF7BE599;
			bigRingColor = 0xFF79EA83;
			samRingColor = 0xFF80F0B2;
			gradColor = 0xFF80F0B2;
			gradAlpha = 1;
		}
		else if (backgroundTheme == "rain")
		{
			backColor = 0xFF46516D;
			patColor = 0xFF485287;
			bigRingColor = 0xFF364082;
			samRingColor = 0xFF404C99;
			gradColor = 0xFF364082;
			gradAlpha = 1;
		}
		else if (backgroundTheme == "cherry")
		{
			backColor = 0xFFD81D40;
			patColor = 0xFFE22248;
			bigRingColor = 0xFFE22B54;
			samRingColor = 0xFFEA2042;
			gradColor = 0xFFE22B54;
			gradAlpha = 0.5;
		}
		else if (backgroundTheme == "cyber")
		{
			backColor = 0xFF1D1D33;
			patColor = 0xFF38C8FF;
			bigRingColor = 0xFF4D455B;
			samRingColor = 0xFF6A8BBF;
			gradColor = 0xFF38C8FF;
			gradAlpha = 1;
		}
		else if (backgroundTheme == "gold")
		{
			backColor = 0xFFEFA200;
			patColor = 0xFFFFAC00;
			bigRingColor = 0xFFE88B00;
			samRingColor = 0xFFFFAC00;
			gradColor = 0xFFFFAC00;
			gradAlpha = 1;
		}
		else if (backgroundTheme == "fireworks")
		{
			backColor = 0xFF100F28;
			patColor = 0xFF461670;
			bigRingColor = 0xFF184418;
			samRingColor = 0xFF44CBE2;
			gradColor = 0xFF461670;
			gradAlpha = 1;
		}
		else if (backgroundTheme == "lovey")
		{
			backColor = 0xFFF10165;
			patColor = 0xFFF7227E;
			bigRingColor = 0xFFDB0049;
			samRingColor = 0xFFFF1188;
			gradColor = 0xFFF7227E;
			gradAlpha = 1;
		}
		else if (backgroundTheme == "shamrock")
		{
			backColor = 0xFF41D84B;
			patColor = 0xFF44E54F;
			bigRingColor = 0xFF42C952;
			samRingColor = 0xFF3CC54F;
			gradColor = 0xFF44E54F;
			gradAlpha = 1;
		}
		else if (backgroundTheme == "pastel")
		{
			backColor = 0xFFAFDEFF;
			patColor = 0xFFC4E7FF;
			bigRingColor = 0xFFFFB2F9;
			samRingColor = 0xFFFEF2B7;
			gradColor = 0xFFC4E7FF;
			gradAlpha = 1;
		}
		else if (backgroundTheme == "bombPop")
		{
			backColor = 0xFF6687E4;
			patColor = 0xFFC0D7F4;
			bigRingColor = 0xFFBF364F;
			samRingColor = 0xFFFFFFFF;
			gradColor = 0xFFFFFFFF;
			gradAlpha = 0.5;
		}
		else if (backgroundTheme == "trifecta")
		{
			backColor = 0xFF00BEFF;
			patColor = 0xFF54D4FF;
			bigRingColor = 0xFFFF2FCB;
			samRingColor = 0xFFFFD954;
			gradColor = 0xFFFF2FCB;
			gradAlpha = 1;
		}
		else if (backgroundTheme == "birthday")
		{
			backColor = 0xFFFFAFEB;
			patColor = 0xFFFFE4B2;
			bigRingColor = 0xFFFF51D3;
			samRingColor = 0xFF82D6B4;
			gradColor = 0xFFFF51D3;
			gradAlpha = 0.5;
		}
		else if (backgroundTheme == "winner")
		{
			backColor = 0xFFFF8200;
			patColor = 0xFFFFA500;
			bigRingColor = 0xFFFFAD00;
			samRingColor = 0xFFFF9800;
			gradColor = 0xFFFFAD00;
			gradAlpha = 1;
		}
		else if (backgroundTheme == "spooky")
		{
			backColor = 0xFFFF6D00;
			patColor = 0xFFD6592F;
			bigRingColor = 0xFF741D5E;
			samRingColor = 0xFF4C2A2A;
			gradColor = 0xFF741D5E;
			gradAlpha = 0.8;
		}
		else if (backgroundTheme == "merry")
		{
			backColor = 0xFFC9DDFF;
			patColor = 0xFFEAF2FF;
			bigRingColor = 0xFF47FF96;
			samRingColor = 0xFFFF606E;
			gradColor = 0xFFFFFFFF;
			gradAlpha = 1;
		}
		else if (backgroundTheme == "locked")
		{
			backColor = 0xFF404458;
			patColor = 0xFF3D4055;
			bigRingColor = 0xFF393D54;
			samRingColor = 0xFF3A3E54;
			gradColor = 0xFF393D54;
			gradAlpha = 0.5;
		}
	}

	public static function showBackground()
	{
		updateBackground();

		bg.color = backColor;
		bgPatternGroup.forEach(function(spr:FlxSprite)
		{
			spr.color = patColor;
		});
		bigring.color = bigRingColor;
		bigring2.color = bigRingColor;
		bigring3.color = bigRingColor;
		bigring4.color = bigRingColor;
		bigring5.color = bigRingColor;
		bigring6.color = bigRingColor;
		bigring7.color = bigRingColor;
		bigring8.color = bigRingColor;
		bigringInplace.color = bigRingColor;
		bigringInplace2.color = bigRingColor;
		bigringInplace3.color = bigRingColor;
		samring.color = samRingColor;
		samring2.color = samRingColor;
		samring3.color = samRingColor;
		samring4.color = samRingColor;
		samring5.color = samRingColor;
		samring6.color = samRingColor;
		samring7.color = samRingColor;
		samring8.color = samRingColor;
		samringInplace.color = samRingColor;
		samringInplace2.color = samRingColor;
		samringInplace3.color = samRingColor;
		FrontalGrad.color = gradColor;
	}

	public static function fadeBackground()
	{
		if (ClientPrefs.menuTrans)
		{
			updateBackground();

			FlxTween.color(bg, 2, bg.color, backColor,
			{
				onComplete: function(twn:FlxTween)
				{
					bg.color = backColor;
				}
			});
			
			bgPatternGroup.forEach(function(spr:FlxSprite)
			{
				FlxTween.color(spr, 2, spr.color, patColor,
				{
					onComplete: function(twn:FlxTween)
					{
						spr.color = patColor;
					}
				});
			});

			FlxTween.color(bigring, 2, bigring.color, bigRingColor,
			{
				onComplete: function(twn:FlxTween)
				{
					bigring.color = bigRingColor;
				}
			});
			FlxTween.color(bigring2, 2, bigring2.color, bigRingColor,
			{
				onComplete: function(twn:FlxTween)
				{
					bigring2.color = bigRingColor;
				}
			});
			FlxTween.color(bigring3, 2, bigring3.color, bigRingColor,
			{
				onComplete: function(twn:FlxTween)
				{
					bigring3.color = bigRingColor;
				}
			});
			FlxTween.color(bigring4, 2, bigring4.color, bigRingColor,
			{
				onComplete: function(twn:FlxTween)
				{
					bigring4.color = bigRingColor;
				}
			});
			FlxTween.color(bigring5, 2, bigring5.color, bigRingColor,
			{
				onComplete: function(twn:FlxTween)
				{
					bigring5.color = bigRingColor;
				}
			});
			FlxTween.color(bigring6, 2, bigring6.color, bigRingColor,
			{
				onComplete: function(twn:FlxTween)
				{
					bigring6.color = bigRingColor;
				}
			});
			FlxTween.color(bigring7, 2, bigring7.color, bigRingColor,
			{
				onComplete: function(twn:FlxTween)
				{
					bigring7.color = bigRingColor;
				}
			});
			FlxTween.color(bigring8, 2, bigring8.color, bigRingColor,
			{
				onComplete: function(twn:FlxTween)
				{
					bigring8.color = bigRingColor;
				}
			});
			FlxTween.color(bigringInplace, 2, bigringInplace.color, bigRingColor,
			{
				onComplete: function(twn:FlxTween)
				{
					bigringInplace.color = bigRingColor;
				}
			});
			FlxTween.color(bigringInplace2, 2, bigringInplace2.color, bigRingColor,
			{
				onComplete: function(twn:FlxTween)
				{
					bigringInplace2.color = bigRingColor;
				}
			});
			FlxTween.color(bigringInplace3, 2, bigringInplace3.color, bigRingColor,
			{
				onComplete: function(twn:FlxTween)
				{
					bigringInplace3.color = bigRingColor;
				}
			});
			FlxTween.color(samring, 2, samring.color, samRingColor,
			{
				onComplete: function(twn:FlxTween)
				{
					samring.color = samRingColor;
				}
			});
			FlxTween.color(samring2, 2, samring2.color, samRingColor,
			{
				onComplete: function(twn:FlxTween)
				{
					samring2.color = samRingColor;
				}
			});
			FlxTween.color(samring3, 2, samring3.color, samRingColor,
			{
				onComplete: function(twn:FlxTween)
				{
					samring3.color = samRingColor;
				}
			});
			FlxTween.color(samring4, 2, samring4.color, samRingColor,
			{
				onComplete: function(twn:FlxTween)
				{
					samring4.color = samRingColor;
				}
			});
			FlxTween.color(samring5, 2, samring5.color, samRingColor,
			{
				onComplete: function(twn:FlxTween)
				{
					samring5.color = samRingColor;
				}
			});
			FlxTween.color(samring6, 2, samring6.color, samRingColor,
			{
				onComplete: function(twn:FlxTween)
				{
					samring6.color = samRingColor;
				}
			});
			FlxTween.color(samring7, 2, samring7.color, samRingColor,
			{
				onComplete: function(twn:FlxTween)
				{
					samring7.color = samRingColor;
				}
			});
			FlxTween.color(samring8, 2, samring8.color, samRingColor,
			{
				onComplete: function(twn:FlxTween)
				{
					samring8.color = samRingColor;
				}
			});
			FlxTween.color(samringInplace, 2, samringInplace.color, samRingColor,
			{
				onComplete: function(twn:FlxTween)
				{
					samringInplace.color = samRingColor;
				}
			});
			FlxTween.color(samringInplace2, 2, samringInplace2.color, samRingColor,
			{
				onComplete: function(twn:FlxTween)
				{
					samringInplace2.color = samRingColor;
				}
			});
			FlxTween.color(samringInplace3, 2, samringInplace3.color, samRingColor,
			{
				onComplete: function(twn:FlxTween)
				{
					samringInplace3.color = samRingColor;
				}
			});
			FlxTween.color(FrontalGrad, 2, FrontalGrad.color, gradColor,
			{
				onComplete: function(twn:FlxTween)
				{
					FrontalGrad.color = gradColor;
				}
			});
		}
		else
		{
			showBackground();
		}
	}

	override function update(elapsed:Float)
	{
		FrontalGrad.alpha = gradAlpha;

		if (ClientPrefs.menuTrans == false)
		{
			transitioning = false;
			FreeplayState.kudoXslide = false;
		}

		if (doneSwitching == false)
		{
			if (curMenu == "Main")
			{
				openSubState(new MainMenuState());
				topBar.y = 0;
				buttonHome.y = 13;
				buttonSkins.y = 13;
				buttonOptions.x = 1109;
				doneSwitching = true;
			}
			else if (curMenu == "Freeplay")
			{
				openSubState(new FreeplayState());
				topBar.y = topBar.y - 100;
				buttonHome.y = buttonHome.y - 100;
				buttonSkins.y = buttonSkins.y - 100;
				buttonOptions.x = buttonOptions.x + 300;
				doneSwitching = true;
			}
			else if (curMenu == "Skins")
			{
				openSubState(new SkinsSelState());
				topBar.y = 0;
				buttonHome.y = 13;
				buttonSkins.y = 13;
				buttonOptions.x = buttonOptions.x + 300;
				doneSwitching = true;
			}
			else if (curMenu == "Skins: Boyfriend")
			{
				openSubState(new BoyfriendSkinState());
				topBar.y = 0;
				buttonHome.y = 13;
				buttonSkins.y = 13;
				buttonOptions.x = buttonOptions.x + 300;
				doneSwitching = true;
			}
			else if (curMenu == "Skins: Girlfriend")
			{
				openSubState(new GirlfriendSkinState());
				topBar.y = 0;
				buttonHome.y = 13;
				buttonSkins.y = 13;
				buttonOptions.x = buttonOptions.x + 300;
				doneSwitching = true;
			}
			else if (curMenu == "Skins: Fall Guy")
			{
				openSubState(new FallGuySkinState());
				topBar.y = 0;
				buttonHome.y = 13;
				buttonSkins.y = 13;
				buttonOptions.x = buttonOptions.x + 300;
				doneSwitching = true;
			}
			else if (curMenu == "Skins: Background 1")
			{
				openSubState(new Background1SkinState());
				topBar.y = 0;
				buttonHome.y = 13;
				buttonSkins.y = 13;
				buttonOptions.x = buttonOptions.x + 300;
				doneSwitching = true;
			}
			else if (curMenu == "Skins: Background 2")
			{
				openSubState(new Background2SkinState());
				topBar.y = 0;
				buttonHome.y = 13;
				buttonSkins.y = 13;
				buttonOptions.x = buttonOptions.x + 300;
				doneSwitching = true;
			}
			else if (curMenu == "Settings")
			{
				openSubState(new SettingsMenuState());
				topBar.y = topBar.y - 100;
				buttonHome.y = buttonHome.y - 100;
				buttonSkins.y = buttonSkins.y - 100;
				buttonOptions.x = buttonOptions.x + 300;
				doneSwitching = true;
			}
			else if (curMenu == "Credits")
			{
				openSubState(new CreditsState());
				topBar.y = topBar.y - 100;
				buttonHome.y = buttonHome.y - 100;
				buttonSkins.y = buttonSkins.y - 100;
				buttonOptions.x = buttonOptions.x + 300;
				doneSwitching = true;
			}
			else if (curMenu == "Options")
			{
				openSubState(new options.OptionsState());
				topBar.y = topBar.y - 100;
				buttonHome.y = buttonHome.y - 100;
				buttonSkins.y = buttonSkins.y - 100;
				buttonOptions.x = buttonOptions.x + 300;
				doneSwitching = true;
			}
		}
		else if (weirdSwitch == true)
		{
			openSubState(new FreeplayState());
			topBar.y = topBar.y - 100;
			buttonHome.y = buttonHome.y - 100;
			buttonSkins.y = buttonSkins.y - 100;
			buttonOptions.x = buttonOptions.x + 300;
			weirdSwitch = false;
		}

		super.update(elapsed);
	}
}
