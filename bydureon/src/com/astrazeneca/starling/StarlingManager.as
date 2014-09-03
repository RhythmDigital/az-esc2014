package com.astrazeneca.starling
{
	import com.wehaverhythm.utils.CustomEvent;
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Event;
	

	public class StarlingManager extends EventDispatcher
	{		
		private static var instance:StarlingManager;
		public static const STARLING_READY:String = 'STARLING_READY';
		
		private var starling:Starling;
		private var starlingStage:Sprite;
		private var stage:Stage;
		
		
		public function StarlingManager(pvt:SingletonEnforcer)
		{
		}
		
		public static function getInstance():StarlingManager
		{
			if ( instance == null ) instance = new StarlingManager( new SingletonEnforcer() );
			return instance;
		}
		
		public function init(stage:Stage):void
		{
			this.stage = stage;
			
			Starling.handleLostContext = true;
			starling = new Starling(StarlingStage, stage, new Rectangle(0, 0, stage.stageWidth, stage.stageHeight));//, null, 'auto', Context3DProfile.BASELINE);
			starling.addEventListener(starling.events.Event.ROOT_CREATED, onStarlingReady);			
			// starling.showStats = Capabilities.isDebugger;
		}
		
		private function onStarlingReady(e:starling.events.Event):void
		{
			starling.removeEventListener(starling.events.Event.ROOT_CREATED, onStarlingReady);	
			
			starlingStage = Starling.current.root as StarlingStage;
			starling.start();
			
			trace(stage.stageWidth, stage.stageHeight);
			
			// Starling.current.nativeOverlay.addChild();
			
			// stage.addEventListener(flash.events.Event.RESIZE, resizeStage);
			dispatchEvent(new CustomEvent(STARLING_READY, { starlingStage:starlingStage }));
		}
		
		private function resizeStage(e:flash.events.Event):void
		{
			var viewPortRectangle:Rectangle = new Rectangle();
			viewPortRectangle.width = stage.stageWidth;
			viewPortRectangle.height = stage.stageHeight;
			Starling.current.viewPort = viewPortRectangle;
		}
		
		override public function toString():String
		{
			return 'StarlingManager ::';
		}
		
	}
}

internal class SingletonEnforcer{};