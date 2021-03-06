package
{
	import com.astrazeneca.Main;
	import com.astrazeneca.starling.StarlingCounter;
	import com.astrazeneca.starling.StarlingManager;
	import com.astrazeneca.starling.StarlingStage;
	import com.wehaverhythm.air.FullScreenManager;
	import com.wehaverhythm.air.FullScreenPrompt;
	import com.wehaverhythm.utils.CustomEvent;
	import com.wehaverhythm.utils.IdleTimeout;
	
	import flash.display.Screen;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.textures.Texture;
	
	
	[SWF (frameRate="60", width="1080", height="1920", backgroundColor="#000000")]
	public class AZ_Bydureon extends Sprite
	{
		private var fullScreenManager:FullScreenManager;
		private var starlingManager:StarlingManager;
		private var starlingStage:StarlingStage;		
		private var fullScreenPrompt:FullScreenPrompt;
		
		private var main:Main;
		
		
		[Embed(source="/assets/BydureonOblongBMP.fnt", mimeType="application/octet-stream")]
		public static const BydureonOblongBMPXML:Class;
		[Embed(source = "/assets/BydureonOblongBMP.png")]
		public static const BydureonOblongPNG:Class;
		public static const FONT_BydureonOblong:String = "Bydureon Oblong";
		
		
		public function AZ_Bydureon()
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
			// register bmp font
			var texture:Texture = Texture.fromBitmap(new BydureonOblongPNG());
			var xml:XML = XML(new BydureonOblongBMPXML());
			TextField.registerBitmapFont(new BitmapFont(texture, xml));
			
			
			starlingManager.removeEventListener(StarlingManager.STARLING_READY, onStarlingReady);
			starlingStage = e.params.starlingStage;
			
			stage.nativeWindow.height = Math.ceil(Screen.mainScreen.bounds.width*.9);
			stage.nativeWindow.width = (stage.nativeWindow.width/16)*9;
			
			stage.nativeWindow.x = (Screen.mainScreen.bounds.width - stage.nativeWindow.width)/2;
			stage.nativeWindow.y = (Screen.mainScreen.bounds.height - stage.nativeWindow.height)/2;
			
			fullScreenPrompt = new FullScreenPrompt(stage, true, true);
			fullScreenPrompt.addEventListener(FullScreenPrompt.TIMEOUT_CHANGED, onTimeoutChanged);
			
			main = new Main();
			starlingStage.addChild(main);			
			main.init(stage);
			
			if(!Variables.DEBUG) IdleTimeout.init(stage, fullScreenPrompt.timeout, main.reset);
			
			fullScreenManager = FullScreenManager.getInstance();
			fullScreenManager.init(stage, null, true);
		}
		
		protected function onTimeoutChanged(event:Event):void
		{
			trace('resetting timeout to:', fullScreenPrompt.timeout);
			if(!Variables.DEBUG) {
				
				IdleTimeout.setTimeout(fullScreenPrompt.timeout);
			}
		}
	}
}