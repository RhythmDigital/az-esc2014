package com.wehaverhythm.slideshow
{
	import com.astrazeneca.starling.StarlingButton;
	import com.greensock.TimelineMax;
	import com.greensock.TweenMax;
	import com.greensock.easing.Sine;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.LoaderMax;
	import com.wehaverhythm.starling.utils.CustomEvent;
	import com.wehaverhythm.starling.utils.StarlingUtils;
	import com.wehaverhythm.utils.IDestroyable;
	
	import flash.filesystem.File;
	import flash.geom.Point;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.display.Stage;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	
	public class Slideshow extends Sprite implements IDestroyable
	{
		public static var GO_HOME:String = 'GO_HOME';
		public static var SLIDE_COMPLETE:String = 'SLIDE_COMPLETE';
		private var starlingStage:Stage;
		
		private var footer:Image;
		private var settings:Object;

		private var bg:Image;
		
		private var nav:Sprite;
		private var next:StarlingButton;
		private var prev:StarlingButton;
		
		public var slides:Array;
		private var t:TimelineMax;
		public var currentSlide:int;
		public var swipeDistance:int = 30;
		private var sideSlidesScale:Number = .8;
		
		private var swipedX:Number;

		private var files:Array;
		private var slideBy:Number;		
		private var home:Quad;

		private var loader:LoaderMax;
		
		
		public function Slideshow()
		{
			super();
		}
		
		public function init():void
		{
			starlingStage = Starling.current.stage;
			slides = [];
			
			loader = new LoaderMax({ onComplete:onNavImagesLoaded });
			
			loader.append(new ImageLoader(File.applicationDirectory.url + 'assets/bg-slideshow.jpg', {name:'bg'}));
			loader.append(new ImageLoader(File.applicationDirectory.url + 'assets/home.png', {name:'home'}));	
			
			loader.load();
		}
		
		private function onNavImagesLoaded(e:LoaderEvent):void
		{			
			bg = StarlingUtils.imageFromDisplayObject(LoaderMax.getContent('bg'));			
			addChild(bg);
			
			nav = new Sprite();
			addChild(nav);
			
			home = StarlingUtils.imageFromDisplayObject(LoaderMax.getContent('home'));		
			
			prev = new StarlingButton();
			prev.init(false, "prev", File.applicationDirectory.url + 'assets/prev.png', File.applicationDirectory.url + 'assets/prev-down.png');
			
			next = new StarlingButton();
			next.init(false, "next", File.applicationDirectory.url + 'assets/next.png', File.applicationDirectory.url + 'assets/next-down.png');
			
			home.x = prev.x = next.x = 63;
			home.y = 52;
			home.addEventListener(TouchEvent.TOUCH, onTouchHome);
			nav.addChild(home);
			
			prev.y = 928;
			next.y = 798;			
			prev.addEventListener(TouchEvent.TOUCH, onTouchPrev);
			next.addEventListener(TouchEvent.TOUCH, onTouchNext);		
			
			populate();
		}
		
		private function repopulate():void
		{
			killSlides();
			TweenMax.delayedCall(.6, populate);
		}
		
		public function populate():void
		{
			var folderPath:String = File.applicationDirectory.url + 'assets/slideshow/';			
			var folder:File = new File(folderPath);
			var directoryListing:Array = folder.getDirectoryListing();
			
			files = [];
			var file:File;
			
			var slidesLoader:LoaderMax = new LoaderMax({ onComplete:onSlideshowImagesLoaded });
			
			for (var i:int=0; i<directoryListing.length; ++i)
			{
				file = directoryListing[i];
				if (file.name.indexOf('.') > 0) 
				{
					files.push(file);
					slidesLoader.append(new ImageLoader(folderPath + '/' + file.name, {name:file.name}));
				}
			}

			slidesLoader.load();
		}
		
		private function onSlideshowImagesLoaded(e:LoaderEvent):void
		{
			for (var i:int=0; i<files.length; ++i)
			{
				var img:Image = StarlingUtils.imageFromDisplayObject(LoaderMax.getContent(files[i].name));
				img.y = 40;
				slides.push(img);
				
				if (i == 0)
				{
					slides[i].x = Math.floor((1920 - slides[i].width)/2);
					addChildAt(slides[i], 1);
				}
				else {
					slides[i].x = Math.floor(slides[i-1].x + slides[i-1].width + 80);
					addChildAt(slides[i], 1); 
				}
				
				slides[i].alpha = 0;
			}
			
			slides[0].alpha = 0;
			TweenMax.to(slides[0], .3, {delay:.1, alpha:1, ease:Sine.easeIn});

			slideBy = slides[0].width + 80;
			reset();
			show();
			onSlideComplete();
		}
		
		protected function onTouchHome(e:TouchEvent):void
		{
			if (e.touches[0].phase == TouchPhase.BEGAN) dispatchEvent(new CustomEvent(GO_HOME, {}));
		}
		
		protected function onTouchPrev(e:TouchEvent):void
		{
			if (e.touches[0].phase == TouchPhase.BEGAN) showPrevSlide();
		}
		
		protected function onTouchNext(e:TouchEvent):void
		{
			if (e.touches[0].phase == TouchPhase.BEGAN) showNextSlide();
		}
		
		private function getScaledSlidePos(newX:Number):Point
		{
			var p:Point = new Point();
			
			// slides are 1310x988
			p.y = (988 - 988*sideSlidesScale) / 2;
			
			if (newX < 0) p.x = newX + (1310 - 1310*sideSlidesScale)/2;
			else p.x = newX + (1310 - 1310*sideSlidesScale)/2;
			
			return p;
		}
		
		protected function showNextSlide():void
		{
			if (currentSlide < slides.length-1 && !t) 
			{			
				currentSlide++;
				updateNav();
				
				t = new TimelineMax({ onComplete:onSlideComplete });			
				for (var i:int=0; i<slides.length; ++i) 
				{
					var newX:Number = Math.floor(slides[i].x-slideBy);
					var alpha:Number = i == currentSlide ? 1 : newX < 0 ? 0 : 0; // last number here is alpha off right edge...
					
					t.add( TweenMax.to(slides[i], .6, {
						delay:0, 
						alpha: alpha,
						x:newX, 
						ease:Sine.easeInOut}), 0
					);
				}
				
				t.play();	
			}
		}
		
		protected function showPrevSlide():void
		{
			if (currentSlide > 0 && !t) 
			{
				currentSlide--;
				updateNav();
				
				t = new TimelineMax({ onComplete:onSlideComplete });			
				for (var i:int=0; i<slides.length; ++i)
				{
					var newX:Number = Math.floor(slides[i].x+slideBy);
					var alpha:Number = i == currentSlide ? 1 : newX < 0 ? 0 : 0; // last number here is alpha off right edge...
					
					t.add( TweenMax.to(slides[i], .6, {
						delay:0, 
						alpha: alpha,
						x:newX, 
						ease:Sine.easeInOut}), 0 
					);
				}
				t.play();
			}
		}
		
		private function updateNav():void
		{
			currentSlide < slides.length-1 ? nav.addChild(next) : nav.removeChild(next);
			currentSlide > 0 ? nav.addChild(prev) : nav.removeChild(prev);
		}
		
		private function onSlideComplete():void
		{
			t = null;			
			prev.state = StarlingButton.UP;
			next.state = StarlingButton.UP;
			
			dispatchEvent(new CustomEvent(SLIDE_COMPLETE, { slide:currentSlide }));
		}
		
		private function killSlides(doReset:Boolean=false):void
		{
			while (slides.length)
			{
				removeChild(slides[0]);
				slides[0].dispose();
				slides[0] = null;
				slides.shift();
			}
			
			slides = [];
			if (doReset) reset();
		}
		
		public function reset():void
		{
			if (currentSlide > 0)
			{
				for (var i:int = 0; i<slides.length; ++i)
				{
					slides[i].x += Math.floor(currentSlide * slideBy);
					slides[i].alpha = 0;
				}
			}			
			
			currentSlide = 0;
			slides[0].alpha = 1;
			updateNav();
		}
		
		public function show():void
		{
			y = 1080;
			TweenMax.to(this, .8, {y:0, ease:Sine.easeInOut});
			starlingStage.addEventListener(TouchEvent.TOUCH, onStageTouch);
		}
		
		public function hide():void
		{
			TweenMax.to(this, .8, {y:1080, ease:Sine.easeInOut, onComplete:reset});
			starlingStage.removeEventListener(TouchEvent.TOUCH, onStageTouch);
		}
		
		private function onStageTouch(e:TouchEvent):void
		{
			if (e.touches[0].phase == TouchPhase.MOVED)
			{
				swipedX = e.touches[0].globalX - e.touches[0].previousGlobalX;
				if (swipedX > swipeDistance) showPrevSlide();
				if (swipedX < -swipeDistance) showNextSlide();
			}
		}
		
		public function destroy():void
		{
			starlingStage.removeEventListener(TouchEvent.TOUCH, onStageTouch);
			killSlides(false);
			
			footer = null;
			settings = null;
			starlingStage = null;
			slides = null;

			TweenMax.killTweensOf(this);
			
			prev.removeEventListener(TouchEvent.TOUCH, onTouchPrev);
			next.removeEventListener(TouchEvent.TOUCH, onTouchNext);
			
			removeChild(nav);
			nav.dispose();
			nav = null;
			
			prev = null;
			next = null;
		}
	}
}