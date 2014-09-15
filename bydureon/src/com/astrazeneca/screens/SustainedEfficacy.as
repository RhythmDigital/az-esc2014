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
	
	public class SustainedEfficacy extends ScreenBase
	{
		private var quad:Quad;
		private var timeline:TimelineMax;
		private var viewStudyButton:Sprite;
		private var popup:PopUp;
		private var kgCounter:ImageCounter;
		private var kgCounterTwo:ImageCounter;
		private var kgCounterThree:ImageCounter;

		public function SustainedEfficacy()
		{
			super();
			
			var path:String = "sustainedEfficacy/";
			
			imageManifest = [
					{ img: path+'whiteBG.png', x:0, y:96, clipSprite:false, name:'sEwhiteBG' }
				,	{ img: path+'swish1.png', x:0, y:615, clipSprite:true, name:'sEswish1' }
				,	{ img: path+'swish2.png', x:0, y:1190, clipSprite:true, name:'sEswish2' }
				,	{ img: path+'swish3.png', x:0, y:904, clipSprite:true, name:'sEswish3' }
				,	{ img: path+'viewStudyTag.png', x:0, y:0, clipSprite:false, name:'sEviewStudyTag' }
				,	{ img: path+'popUpBg.png', x:0, y:0, clipSprite:false, name:'sEpopUp' }
				,	{ img: path+'sEtext1.png', x:68, y:208, clipSprite:false, name:'sEtext1' }
				,	{ img: path+'sEtext2.png', x:95, y:703, clipSprite:false, name:'sEtext2' }
				,	{ img: path+'greenDial.png', x:0, y:0, clipSprite:false, name:'sEgreenDial' }
				,	{ img: path+'sEtext3.png', x:95, y:1037, clipSprite:false, name:'sEtext3' }
				,	{ img: path+'greenArrow.png', x:0, y:0, clipSprite:false, name:'sEgreenArrow' }
				,	{ img: path+'sEtext4.png', x:95, y:1281, clipSprite:false, name:'sEtext4' }
				,	{ img: path+'orangeDial.png', x:0, y:0, clipSprite:false, name:'sEorangeDial' }
	
			];
		}
		
		override public function init(id:String):void
		{
			super.init(id);
			transitioning = CLOSED;
		}
		
		override protected function imagesReady():void
		{
			addChild(images['sEwhiteBG']);
			addChild(images['sEswish3']);
			addChild(images['sEswish1']);
			addChild(images['sEswish2']);
			addChild(images['sEtext1']);
			addChild(images['sEtext2']);
			addChild(images['sEtext3']);
			addChild(images['sEtext4']);
			
			initViewStudyButton();
			initCounters();
			initCountersTwo();
			initCountersThree();
			
			popup = new PopUp(images['sEpopUp'], 0, 238, new Rectangle(859,35,67,64));
			popup.addEventListener("HIDING", onShowViewStudyButton);
			addChild(popup);

			
			timeline = new TimelineMax( {paused: true, onComplete:onTransitionComplete, onReverseComplete:onReverseTransitionComplete} );			
			timeline.append(TweenMax.to(images['sEwhiteBG'], .5, {x:10, ease:Sine.easeOut}));
			timeline.append(TweenMax.to(images['sEswish1'].clipRect, .8, {width:images['sEswish1'].originalWidth, ease:Sine.easeInOut}),-.2);
			timeline.append(TweenMax.to(images['sEswish3'].clipRect, .8, {width:images['sEswish3'].originalWidth, ease:Sine.easeOut}), -0.8);
			timeline.append(TweenMax.to(images['sEswish2'].clipRect, .8, {width:images['sEswish2'].originalWidth, ease:Sine.easeOut}), -0.8);
			timeline.append(TweenMax.to(images['sEtext1'], .4, {alpha:1, ease:Sine.easeOut}), -0.3);
			timeline.append(TweenMax.to(images['sEtext2'], .4, {alpha:1, ease:Sine.easeOut}), -.2);
			timeline.append(TweenMax.to(images['sEtext3'], .4, {alpha:1, ease:Sine.easeOut}), 0);
			timeline.append(TweenMax.to(images['sEtext4'], .4, {alpha:1, ease:Sine.easeOut}), 0);
			
			
			TweenMax.to(viewStudyButton, .3, {scaleX:.95, scaleY:.95, ease:com.greensock.easing.Quad.easeOut, repeat:-1, yoyo:true});
			
			reset();
			notifyReady();
		}
		
		private function initCounters():void
		{
			//scales
			var kgDialImg:Image = images['sEorangeDial'];
			kgCounter = new ImageCounter(kgDialImg, int(kgDialImg.width/2), 38, 1, " kg", 0, -4.3, 306, 625, 1240, 1240);
			kgCounter.y = 1240;
			addChild(kgCounter);
		}
		
		private function initCountersTwo():void
		{
			//green dot
			var kgDialImgTwo:Image = images['sEgreenDial'];
			kgCounterTwo = new ImageCounter(kgDialImgTwo, int(kgDialImgTwo.width/2), 68, 1, "%", 0, -1.6, 306, 638, 712, 712);
			kgCounterTwo.y = 712;
			addChild(kgCounterTwo);
		}
		
		private function initCountersThree():void
		{
			//green arrow
			var kgDialImgThree:Image = images['sEgreenArrow'];
			kgCounterThree = new ImageCounter(kgDialImgThree, int(kgDialImgThree.width/2), 65, 1, "%", 0, -2.0, 638, 638, 930, 987);
			kgCounterThree.y = 987;
			addChild(kgCounterThree);
		}
		
		private function onShowViewStudyButton(e:Event = null):void
		{
			TweenMax.to(viewStudyButton, .3, {x:1080, ease:Sine.easeOut});
			TweenMax.killDelayedCallsTo(onShowViewStudyButton);
		}
		
		private function initViewStudyButton():void
		{
			viewStudyButton = new StarlingSimpleImageButton();
			viewStudyButton.addChild(images['sEviewStudyTag']);
			addChild(viewStudyButton);
			viewStudyButton.pivotX = viewStudyButton.width;
			viewStudyButton.pivotY = viewStudyButton.height >> 1;
			viewStudyButton.addEventListener("TOUCHED", onViewStudyClicked);
			viewStudyButton.y = 970 + (viewStudyButton.height >> 1);
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
			
			kgCounter.countForwards(1, 4.5);
			kgCounterTwo.countForwards(1, 2.5);
			kgCounterThree.countForwards(1, 3.5);
			TweenMax.delayedCall(6, onShowViewStudyButton);
		}
		
		override public function hide():void
		{
			transitioning = CLOSING;
			timeline.timeScale(4);
			timeline.reverse();
			
			kgCounter.countBackwards(0.1,0, true);
			kgCounterTwo.countBackwards(0.1,0,true);
			kgCounterThree.countBackwards(0.1,0,true);
			
			popup.hide();
			hideViewStudyButton();
		}
		
		override public function reset():void
		{
			super.reset();
			
			timeline.gotoAndStop(0);
			
			images['sEwhiteBG'].x = -1080;
			images['sEswish1'].clipRect.width = 0;
			images['sEswish2'].clipRect.width = 0;
			images['sEswish3'].clipRect.width = 0;
			images['sEtext1'].alpha = 0;
			images['sEtext2'].alpha = 0;
			images['sEtext3'].alpha = 0;
			images['sEtext4'].alpha = 0;
			
			viewStudyButton.x = 1100+viewStudyButton.width;
			TweenMax.killTweensOf(viewStudyButton);
					
			kgCounter.reset();
			kgCounterTwo.reset();
			kgCounterThree.reset();
			
			popup.reset();
		}
	}
}