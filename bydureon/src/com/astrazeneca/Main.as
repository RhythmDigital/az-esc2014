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
	import flash.utils.getTimer;
	
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
		
		private var nextAutoScreen:int = 0;
		
		private var screenLoading:Boolean = false;
		
		private var startTime:int;
		private var screensLoaded:int = 0;
		
		
		public function Main()
		{
			super();
			startTime = getTimer();
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
			
			if(screenLoading) {
				trace("NO!");
				//this.menu.highlight(currentScreen.id);
				return;
			}
			this.menu.highlight(e.data.id);
			stage.invalidate();
			
			screenToLoad = e.data.id;
			loadNextScreenImages();			
		}
		
		private function loadNextScreenImages():void
		{
			screenLoading = true;
			getScreenById(screenToLoad).loadImageManifest();
			getScreenById(screenToLoad).addEventListener("READY", screenImagesLoaded);
		}
		
		private function screenImagesLoaded(e:Event):void
		{		
			getScreenById(screenToLoad).removeEventListener("READY", screenImagesLoaded);
			if(!showScreen(screenToLoad)){
				// show screen rejected
				this.menu.highlight(currentScreen.id);
				screenLoading = false;
			}
		}
		
		private function showScreen(screenID):Boolean
		{
			//trace("Show screen: ", screenID);			
			
			if(getScreenById(screenID).transitioning == ScreenBase.CLOSING) false;			
			if((currentScreen && this.currentScreen.id == screenID)) false;
			
			nextScreenId = screenID;
			this.menu.highlight(nextScreenId);
			
			if(currentScreen && (currentScreen.transitioning == ScreenBase.OPENING 
				|| currentScreen.transitioning == ScreenBase.CLOSING
				|| currentScreen.transitioning == ScreenBase.LOADING
			))
			{
				currentScreen.immediateClose();
				showNextScreen();
				
			} else {
				if(!currentScreen) {
					showNextScreen();
				} else {
					currentScreen.hide();
				}
			}
			
			return true;			
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
				screens[i].screen.addEventListener("SCREEN_OPENED", onScreenOpened);
//				screens[i].screen.addEventListener("READY", onScreenReady);
				screens[i].screen.init(screens[i].id);
			}
			
			screenToLoad = DEFAULT_SCREEN;
			loadNextScreenImages();
			
			//showScreen();
			
		}
		
		private function onScreenOpened(e:Event):void
		{
			//trace("onScreenOpened");
			screenLoading = false;
						
			/*if(Variables.DEBUG) {
				screensLoaded ++;
				nextAutoScreen ++;
				if(nextAutoScreen == screens.length) nextAutoScreen = 0;
				
				screenToLoad = screens[nextAutoScreen].id;
				//loadNextScreenImages();
				
				trace("\n\n*******************\n");
				trace("Current screen: ", currentScreen.id, " & next: ", screenToLoad); 
				trace("Time elapsed: ", (getTimer()-startTime));
				trace("Screens loaded: ", screensLoaded);
				trace("\n*******************\n\n");
				
				TweenMax.delayedCall(5, loadNextScreenImages, null);
			}*/
		}
				
		private function onScreenClosed(e:Event):void
		{
			//trace("Screen closed");
			showNextScreen();
		}
		
		public function reset():void
		{
			// called after main timeout...
			if(screenToLoad != DEFAULT_SCREEN)
			{
				screenToLoad = DEFAULT_SCREEN;
				loadNextScreenImages();
			}
		}
		
	}
}

