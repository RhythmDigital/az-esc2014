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
		protected var tf:TextField;
		private var decimalPlaces:Number;
		private var suffix:String;
		protected var initialValue:Number;
		
		public function StarlingCounter(decimalPlaces:Number=1, suffix:String="", initialValue:Number = 0)
		{
			this.decimalPlaces = decimalPlaces;
			this.suffix = suffix;
			this.initialValue = initialValue;
			
			tf = new TextField(300, 100, "counter", "Arial", 29, 0x000000, false);
			//tf.autoSize = TextFieldAutoSize.HORIZONTAL;
			tf.alignPivot(HAlign.CENTER);
			addChild(tf);
			
			setTo(initialValue);
		}
		
		public function setTo(value:Number):void
		{
			TweenMax.killTweensOf(this, {currentValue:true});
			currentValue = value;
			updateCounter();
			tf.alignPivot(HAlign.CENTER);
		}
		
		public function reset():void
		{
			setTo(initialValue);
		}
		
		private function getNumberWithCommas(x:String):String
		{
			return x.replace(/\B(?=(\d{3})+(?!\d))/g, ",");
		}
		
		public function countTo(value:Number, time:Number=1, delay:Number = 0):void
		{
			TweenMax.to(this, time, {delay:delay, currentValue:value, onUpdate:updateCounter, onComplete:updateCounter, ease:Sine.easeInOut});
		}
		
		public function updateCounter():void
		{
			var withDecimalPlaces:String = currentValue.toFixed(decimalPlaces);
			//tf.text = getNumberWithCommas( currentValue % 1 == 0 ? String(currentValue) : withDecimalPlaces ) + suffix;
			tf.text = getNumberWithCommas( withDecimalPlaces ) + suffix;
		}
	}
}