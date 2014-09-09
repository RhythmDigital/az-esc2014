package com.wehaverhythm.air
{
	import com.wehaverhythm.air.AppStorage;
	
	import flash.display.Stage;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.system.Capabilities;
	
	import starling.core.Starling;
	
	
	public class FullScreenPrompt extends FSPrompt
	{
		public static const TIMEOUT_CHANGED:String = 'TIMEOUT_CHANGED';
		private var stage:Stage;
		
		private var defaultConfig:Object = { timeout:90 };
		public var config:Object;
		private var portrait:Boolean;
		
		
		public function FullScreenPrompt(stage:Stage, showTimeout:Boolean=true, portrait:Boolean=false)
		{
			super();
			
			this.portrait = portrait;			
			this.stage = stage;
			stage.addEventListener(FullScreenEvent.FULL_SCREEN, onFullScreen);
			onFullScreen(null);
			
			config = getConfig(false);
			
			timeoutTF.text = String(config.timeout);
			timeoutTF.restrict = '0-9';
			timeoutTF.addEventListener(Event.CHANGE, onTextChange);
			
			if (!showTimeout)
			{
				timeoutBits.visible = timeoutTF.visible = false;
				dragBits.y = 0;
			}
		}
		
		protected function onTextChange(event:Event):void
		{
			config.timeout = Number(timeoutTF.text);
			AppStorage.save(config, 'config.obj');	
			dispatchEvent(new Event(TIMEOUT_CHANGED));
		}
		
		private function onFullScreen(e:FullScreenEvent):void
		{
			if (stage.displayState == StageDisplayState.FULL_SCREEN_INTERACTIVE) 
			{
				if (Starling.current.nativeOverlay.contains(this)) Starling.current.nativeOverlay.removeChild(this);
				Starling.current.stage.touchable = true;
				
				if (!Capabilities.isDebugger) MouseManager.getInstance().hide();
			}
			else {				
				x = portrait ? 540 : 960;
				y = portrait ? 960 : 540;
				
				if (portrait)
				{
					bg.width = 1080;
					bg.height = 1920;
				}
				
				if(!Variables.DEBUG) {
					Starling.current.nativeOverlay.addChild(this);
					Starling.current.stage.touchable = false;
					MouseManager.getInstance().show();
				}
				
			}
		}
		
		private function getConfig(forceDefault:Boolean):Object
		{			
			var savedConfig:Object = AppStorage.load('config.obj');
			
			if (savedConfig == null || forceDefault || !savedConfig.timeout) 
			{
				trace('Saving default app config');
				AppStorage.save(defaultConfig, 'config.obj');
				return defaultConfig;
			}
			else {
				trace('App config found');
				return savedConfig;
			}
		}
		
		public function get timeout():Number
		{
			trace('returning timeout:', config.timeout * 1000);
			return config.timeout * 1000;
		}
	}
}