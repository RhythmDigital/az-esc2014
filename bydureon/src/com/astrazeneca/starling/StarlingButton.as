package com.astrazeneca.starling
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.LoaderMax;
	import com.wehaverhythm.starling.utils.StarlingUtils;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	
	public class StarlingButton extends Sprite
	{
		public var id:String;
		
		private var up:Image;
		private var down:Image;
		
		public static const UP:String = 'UP';
		public static const DOWN:String = 'DOWN';
		
		private var currentState:String;
		private var loader:LoaderMax;
		private var activate:Boolean;
		
		
		public function StarlingButton()
		{
			super();
		}
		
		public function init(activate:Boolean, id:String, upImagePath:String, downImagePath:String):void
		{
			this.id = id;
			this.activate = activate;
			
			loader = new LoaderMax({ onComplete:onImagesLoaded });
			loader.append(new ImageLoader(upImagePath, {name:'upImage'}));
			loader.append(new ImageLoader(downImagePath, {name:'downImage'}));
			
			loader.load();
			
			this.addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		public function onImagesLoaded(e:LoaderEvent):void
		{
			up = StarlingUtils.imageFromBitmap(loader.getContent('upImage').rawContent);
			addChild(up);
			
			down = StarlingUtils.imageFromBitmap(loader.getContent('downImage').rawContent);
			addChild(down);
			
			if (activate) state = DOWN;
			else state = UP;
		}
		
		protected function onTouch(e:TouchEvent):void
		{
			if (e.touches[0].phase == TouchPhase.BEGAN) state = DOWN;
		}
		
		public function set state(newState:String):void
		{
			currentState = newState;
			
			switch (newState)
			{
				case UP:
					up.visible = true;
					down.visible = false;
					break;
				
				case DOWN:
					up.visible = false;
					down.visible = true;
					break;	
			}
		}
	}
}