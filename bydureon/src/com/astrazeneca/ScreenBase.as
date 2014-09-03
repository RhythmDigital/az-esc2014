package com.astrazeneca
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Sine;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.LoaderMax;
	
	import flash.filesystem.File;
	import flash.geom.Rectangle;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	
	public class ScreenBase extends Sprite
	{
		private var loader:LoaderMax;
		
		protected var imageManifest:Array;
		protected var images:Array;
		
		public var transitioning:String;
		
		public static const OPENING:String = "OPENING";		
		public static const CLOSING:String = "CLOSING";
		
		public static const OPEN:String = "OPEN";
		public static const CLOSED:String = "CLOSED";
		public var id:String;
		
		
		public function ScreenBase()
		{
			super();
			alpha = 0;
		}
		
		public function init(id:String):void
		{			
			this.id = id;
			loadImageManifest();
		}
		
		private function loadImageManifest():void
		{
			loader = new LoaderMax({ onComplete:onInitialLoad });
			
			for each (var file:Object in imageManifest)
			{
				loader.append(new ImageLoader(File.applicationDirectory.url + 'assets/' + file.img, {name:file.name}));
			}
			
			loader.load();		
		}
		
		private function onInitialLoad(e:LoaderEvent):void
		{
			images = [];
			
			for each (var file:Object in imageManifest)
			{
				var image:Image = Image.fromBitmap(LoaderMax.getContent(file.name).rawContent);
				
				// encase image in a sprite? (for clipRect)
				if (!file.clipSprite) images[file.name] = image;
				else {
					images[file.name] = new ClipSprite(image.width);
					images[file.name].addChild(image);
					images[file.name].clipRect = new Rectangle(0, 0, 0, image.height);
				}			
				
				// position				
				images[file.name].x = file.x;
				images[file.name].y = file.y;
			}
			
			imagesReady();
		}
		
		protected function imagesReady():void
		{
			
		}
		
		protected function notifyScreenClosed():void
		{
			dispatchEvent(new Event("SCREEN_CLOSED", true));
		}
		
		public function reset():void
		{
			// reset everything
		}
		
		public function show():void
		{
			alpha = 0;
			TweenMax.to(this, .2, {alpha:1, ease:Sine.easeIn});
		}
		
		public function hide():void
		{
			
		}
	}
}