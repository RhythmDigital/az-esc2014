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
	import com.astrazeneca.ClipSprite;
	
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
		private var kgCounter5:ImageCounter;
		private var kgCounter6:ImageCounter;
		private var kgCounter7:ImageCounter;
		private var kgCounter8:ImageCounter;
		
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
				,	{ img: path+'topTextAdd.png', x:264, y:699, clipSprite:false, name:'topTextAdd' }
				,	{ img: path+'stage1.png', x:0, y:0, clipSprite:false, name:'stage1' }
				,	{ img: path+'stage2.png', x:0, y:0, clipSprite:false, name:'stage2' }
				,	{ img: path+'stage3.png', x:0, y:0, clipSprite:false, name:'stage3' }
				,	{ img: path+'stage4.png', x:0, y:0, clipSprite:false, name:'stage4' }
				,	{ img: path+'stageText.png', x:263, y:1112, clipSprite:false, name:'stageText' }
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
			addChild(images['stageText']);
			
			initViewStudyButton();
			initCounters1();
			initCounters2();
			initCounters3();
			initCounters4();
			initCounters5();
			initCounters6();
			initCounters7();
			initCounters8();
			
			
			addChild(images['topTextAdd']);
			addChild(images['stageText']);
			
			popup = new PopUp(images['sBpopUp'], 0, 238, new Rectangle(859,35,67,64));
			popup.addEventListener("HIDING", onShowViewStudyButton);
			addChild(popup);
			
			timeline = new TimelineMax( {paused: true, onComplete:onTransitionComplete, onReverseComplete:onReverseTransitionComplete} );			
			timeline.append(TweenMax.to(images['sBwhiteBG'], .5, {x:12, ease:Sine.easeOut}));
			timeline.append(TweenMax.to(images['sBswish1'].clipRect, .5, {width:images['sBswish1'].originalWidth, ease:Sine.easeOut}),-.1);
			timeline.append(TweenMax.to(images['sBtextLayer'], .4, {alpha:1, ease:Sine.easeOut}), 0);
			timeline.append(TweenMax.to(images['topTextAdd'], 0.6, {alpha:1, ease:Sine.easeOut}), 2.8);
			timeline.append(TweenMax.to(images['stageText'], 0.6, {alpha:1, ease:Sine.easeOut}), 0.5);
			
			
			images['sBtextLayer'].touchable = false;
			
			TweenMax.to(viewStudyButton, .3, {scaleX:.95, scaleY:.95, ease:com.greensock.easing.Quad.easeOut, repeat:-1, yoyo:true});
			
			reset();
			notifyReady();
		}
		
		private function initCounters1():void
		{
			var kgDialImg1:Image = images['topText1'];

			kgCounter1 = new ImageCounter(kgDialImg1, 60, 170, 0, "%", 0, -1.5, 0, 0, -kgDialImg1.height, 0 );
			kgCounter1.y = -kgDialImg1.height;
			var clipped:ClipSprite = new ClipSprite(kgDialImg1.width);
			clipped.addChild(kgCounter1);
			clipped.clipRect = new Rectangle(0, 0, kgDialImg1.width, kgDialImg1.height);
			clipped.x = 205;
			clipped.y = 589;
			
			addChild(clipped);
		}
		
		private function initCounters2():void
		{
			var kgDialImg2:Image = images['topText2'];
			kgCounter2 = new ImageCounter(kgDialImg2, 60, 146, 3, "%", 0, -1.3, 0, 0, -kgDialImg2.height, 0 );
			kgCounter2.y = -kgDialImg2.height;
			var clipped:ClipSprite = new ClipSprite(kgDialImg2.width);
			clipped.addChild(kgCounter2);
			clipped.clipRect = new Rectangle(0, 0, kgDialImg2.width, kgDialImg2.height);
			clipped.x = 338;
			clipped.y = 589;
					
			addChild(clipped);
		}
		
		private function initCounters3():void
		{			
			var kgDialImg3:Image = images['topText3'];
			kgCounter3 = new ImageCounter(kgDialImg3, 60, 106, 3, "%", 0, -1.0, 0, 0, -kgDialImg3.height, 0 );
			kgCounter3.y = -kgDialImg3.height;
			var clipped:ClipSprite = new ClipSprite(kgDialImg3.width);
			clipped.addChild(kgCounter3);
			clipped.clipRect = new Rectangle(0, 0, kgDialImg3.width, kgDialImg3.height);
			clipped.x = 523;
			clipped.y = 589;
			
			addChild(clipped);
		}
		
		private function initCounters4():void
		{
			var kgDialImg4:Image = images['topText4'];
			kgCounter4 = new ImageCounter(kgDialImg4, 60, 88, 3, "%", 0, -0.8, 0, 0, -kgDialImg4.height, 0 );
			kgCounter4.y = -kgDialImg4.height;
			var clipped:ClipSprite = new ClipSprite(kgDialImg4.width);
			clipped.addChild(kgCounter4);
			clipped.clipRect = new Rectangle(0, 0, kgDialImg4.width, kgDialImg4.height);
			clipped.x = 656;
			clipped.y = 589;
			
			addChild(clipped);
		}
		private function initCounters5():void
		{
			var kgDialImg5:Image = images['stage1'];
			kgCounter5 = new ImageCounter(kgDialImg5, 60, 58, 3, "kg", 0, -2.6, 0, 0, -kgDialImg5.height, 0 );
			kgCounter5.y = -kgDialImg5.height;
			var clipped:ClipSprite = new ClipSprite(kgDialImg5.width);
			clipped.addChild(kgCounter5);
			clipped.clipRect = new Rectangle(0, 0, kgDialImg5.width, kgDialImg5.height);
			clipped.x = 205;
			clipped.y = 1196;
			
			addChild(clipped);
		}
		private function initCounters6():void			
		{
			var kgDialImg6:Image = images['stage2'];
			kgCounter6 = new ImageCounter(kgDialImg6, 60, 30, 3, "kg", 0, +1.4, 0, 0, kgDialImg6.height, 0 );
			kgCounter6.y = 0;
			var clipped:ClipSprite = new ClipSprite(kgDialImg6.width);
			clipped.addChild(kgCounter6);
			clipped.clipRect = new Rectangle(0, 0, kgDialImg6.width, kgDialImg6.height);
			clipped.x = 338;
			clipped.y = 1148
			
			addChild(clipped);
		}
		private function initCounters7():void
		{
			var kgDialImg7:Image = images['stage3'];
			kgCounter7 = new ImageCounter(kgDialImg7, 60, 54, 3, "kg", 0, -2.5, 0, 0, -kgDialImg7.height, 0 );
			kgCounter7.y = -kgDialImg7.height;
			var clipped:ClipSprite = new ClipSprite(kgDialImg7.width);
			clipped.addChild(kgCounter7);
			clipped.clipRect = new Rectangle(0, 0, kgDialImg7.width, kgDialImg7.height);
			clipped.x = 523;
			clipped.y = 1196;
			
			addChild(clipped);
		}
		private function initCounters8():void
		{
			var kgDialImg8:Image = images['stage4'];
			kgCounter8 = new ImageCounter(kgDialImg8, 60, 48, 3, "kg", 0, +2.0, 0, 0, kgDialImg8.height, 0 );
			kgCounter8.y = 0;
			var clipped:ClipSprite = new ClipSprite(kgDialImg8.width);
			clipped.addChild(kgCounter8);
			clipped.clipRect = new Rectangle(0, 0, kgDialImg8.width, kgDialImg8.height);
			clipped.x = 656;
			clipped.y = 1129
			
			addChild(clipped);
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
			notifyScreenOpened();
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
			
			kgCounter1.countForwards(1, 2);
			kgCounter2.countForwards(1, 2.5);
			kgCounter3.countForwards(1, 3);
			kgCounter4.countForwards(1, 3.5);
			kgCounter5.countForwards(1, 4);
			kgCounter6.countForwards(1, 4.5);
			kgCounter7.countForwards(1, 5);
			kgCounter8.countForwards(1, 5.5);
	
			TweenMax.delayedCall(6.5, onShowViewStudyButton);
		}
		
		override public function hide():void
		{
			transitioning = CLOSING;
			timeline.timeScale(4);
			timeline.reverse();
			
			kgCounter1.countBackwards(0.1, 0, true);
			kgCounter2.countBackwards(0.1, 0, true);
			kgCounter3.countBackwards(0.1, 0, true);
			kgCounter4.countBackwards(0.1, 0, true);
			kgCounter5.countBackwards(0.1, 0, true);
			kgCounter6.countBackwards(0.1, 0, true);
			kgCounter7.countBackwards(0.1, 0, true);
			kgCounter8.countBackwards(0.1, 0, true);

			
			popup.hide();
			hideViewStudyButton();
		}
		
		override public function reset():void
		{
			super.reset();
			
			timeline.gotoAndStop(0);
			
			images['sBwhiteBG'].x = -1080;
			images['sBswish1'].clipRect.width = 0;
			images['sBtextLayer'].alpha = 0;
			images['topTextAdd'].alpha = 0;
			images['stageText'].alpha = 0;
			
			viewStudyButton.x = 1100+viewStudyButton.width;
			TweenMax.killTweensOf(viewStudyButton);
			
			kgCounter1.reset();
			kgCounter2.reset();
			kgCounter3.reset();
			kgCounter4.reset();
			kgCounter5.reset();
			kgCounter6.reset();
			kgCounter7.reset();
			kgCounter8.reset();
			
			popup.reset();
		}
	}
}
