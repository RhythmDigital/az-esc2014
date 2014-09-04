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
		public function ImageCounter(img:Image, counterX:int, counterY:int, decimalPlaces:int, suffix:String, initialValue:Number, countToValue:Number, startX:int, endX:int)
		{
			super(1, suffix, initialValue);
			
			this.startX = startX;
			this.endX = endX;
			
			addChild(img);
			addChild(tf);
			
			this.tf.fontName = AZ_Bydureon.FONT_BydureonOblong;
			this.tf.color = 0xffffff;
			tf.x = int(counterX);
			tf.y = int(counterY);
			
			this.countToValue = countToValue;
		}
		
		public function countForwards(time:Number=1, delay:Number=0):void
		{
			countTo(countToValue, time, delay);
			
			TweenMax.to(this, time, {delay:delay, x:endX, ease:Sine.easeOut});
			TweenMax.to(this, time/10, {delay:delay, alpha:1,ease:Sine.easeOut});
			
		}
		public function countBackwards(time:Number=0.2, delay:Number=0):void
		{
			countTo(initialValue, time);
			
			TweenMax.to(this, time, {delay:delay, x:startX, ease:Sine.easeOut});
			TweenMax.to(this, time/10, {delay: time-(time/10), alpha:0,ease:Sine.easeOut});
		}
		
		override public function reset():void
		{
			super.reset();
			TweenMax.killTweensOf(this, {x:true, alpha:true});
			x = startX;
			alpha = 0;
		}
	}
}