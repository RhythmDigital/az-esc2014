package 
{	
	import com.greensock.TweenMax;
	import com.greensock.easing.Sine;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.LoaderMax;
	import com.wehaverhythm.carousel.Carousel3D;
	import com.wehaverhythm.carousel.MenuItem;
	import com.wehaverhythm.slideshow.Slideshow;
	import com.wehaverhythm.starling.utils.CustomEvent;
	import com.wehaverhythm.starling.utils.StarlingUtils;
	import com.wehaverhythm.utils.IDestroyable;
	
	import flash.display.Stage;
	import flash.filesystem.File;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.display.Stage;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	
	public class Main extends Sprite implements IDestroyable
	{
		private var stage:flash.display.Stage;
		private var mStarling:Starling;
		private var starlingStage:starling.display.Stage;
		
		private var slideshow:Slideshow;
		private var loaderHarness:LoaderMax;
		
		private var bg:Image;
		private var bgSlideshow:Image;
		
		private var currentSection:String;
		
		private var platform:String;
		public static const IPAD:String = 'ipad';
		public static const AIR:String = 'air';
		
		private var swipeText:Image;
		
		private var popupButton:Quad;
		private var popups:Object;
		
		private var currentPopup:Image;
		private var pdl1BG:Image;
		
		
		public function Main()
		{
			super();		
			loaderHarness = new LoaderMax();
		}
		
		public function init(stage:flash.display.Stage):void
		{			
			this.stage = stage;
			this.starlingStage = Starling.current.stage;
			
			var loader:LoaderMax = new LoaderMax({ onComplete:onInitialLoad });
			loader.append(new ImageLoader(File.applicationDirectory.url + 'assets/bg.jpg', {name:'bg'}));
			
			loader.load();			
			loaderHarness.insert(loader);
		}
		
		private function onInitialLoad(e:LoaderEvent):void
		{
			initBGs();			
			initSlideshow();				
		}
		
		private function initBGs():void
		{			
			bg = StarlingUtils.imageFromBitmap(LoaderMax.getContent('bg').rawContent);
			bg.alpha = 0;
			TweenMax.to(bg, .5, {alpha:1, ease:Sine.easeIn});
			addChild(bg);
			
			bg.addEventListener(TouchEvent.TOUCH, onTouchHomeScreen);
		}
		
		private function onTouchHomeScreen(e:TouchEvent):void
		{
			if (e.touches[0].phase == TouchPhase.BEGAN)
			{
				TweenMax.to(bg, .8, {y:-1080, ease:Sine.easeInOut});
				
				addChild(slideshow);
				slideshow.show();
			}
		}

		private function initSlideshow():void
		{
			slideshow = new Slideshow();
			slideshow.addEventListener(Slideshow.GO_HOME, onGoHome);			
			slideshow.init();
		}
		
		private function onGoHome(e:CustomEvent):void
		{
			reset();
		}
		
		public function reset():void
		{
			TweenMax.to(bg, .8, {y:0, ease:Sine.easeInOut});
			slideshow.hide();
		}
		
		public function destroy():void
		{
			TweenMax.killTweensOf(this);
			TweenMax.killTweensOf(bgSlideshow);
			
			loaderHarness.dispose(true);
			loaderHarness = null;
			
			stage = null;
			starlingStage = null;			
			
			removeChild(slideshow);
			slideshow.removeEventListener(Slideshow.GO_HOME, onGoHome);
			slideshow.destroy();
			slideshow = null;
		}
	}
}

