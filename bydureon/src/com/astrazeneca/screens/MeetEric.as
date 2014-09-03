package com.astrazeneca.screens
{
	import com.astrazeneca.starling.StarlingCounter;
	import com.greensock.TimelineMax;
	import com.greensock.TweenMax;
	import com.greensock.easing.Circ;
	import com.greensock.easing.Sine;
	
	import flash.geom.Rectangle;
	
	import starling.core.Starling;
	import starling.display.Quad;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import com.astrazeneca.ClipSprite;
	import com.astrazeneca.ScreenBase;

	public class MeetEric extends ScreenBase
	{		
		private var timeline:TimelineMax;
		private var greenTextBar:ClipSprite;

		private var counter:StarlingCounter;
		
		
		
		public function MeetEric()
		{
			super();
			
			imageManifest = [
				{ img: 'screen1/white-bg.png', x:-10, y:212, clipSprite:false, name:'white-bg' },
				{ img: 'screen1/green-bar.png', x:0, y:0, clipSprite:true, name:'green' },
				{ img: 'screen1/orange-bar.png', x:0, y:321, clipSprite:true, name:'orange' },
				{ img: 'screen1/eric.png', x:365, y:490, clipSprite:false, name:'eric' },
				
				{ img: 'screen1/all-copy.png', x:105, y:340, clipSprite:false, name:'copy' }
			];
		}
		
		override public function init(id:String):void
		{
			super.init(id);			
			
			greenTextBar = new ClipSprite(965);
			greenTextBar.addChild(new Quad(greenTextBar.originalWidth, 61, 0x006935));
			greenTextBar.clipRect = new Rectangle(greenTextBar.originalWidth/2, 0, 0, 61);
			greenTextBar.x = 51;
			greenTextBar.y = 1347;
			
			transitioning = CLOSED;
		}
		
		override protected function imagesReady():void
		{
			addChild(images['white-bg']);
			addChild(images['orange']);
			addChild(images['eric']);
			addChild(images['green']);
			addChild(greenTextBar);
			addChild(images['copy']);
			
			counter = new StarlingCounter(3, " kg");
			counter.x = 200;
			counter.y = 200;
			addChild(counter);
			
			timeline = new TimelineMax( {paused: true, onComplete:onTransitionComplete, onReverseComplete:onReverseTransitionComplete} );
			timeline.append( TweenMax.to(images['green'].clipRect, 1, { width:images['green'].originalWidth, ease:Sine.easeInOut }) );
			timeline.append( TweenMax.to(images['orange'].clipRect, 1, { width:images['orange'].originalWidth, ease:Sine.easeOut }), -.8 );
			timeline.append( TweenMax.to(images['eric'], .3, { alpha:1, ease:Sine.easeIn }), -.8 );
			timeline.append( TweenMax.to(greenTextBar.clipRect, .6, { x:0, width:greenTextBar.originalWidth, ease:Circ.easeOut }), -.5 );
			timeline.append( TweenMax.to(images['copy'], .3, { delay:.2, alpha:1, ease:Sine.easeOut }), -.3);
						
			reset();
		}
		
		private function onTransitionComplete():void
		{
			transitioning = OPEN;
		}
		
		private function onReverseTransitionComplete():void
		{
			transitioning = CLOSED;
			counter.setTo(0);
			TweenMax.to(this, .2, {alpha:0, ease:Sine.easeIn});
			notifyScreenClosed();
		}
		
		override public function show():void
		{
			super.show();
			
			transitioning = OPENING;
			timeline.timeScale(.7);
			timeline.play();
			
			counter.countTo(20, 2);
		}
		
		override public function hide():void
		{
			transitioning = CLOSING;
			timeline.timeScale(4);
			timeline.reverse();
			counter.countTo(0, 0.2);
		}
		
		override public function reset():void
		{
			images['orange'].clipRect.width 
				= images['green'].clipRect.width 
				= greenTextBar.clipRect.width
				= 0;
			
			greenTextBar.clipRect.x = 266.5;			
			images['eric'].alpha = images['copy'].alpha = 0;
		}
	}
}