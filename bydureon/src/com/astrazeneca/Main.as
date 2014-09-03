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
		private var nextScreenID:Object;
		private var screens:Array = [];
		
		public function Main()
		{
			super();		
		}
		
		public function init(stage:flash.display.Stage):void
		{			
			this.stage = stage;
			this.starlingStage = Starling.current.stage;
			
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
			showScreen(e.data.id);
		}
		
		private function showScreen(nextScreenId:String):void
		{
			trace("Show screen: ", nextScreenId);
			
			if(getScreenById(nextScreenId).transitioning == ScreenBase.CLOSING) return;			
			if((currentScreen && this.currentScreen.id == nextScreenId)) return;
						
			this.nextScreenID = nextScreenId;
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
			currentScreen = getScreenById(nextScreenID);
			addChildAt(currentScreen, 1);
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
				screens[i].screen.init(screens[i].id);
			}
			
		}		
		
		private function onScreenClosed(e:Event):void
		{
			trace("Screen closed");
			showNextScreen();
		}
		
		public function reset():void
		{
			// called after main timeout...
		}
		
	}
}

