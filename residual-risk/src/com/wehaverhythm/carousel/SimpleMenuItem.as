package com.wehaverhythm.carousel
{
	import com.wehaverhythm.starling.utils.CustomEvent;
	import com.wehaverhythm.starling.utils.SmartImage;
	import com.wehaverhythm.utils.IDestroyable;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	import starling.display.Sprite;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	
	public class SimpleMenuItem extends Sprite implements IDestroyable
	{
		private var girth:int;
		private var display:*;
		private var hitRadius:int;
		public var homeAngle:Number;
		public var position:int;
		
		public var id:int;
		public var title:String;
		
		public var z:Number;
		public var image:SmartImage;	
		
		public var bottom:Number;
		
		
		public function SimpleMenuItem(display:*, id:int, title:String, hitRadius:int = 200)
		{
			this.id = id;
			this.title = title;
			this.hitRadius = hitRadius;
			
			var bmd:BitmapData = new BitmapData(display.width, display.height, true, 0x000000);
			bmd.draw(display);
			
			this.image = new SmartImage(new Bitmap(bmd));			
			addChild(this.image);
			
			bmd.dispose();
			bmd = null;
			
			this.image.x = -(display.width>>1);
			this.image.y = -(display.height>>1);
			
			touchable = true;
			addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		protected function onTouch(e:TouchEvent):void
		{
			if (e.touches[0].phase == TouchPhase.ENDED)
			{
				dispatchEvent(new CustomEvent("CAROUSEL_ITEM_CLICKED", {id:id, position:position}, true)); 
			}			
		}
		
		public function destroy():void
		{
			title = null;
			removeEventListener(TouchEvent.TOUCH, onTouch);
			
			image.destroy();
			image.dispose();
			image = null;
		}
	}
}
import com.wehaverhythm.carousel;

