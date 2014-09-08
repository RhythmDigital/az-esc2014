package com.astrazeneca.screens.sustainedefficacy
{
	import com.astrazeneca.starling.StarlingCounter;
	import com.greensock.TweenMax;
	import com.greensock.easing.Sine;
	
	import starling.display.Image;

	public class ImageCounter extends StarlingCounter
	{

		private var countToValue:Number;
		private var startX:int;
		private var endX:int;
		private var startY:int;
		private var endY:int;
		
		public function ImageCounter(img:Image, counterX:int, counterY:int, decimalPlaces:int, suffix:String, initialValue:Number, countToValue:Number, startX:int, endX:int, startY:int, endY:int)
		{
			super(1, suffix, initialValue);
			
			this.startX = startX;
			this.endX = endX;
			this.startY = startY;
			this.endY = endY;
			
			addChild(img);
			addChild(tf);
			
			this.tf.fontName = AZ_Bydureon.FONT_BydureonOblong;
			this.tf.color = 0xFF6600//0xffffff;
			tf.x = int(counterX);
			tf.y = int(counterY);
			
			this.countToValue = countToValue;
		}
		
		public function countForwards(time:Number=1, delay:Number=0, resetCount:Boolean=false):void
		{
			countTo(countToValue, time, delay);
			
			if(startX!=endX)
			{
				TweenMax.to(this, time, {delay:delay, x:endX, ease:Sine.easeOut});
				TweenMax.to(this, time/10, {delay:delay, alpha:1,ease:Sine.easeOut});
			}else{
				TweenMax.to(this, time, {delay:delay, y:endY, ease:Sine.easeOut});
				TweenMax.to(this, time/10, {delay:delay, alpha:1,ease:Sine.easeOut});
			}
			
			if(resetCount)TweenMax.delayedCall(time, reset);
		}
		public function countBackwards(time:Number=0.2, delay:Number=0, resetCount:Boolean=false):void
		{
			countTo(initialValue, time);
			if(startY!=endY)
			{
				TweenMax.to(this, time, {delay:delay, x:startX, ease:Sine.easeOut});
				TweenMax.to(this, time/10, {delay: time-(time/10), alpha:0,ease:Sine.easeOut});
			}else{
				TweenMax.to(this, time, {delay:delay, y:startY, ease:Sine.easeOut});
				TweenMax.to(this, time/10, {delay:delay, alpha:0,ease:Sine.easeOut});
			}
			
			if(resetCount)TweenMax.delayedCall(time, reset);
		}
		
		override public function reset():void
		{
			super.reset();
			TweenMax.killTweensOf(this, {x:true, alpha:true});
			TweenMax.killDelayedCallsTo(reset);
			x = startX;
			y = startY;
			alpha = 0;
		}
		
	}
}