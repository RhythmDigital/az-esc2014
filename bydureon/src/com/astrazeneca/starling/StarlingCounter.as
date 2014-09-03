package com.astrazeneca.starling
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Sine;
	
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.utils.HAlign;

	public class StarlingCounter extends Sprite
	{
		public var currentValue:Number = 0;
		private var tf:TextField;
		private var decimalPlaces:Number;
		private var suffix:String;
		
		public function StarlingCounter(decimalPlaces:Number=1, suffix:String="")
		{
			this.decimalPlaces = decimalPlaces;
			this.suffix = suffix;
			
			tf = new TextField(250, 100, "counter", "Arial", 25, 0x000000, false);
			tf.autoSize = TextFieldAutoSize.HORIZONTAL;
			tf.alignPivot(HAlign.CENTER);
			addChild(tf);
			
			setTo(0);
		}
		
		public function setTo(value:Number):void
		{
			TweenMax.killTweensOf(this);
			currentValue = value;
			updateCounter();
		}
		
		private function getNumberWithCommas(x:String):String
		{
			return x.replace(/\B(?=(\d{3})+(?!\d))/g, ",");
		}
		
		public function countTo(value:Number, time:Number=1):void
		{
			TweenMax.to(this, time, {currentValue:value, onUpdate:updateCounter, onComplete:updateCounter, ease:Sine.easeInOut});
		}
		
		public function updateCounter():void
		{
			var withDecimalPlaces:String = currentValue.toFixed(decimalPlaces);
			tf.text = getNumberWithCommas( currentValue % 1 == 0 ? String(currentValue) : withDecimalPlaces ) + suffix;
		}
	}
}