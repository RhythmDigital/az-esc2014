package com.astrazeneca.screens
{
	import com.astrazeneca.PopUp;
	import com.astrazeneca.ScreenBase;
	import com.astrazeneca.screens.sustainedefficacy.ImageCounter;
	import com.greensock.TimelineMax;
	import com.greensock.TweenMax;
	import com.greensock.easing.Sine;
	import com.wehaverhythm.starling.display.StarlingSimpleImageButton;
	
	import flash.geom.Rectangle;
	
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class SuperiorBasal extends ScreenBase
	{
		private var quad:Quad;
		private var timeline:TimelineMax;
		private var viewStudyButton:Sprite;
		private var popup:PopUp;
		private var kgCounter1:ImageCounter;
		private var kgCounter2:ImageCounter;
		private var kgCounter3:ImageCounter;
		private var kgCounter4:ImageCounter;
		
		public function SuperiorBasal()
		{
			super();
			var path:String = "superiorBasal/";
			
			imageManifest = [
				{ img: path+'whiteBG.png', x:13, y:96, clipSprite:false, name:'sBwhiteBG' }
				,	{ img: path+'swish1.png', x:48, y:0, clipSprite:true, name:'sBswish1' }
				,	{ img: path+'viewStudyTag.png', x:0, y:0, clipSprite:false, name:'sBviewStudyTag' }
				,	{ img: path+'popUp.png', x:0, y:0, clipSprite:false, name:'sBpopUp' }
				,	{ img: path+'sBtextLayer.png', x:0, y:0, clipSprite:false, name:'sBtextLayer' }
				,	{ img: path+'topText1.png', x:0, y:0, clipSprite:false, name:'topText1' }
				,	{ img: path+'topText2.png', x:0, y:0, clipSprite:false, name:'topText2' }
				,	{ img: path+'topText3.png', x:0, y:0, clipSprite:false, name:'topText3' }
				,	{ img: path+'topText4.png', x:0, y:0, clipSprite:false, name:'topText4' }
				,	{ img: path+'topTextAdd.png', x:243, y:643, clipSprite:false, name:'topTextAdd' }
			];
		}
		
		override public function init(id:String):void
		{
			super.init(id);
			transitioning = CLOSED;
		}
		
		override protected function imagesReady():void
		{
			addChild(images['sBwhiteBG']);
			addChild(images['sBswish1']);
			addChild(images['sBtextLayer']);
			addChild(images['topTextAdd']);
			
			initViewStudyButton();
			initCounters1();
			initCounters2();
			initCounters3();
			initCounters4();
			
			addChild(images['topTextAdd']);
			
			popup = new PopUp(images['sBpopUp'], 0, 238, new Rectangle(859,35,67,64));
			popup.addEventListener("HIDING", onShowViewStudyButton);
			addChild(popup);
			
			timeline = new TimelineMax( {paused: true, onComplete:onTransitionComplete, onReverseComplete:onReverseTransitionComplete} );			
			timeline.append(TweenMax.to(images['sBwhiteBG'], .5, {x:12, ease:Sine.easeOut}));
			timeline.append(TweenMax.to(images['sBswish1'].clipRect, 1, {width:images['sBswish1'].originalWidth, ease:Sine.easeInOut}),-.1);
			timeline.append(TweenMax.to(images['sBtextLayer'], .4, {alpha:1, ease:Sine.easeOut}), -0.8);
			timeline.append(TweenMax.to(images['topTextAdd'], .4, {alpha:1, ease:Sine.easeOut}), -0.8);
			
			
			images['sBtextLayer'].touchable = false;
			
			TweenMax.to(viewStudyButton, .3, {scaleX:.95, scaleY:.95, ease:com.greensock.easing.Quad.easeOut, repeat:-1, yoyo:true});
			
			reset();
			notifyReady();
		}
		
		private function initCounters1():void
		{
			var kgDialImg1:Image = images['topText1'];
			kgCounter1 = new ImageCounter(kgDialImg1, 0, -1.5, 0, "", 0, 0, 205, 205, 450, 588 );
		//	kgCounter1.y = 588;
			addChild(kgCounter1);
			
	
		}
		
		private function initCounters2():void
		{
			var kgDialImg2:Image = images['topText2'];
			kgCounter2 = new ImageCounter(kgDialImg2, 0, 0, 0, "", 0, 0, 338, 338, 450, 588 );
		//	kgCounter2.y = 1195;
			addChild(kgCounter2);
		}
		
		private function initCounters3():void
		{
			var kgDialImg3:Image = images['topText3'];
			kgCounter3 = new ImageCounter(kgDialImg3, 0, 0, 0, "", 0,0, 523, 523, 588, 588 );
		//	kgCounter3.y = 1131;
			addChild(kgCounter3);
		}
		
		private function initCounters4():void
		{
			var kgDialImg4:Image = images['topText4'];
			kgCounter4 = new ImageCounter(kgDialImg4, 0, 0, 0, "", 0, 0, 656, 656, 588, 588 );
		//	kgCounter4.y = 1131;
			addChild(kgCounter4);
		}
		
		private function onShowViewStudyButton(e:Event = null):void
		{
			TweenMax.to(viewStudyButton, .3, {x:1080, ease:Sine.easeOut});
			TweenMax.killDelayedCallsTo(onShowViewStudyButton);
		}
		
		private function initViewStudyButton():void
		{
			viewStudyButton = new StarlingSimpleImageButton();
			viewStudyButton.addChild(images['sBviewStudyTag']);
			addChild(viewStudyButton);
			viewStudyButton.pivotX = viewStudyButton.width;
			viewStudyButton.pivotY = viewStudyButton.height >> 1;
			viewStudyButton.addEventListener("TOUCHED", onViewStudyClicked);
			viewStudyButton.y = 1217 + (viewStudyButton.height >> 1);
			viewStudyButton.x = viewStudyButton.width;
		}
		
		private function onViewStudyClicked(e:Event):void
		{
			popup.show();
			hideViewStudyButton();
		}
		
		private function hideViewStudyButton():void
		{
			TweenMax.to(viewStudyButton, .3, {x:1100+viewStudyButton.width, ease:Sine.easeOut});
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
			
			kgCounter1.countForwards(2, 2);
			kgCounter2.countForwards(2, 2.5);
			kgCounter3.countForwards(2, 3);
			kgCounter4.countForwards(2, 3);
	
			TweenMax.delayedCall(1.8, onShowViewStudyButton);
		}
		
		override public function hide():void
		{
			transitioning = CLOSING;
			timeline.timeScale(4);
			timeline.reverse();
			
			kgCounter1.countBackwards(0.1);
			kgCounter2.countBackwards(0.1);
			kgCounter3.countBackwards(0.1);
			kgCounter4.countBackwards(0.1);

			
			popup.hide();
			hideViewStudyButton();
		}
		
		override public function reset():void
		{
			images['sBwhiteBG'].x = -1080;
			images['sBswish1'].clipRect.width = 0;
			images['sBtextLayer'].alpha = 0;
			images['topTextAdd'].alpha = 0;
			
			viewStudyButton.x = 1100+viewStudyButton.width;
			TweenMax.killTweensOf(viewStudyButton);
			
			kgCounter1.reset();
			kgCounter2.reset();
			kgCounter3.reset();
			kgCounter4.reset();
			
			popup.reset();
		}
	}
}
