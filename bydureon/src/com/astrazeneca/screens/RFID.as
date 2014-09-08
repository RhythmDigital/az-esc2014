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
				, 	{ img: path+'rFtext1.png', x:120, y:215, clipSprite:false, name:'rFtext1' }
				, 	{ img: path+'rFtext2.png', x:227, y:505 , clipSprite:false, name:'rFtext2' }
				, 	{ img: path+'rFtext3.png', x:227, y:819 , clipSprite:false, name:'rFtext3' }
				, 	{ img: path+'redIcon.png', x:115, y:820 , clipSprite:false, name:'redIcon' }
				, 	{ img: path+'rFtext4.png', x:227, y:975 , clipSprite:false, name:'rFtext4' }
				, 	{ img: path+'orangeIcon.png', x:115, y:982 , clipSprite:false, name:'orangeIcon' }
				, 	{ img: path+'rFtext5.png', x:227, y:1202 , clipSprite:false, name:'rFtext5' }
				, 	{ img: path+'greenIcon.png', x:115, y:1199 , clipSprite:false, name:'greenIcon' }
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
			addChild(images['rFtext1']);
			addChild(images['rFtext2']);
			addChild(images['rFtext3']);
			addChild(images['redIcon']);
			addChild(images['rFtext4']);
			addChild(images['orangeIcon']);
			addChild(images['rFtext5']);
			addChild(images['greenIcon']);
			
			timeline = new TimelineMax( {paused: true, onComplete:onTransitionComplete, onReverseComplete:onReverseTransitionComplete} );		
			timeline.append( TweenMax.to(images['RFIDwhiteBG'], .5, { x:10, ease:Sine.easeOut }) );
			timeline.append( TweenMax.to(images['RFIDorangeSwoosh'].clipRect, 1, { width:images['RFIDorangeSwoosh'].originalWidth, ease:Sine.easeInOut }), -0.8 );
			timeline.append( TweenMax.to(images['rFtext1'], .4, {alpha:1, ease:Sine.easeOut}), 0);
			timeline.append( TweenMax.to(images['rFtext2'], .4, {alpha:1, ease:Sine.easeOut}), -0.4);

			timeline.append( TweenMax.to(images['redIcon'], .4, {alpha:1, ease:Sine.easeOut}), 0);					
			timeline.append( TweenMax.to(images['rFtext3'], .4, {alpha:1, ease:Sine.easeOut}), 0);

			timeline.append( TweenMax.to(images['orangeIcon'], .4, {alpha:1, ease:Sine.easeOut}), 0);
			timeline.append( TweenMax.to(images['rFtext4'], .4, {alpha:1, ease:Sine.easeOut}), 0);

			timeline.append( TweenMax.to(images['greenIcon'], .4, {alpha:1, ease:Sine.easeOut}), 0);
			timeline.append( TweenMax.to(images['rFtext5'], .4, {alpha:1, ease:Sine.easeOut}), 0);
			
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
			images['rFtext1'].alpha = 0;
			images['rFtext2'].alpha = 0;
			images['rFtext3'].alpha = 0;
			images['redIcon'].alpha = 0;
			images['rFtext4'].alpha = 0;
			images['orangeIcon'].alpha = 0;
			images['rFtext5'].alpha = 0;
			images['greenIcon'].alpha = 0;
		}
	}
}