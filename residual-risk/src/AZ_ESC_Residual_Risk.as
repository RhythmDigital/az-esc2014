package
{
	import com.astrazeneca.starling.StarlingManager;
	import com.astrazeneca.starling.StarlingStage;
	import com.wehaverhythm.air.FullScreenManager;
	import com.wehaverhythm.air.FullScreenPrompt;
	import com.wehaverhythm.utils.CustomEvent;
	import com.wehaverhythm.utils.IdleTimeout;
	
	import flash.display.Screen;
	import flash.display.Sprite;
	import flash.events.Event;
	
	
	[SWF (frameRate="60", width="1920", height="1080", backgroundColor="#EEEEEE")]
	public class AZ_ESC_Residual_Risk extends Sprite
	{
		private var fullScreenManager:FullScreenManager;
		private var starlingManager:StarlingManager;
		private var starlingStage:StarlingStage;		
		private var fullScreenPrompt:FullScreenPrompt;
		
		private var main:Main;
		
		
		public function AZ_ESC_Residual_Risk()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		protected function onAddedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			starlingManager = StarlingManager.getInstance();
			starlingManager.addEventListener(StarlingManager.STARLING_READY, onStarlingReady);
			starlingManager.init(stage);
		}
		
		private function onStarlingReady(e:CustomEvent):void
		{
			starlingManager.removeEventListener(StarlingManager.STARLING_READY, onStarlingReady);
			starlingStage = e.params.starlingStage;
			
			stage.nativeWindow.width = Math.ceil(Screen.mainScreen.bounds.width*.9);
			stage.nativeWindow.height = (stage.nativeWindow.width/16)*9;
			
			stage.nativeWindow.x = (Screen.mainScreen.bounds.width - stage.nativeWindow.width)/2;
			stage.nativeWindow.y = (Screen.mainScreen.bounds.height - stage.nativeWindow.height)/2;
			
			fullScreenPrompt = new FullScreenPrompt(stage);
			fullScreenPrompt.addEventListener(FullScreenPrompt.TIMEOUT_CHANGED, onTimeoutChanged);
			
			main = new Main();
			starlingStage.addChild(main);			
			main.init(stage);			
			
			IdleTimeout.init(stage, fullScreenPrompt.timeout, main.reset);
			
			fullScreenManager = FullScreenManager.getInstance();
			fullScreenManager.init(stage);
		}
		
		protected function onTimeoutChanged(event:Event):void
		{
			trace('resetting timeout to:', fullScreenPrompt.timeout);
			IdleTimeout.setTimeout(fullScreenPrompt.timeout);
		}
	}
}