package com.wehaverhythm.air
{
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	
	import starling.core.Starling;
	
	
	public class FullScreenManager
	{		
		private static var instance:FullScreenManager;
		private var stage:Stage;

		private var viewportRatio:Number;
		private var onResizeFunction:Function;
		
		
		public function FullScreenManager(pvt:SingletonEnforcer)
		{
		}
		
		public static function getInstance():FullScreenManager
		{
			if ( instance == null ) instance = new FullScreenManager( new SingletonEnforcer() );
			return instance;
		}
		
		public function init(stage:Stage, onResizeFunction:Function=null, portrait:Boolean=false):void
		{
			this.stage = stage;			
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			portrait ? viewportRatio = 9/16 : viewportRatio = 16/9;
			
			stage.nativeWindow.addEventListener(Event.RESIZE, onResize);
			if (onResizeFunction != null) this.onResizeFunction = onResizeFunction;

			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			onResize(null);
		}
		
		protected function onKeyDown(e:KeyboardEvent):void
		{
			if (e.keyCode == Keyboard.SPACE) MouseManager.getInstance().toggle();
			if (e.keyCode == Keyboard.ENTER) toggleFullScreen();
		}
		
		public function onResize(e:Event):void
		{
			if (Starling.current)
			{
				var v:Rectangle = Starling.current.viewPort;
				
				// Make Starling viewport correct ratio, centre it vertically if nessecery.
				
				v.width = stage.stageWidth;
				var newHeight:Number = stage.stageWidth/viewportRatio;
				v.height = newHeight;
				
				if (newHeight > stage.stageHeight) {
					v.height = stage.stageHeight;
					var newWidth:Number = stage.stageHeight*viewportRatio;
					v.width = newWidth;
				}
				
				v.x = (stage.stageWidth>> 1)-(v.width>>1);
				v.y = (stage.stageHeight>> 1)-(v.height>>1);
				
				Starling.current.viewPort.x = v.x;
				Starling.current.viewPort.y = v.y;
				Starling.current.viewPort.width = v.width;
				Starling.current.viewPort.height = v.height;
			}
			
			if (onResizeFunction != null) onResizeFunction(e);
		}
		
		public function toggleFullScreen():void
		{
			if (stage.displayState == StageDisplayState.NORMAL) stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
			else stage.displayState = StageDisplayState.NORMAL;
		}	
		
		public function toString():String
		{
			return 'FullScreenManager ::';
		}
		
	}
}

internal class SingletonEnforcer{};