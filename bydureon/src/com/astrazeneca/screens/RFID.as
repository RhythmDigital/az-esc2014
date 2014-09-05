package com.astrazeneca.screens
{
	import com.astrazeneca.ScreenBase;
	import com.greensock.TimelineMax;
	import com.greensock.TweenMax;
	import com.greensock.easing.Sine;
	
	import starling.display.Quad;
	
	public class RFID extends ScreenBase
	{
		private var timeline:TimelineMax;
		
		public function RFID()
		{
			super();
			
			var path:String = "rfid/";
			
			imageManifest = [
					{ img: path+'whiteBG.png', x:10, y:96, clipSprite:false, name:'RFIDwhiteBG' }
				,	{ img: path+'orangeSwoosh.png', x:43, y:0, clipSprite:true, name:'RFIDorangeSwoosh' }
				// , 	{ img: path+'rFtext1.png', x:121, y:215, clipSprite:false, name:'rFtext1' }
			];
		}
		
		override public function init(id:String):void
		{
			super.init(id);			
			
			transitioning = CLOSED;
		}
		
		override protected function imagesReady():void
		{
			addChild(images['RFIDwhiteBG']);
			addChild(images['RFIDorangeSwoosh']);
		//	addChild(images['rFtext1']);
			
			timeline = new TimelineMax( {paused: true, onComplete:onTransitionComplete, onReverseComplete:onReverseTransitionComplete} );		
			timeline.append( TweenMax.to(images['RFIDwhiteBG'], .5, { x:10, ease:Sine.easeOut }) );
			timeline.append( TweenMax.to(images['RFIDorangeSwoosh'].clipRect, 1, { width:images['RFIDorangeSwoosh'].originalWidth, ease:Sine.easeInOut }), -0.8 );
		//	timeline.append( TweenMax.to(images['rFtext1'], .4, {alpha:1, ease:Sine.easeOut}), -0.8);
			
			reset();
			notifyReady();
		}
		
		private function onTransitionComplete():void
		{
			transitioning = OPEN;
		}
		
		private function onReverseTransitionComplete():void
		{
			transitioning = CLOSED;
			TweenMax.to(this, .2, {alpha:0, ease:Sine.easeIn});
			notifyScreenClosed();
		}
		
		override public function show():void
		{
			super.show();
			
			transitioning = OPENING;
			timeline.timeScale(.7);
			timeline.play();
		}
		
		override public function hide():void
		{
			transitioning = CLOSING;
			timeline.timeScale(4);
			timeline.reverse();
		}
		
		override public function reset():void
		{
			images['RFIDwhiteBG'].x = -1080;
			images['RFIDorangeSwoosh'].clipRect.width = 0;
		//	images['rFtext1'].alpha = 0;
		}
	}
}