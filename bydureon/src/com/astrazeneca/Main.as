package com.astrazeneca 
{	
	import com.astrazeneca.screens.BusyLives;
	import com.astrazeneca.screens.MeetEric;
	import com.astrazeneca.screens.RFID;
	import com.astrazeneca.screens.SafetyTolerability;
	import com.astrazeneca.screens.SuperiorBasal;
	import com.astrazeneca.screens.SustainedEfficacy;
	import com.astrazeneca.screens.WeeklyDosing;
	import com.astrazeneca.starling.StarlingQuadButton;
	import com.greensock.TweenMax;
	
	import flash.display.Stage;
	
	import starling.core.Starling;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.display.Stage;
	import starling.events.Event;
	
	
	public class Main extends Sprite
	{
		private var stage:flash.display.Stage;
		private var starlingStage:starling.display.Stage;
		
		private var menu:Menu;
		private var currentScreen:ScreenBase;
		private var screens:Array = [];
		private var screensReady:int;
		
		private const DEFAULT_SCREEN:String = "meetEric";
		private var nextScreenId:String;		
		private var screenToLoad:Object;
		public function Main()
		{
			super();		
		}
		
		public function init(stage:flash.display.Stage):void
		{			
			this.stage = stage;
			this.starlingStage = Starling.current.stage;
			this.screensReady = 0;
			
			var bg:Quad = new Quad(1080, 1920, 0xd1d1d1);
			addChild(bg);
		
			menu = new Menu();
			addChild(menu);
			addEventListener(StarlingQuadButton.TOUCHED, onMenuButtonTouched);
			
			initScreens();
		}
		
		private function onMenuButtonTouched(e:Event):void
		{
			trace("Menu button", e.data.id);
			//nextScreenId = String(e.data.id);
			//showScreen(e.data.id);
			screenToLoad = e.data.id;
			loadNextScreenImages();
		}
		
		private function loadNextScreenImages():void
		{
			getScreenById(screenToLoad).loadImageManifest();
			getScreenById(screenToLoad).addEventListener("READY", screenImagesLoaded);
		}
		
		private function screenImagesLoaded(e:Event):void
		{
			getScreenById(screenToLoad).removeEventListener("READY", screenImagesLoaded);
			showScreen(screenToLoad);
		}
		
		private function showScreen(screenID):void
		{
			trace("Show screen: ", screenID);			
			
			if(getScreenById(screenID).transitioning == ScreenBase.CLOSING) return;			
			if((currentScreen && this.currentScreen.id == screenID)) return;
						
			nextScreenId = screenID;
			this.menu.highlight(nextScreenId);
			
			if(!currentScreen) {
				showNextScreen();
			} else {
				currentScreen.hide();
			}
		}
		
		private function showNextScreen():void
		{
			if(currentScreen && contains(currentScreen)) removeChild(currentScreen);
			currentScreen = getScreenById(nextScreenId);
			addChild(menu);
			addChild(currentScreen);
			currentScreen.show();
		}
		
		private function getScreenById(nextScreenID:Object):ScreenBase
		{
			for(var i:int = 0; i < screens.length; ++i)
				if(screens[i].id == nextScreenID) return screens[i].screen;

			return null;
		}
				
		private function initScreens():void
		{
			screens = new Array(
				{ id:"meetEric", screen:new MeetEric() }
				, { id:"sustainedEfficacy", screen:new SustainedEfficacy() }
				, { id:"superiorBasal", screen:new SuperiorBasal() }
				, { id:"weeklyDosing", screen:new WeeklyDosing() }
				, { id:"safetyTolerability", screen:new SafetyTolerability() }
				, { id:"busyLives", screen:new BusyLives() }
				, { id:"rfid", screen:new RFID() }
			);
			
			for(var i:int = 0; i < screens.length; ++i){
				screens[i].screen.addEventListener("SCREEN_CLOSED", onScreenClosed);
//				screens[i].screen.addEventListener("READY", onScreenReady);
				screens[i].screen.init(screens[i].id);
			}
			
			screenToLoad = DEFAULT_SCREEN;
			loadNextScreenImages();
			
			//showScreen();
			
		}		
		
		private function onScreenClosed(e:Event):void
		{
			trace("Screen closed");
			showNextScreen();
		}
		
//		private function onScreenReady(e:Event):void
//		{
//			trace("Screen " + screens[screensReady].id + " is ready.");
//			screensReady ++;
//			
//			if(screensReady == screens.length) {
//				showScreen(DEFAULT_SCREEN);
//			}
//		}
		
		public function reset():void
		{
			// called after main timeout...
		}
		
	}
}

