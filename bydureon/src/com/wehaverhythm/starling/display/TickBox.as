package com.wehaverhythm.starling.display
{
	import com.wehaverhythm.starling.utils.StarlingUtils;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	
	public class TickBox extends Sprite
	{
		private var tickedImage:Image;
		private var emptyImage:Image;
		
		public var ticked:Boolean;
		
		
		public function TickBox()
		{
			super();
			ticked = true;
		}
		
		public function initWithImages(empty:Image, ticked:Image):void
		{
			tickedImage = ticked;
			tickedImage.addEventListener(TouchEvent.TOUCH, onTouchTick);
				
			emptyImage = empty;			
			emptyImage.addEventListener(TouchEvent.TOUCH, onTouchEmpty);
			
			update();
		}
		
		public function initWithFlashSprites(empty:*, ticked:*):void
		{
			tickedImage = StarlingUtils.imageFromDisplayObject(ticked);
			tickedImage.addEventListener(TouchEvent.TOUCH, onTouchTick);
			
			emptyImage = StarlingUtils.imageFromDisplayObject(empty);		
			emptyImage.addEventListener(TouchEvent.TOUCH, onTouchEmpty);
			
			update();
		}
		
		public function onTouchTick(e:TouchEvent):void
		{
			if (e.touches[0].phase == TouchPhase.BEGAN) unTick();
		}
		
		public function onTouchEmpty(e:TouchEvent):void
		{
			if (e.touches[0].phase == TouchPhase.BEGAN) tick();
		}
		
		public function tick():void
		{
			ticked = true;
			update();
		}
		
		public function unTick():void
		{
			ticked = false;
			update();
		}
		
		public function setTicked(showTick:Boolean):void
		{
			showTick ? tick() : unTick();
		}
		
		private function update():void
		{
			if (ticked)
			{
				this.removeChild(emptyImage);
				this.addChild(tickedImage);
			}
			else
			{
				this.removeChild(tickedImage);
				this.addChild(emptyImage);
			}
		}
	}
}