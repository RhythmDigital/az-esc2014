package 
{	
	import com.greensock.TweenMax;
	
	import flash.display.Stage;
	
	import starling.core.Starling;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.display.Stage;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	
	public class Main extends Sprite
	{
		private var stage:flash.display.Stage;
		private var starlingStage:starling.display.Stage;
		
		private var menu:Menu;

		private var screen1:Screen1;
		
		
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
			
			initScreens();
			
			Starling.current.stage.addEventListener(TouchEvent.TOUCH, onTouchHomeScreen);
		}
		
		private function onTouchHomeScreen(e:TouchEvent):void
		{
			if (e.touches[0].phase == TouchPhase.BEGAN)
			{
				trace(screen1.transitioning);
				
				if (screen1.transitioning == ScreenBase.OPEN) screen1.hide();
				else if (screen1.transitioning == ScreenBase.CLOSED) screen1.show();
			}
		}
		
		private function initScreens():void
		{
			screen1 = new Screen1();
			screen1.init();
			addChild(screen1);
			
			TweenMax.delayedCall(1, screen1.show);
		}		
		
		public function reset():void
		{
			// called after main timeout...
		}
		
	}
}

