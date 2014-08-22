package com.wehaverhythm.slideshow
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Sine;
	import com.wehaverhythm.starling.utils.StarlingUtils;
	import com.wehaverhythm.utils.IDestroyable;
	
	import flash.display.Bitmap;
	
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	
	public class SliderNav extends Sprite implements IDestroyable
	{
		public static const CLOSE_SECTION:String = 'CLOSE_SECTION';
		private var btnAlpha:Number;
		
		private var pdl1:Image;
		private var pdl1BG:Image;
		
		private var close:Image;
		private var plus:Image;
		
		private var items:Array = ['pdl1'];
		private var itemsHarness:Sprite;
		private var homeButton:Quad;
		
		private var closedX:int = 953;
		private var openX:int = 491;
		
		
		
		public function SliderNav()
		{
			super();
		}
		
		public function init(pdl1:Bitmap, close:Bitmap, plus:Bitmap, btnAlpha:Number):void
		{
			this.btnAlpha = btnAlpha;
			this.pdl1 = StarlingUtils.imageFromBitmap(pdl1);
			
			itemsHarness = new Sprite();
			addChild(itemsHarness);
			
			this.close = StarlingUtils.imageFromBitmap(close);
			this.plus = StarlingUtils.imageFromBitmap(plus);
			
			initButtons();
		}
		
		private function initButtons():void
		{
			homeButton = new Quad(50, 50, 0xFF6600);
			homeButton.x = 21;
			homeButton.y = 0;
			homeButton.alpha = btnAlpha;
			homeButton.addEventListener(TouchEvent.TOUCH, onTouchHomeButton);
			addChild(homeButton);
			
			close.x = plus.x = 21;
			close.y = plus.y = 52;
			close.addEventListener(TouchEvent.TOUCH, onTouchCloseButton);
			plus.addEventListener(TouchEvent.TOUCH, onTouchCloseButton);
		}
		
		private function onTouchHomeButton(e:TouchEvent):void
		{
			if (e.touches[0].phase == TouchPhase.BEGAN) dispatchEvent(new Event(CLOSE_SECTION));
		}
		
		private function onTouchCloseButton(e:TouchEvent):void
		{
			if (e.touches[0].phase == TouchPhase.BEGAN)
			{
				TweenMax.to(this, .4, {x:x > openX ? openX : closedX, ease:Sine.easeOut});
				if (x > openX)
				{
					addChild(close);
					removeChild(plus);
				}
				else {
					addChild(plus);
					removeChild(close);
				}
			}
		}
		
		public function show(drug:String):void
		{
			x = closedX;
			alpha = 0;
			
			addChild(close);
			removeChild(plus);
			
			while (itemsHarness.numChildren > 0) itemsHarness.removeChildAt(0);
			itemsHarness.addChild(this[drug]);
			
			TweenMax.to(this, .5, {alpha:1, ease:Sine.easeIn});
			TweenMax.to(this, .4, {delay:.6, x:openX, ease:Sine.easeOut});
		}
		
		public function destroy():void
		{
			TweenMax.killTweensOf(this);
			
			while (itemsHarness.numChildren > 0) itemsHarness.removeChildAt(0);
			removeChild(itemsHarness);
			itemsHarness.dispose();
			itemsHarness = null;
			
			items = null;
			
			removeChild(plus);
			plus.removeEventListener(TouchEvent.TOUCH, onTouchCloseButton);
			plus.dispose();
			plus = null;
			
			removeChild(close);
			close.removeEventListener(TouchEvent.TOUCH, onTouchCloseButton);
			close.dispose();
			close = null;
			
			pdl1.dispose();
			pdl1 = null;
			
			homeButton.removeEventListener(TouchEvent.TOUCH, onTouchHomeButton);
			homeButton.dispose();
			homeButton = null;
		}
	}
}

